# POS/KDS Cart and Terminal Requirement Plan

Scope: `apps/mobile/lib/features/pos_kds`

Execution correction:
- Do not restyle the UI.
- Do not move or redesign existing visual sections unless a functional bug cannot be fixed otherwise.
- Prioritize functionality fixes: customer lookup, table selection, payload correctness, order creation, and receipt correctness.

Standards to obey strictly:
- `apps/user/context/ui_standard.md`
- `contexts/code_standard.md`
- Keep edits scoped to POS/KDS unless a backend/mobile contract change is required.
- Do not touch unrelated page elements or unrelated features.
- Use existing Cubit, repo, model, constants, `AppInput`, `AppButton`, `AppBottomAction`, `AppColors`, and ScreenUtil patterns.
- Do not add code comments in Dart/TypeScript.
- Avoid hardcoded strings/statuses in pages; move copy, route fragments, statuses, and labels to constants.

## Current Findings

1. Customer phone search is currently implemented inside `pos.cart.page.dart` instead of the POS/KDS repo and Cubit.
2. The cart page calls `ApiClient().get('/api/v1/pos-kds/customers/$phone')` directly. This is risky because `ApiClient` already owns the base URL and feature code should not hardcode `/api/v1`.
3. The backend customer endpoint is `GET /pos-kds/customers/:phone` under the global API prefix and returns the standard wrapped response shape through `sendSuccess`, meaning mobile should parse `response.data['data']`.
4. The backend returns a list from `findMany`, but the cart page expects one raw object with `res.data['id']`, so matched users are never populated correctly.
5. `_matchingCustomers` is rendered in the UI but is never assigned from the search response.
6. `_onPhoneChanged` only searches when the phone length reaches 10, but the requirement says search from one digit and search again on every digit change.
7. The customer phone input uses a raw `TextField`; standards require `AppInput` for form fields.
8. Dine-in table selection exists in the cart page, but the reported issue says selecting table side is not working. The plan must verify whether the dropdown is failing because tables are not loaded, disabled by null value, not visually clear, or not being carried into the order payload.
9. `placeOrderFromCart` currently sends `customer_id`, but the backend create order service accepts `uid`. This can prevent selected customers from attaching to orders.
10. `OrderModel` does not currently include delivery address, paid amount, payment status, or expanded delivery/status fields required by the new workflow.
11. The backend Prisma `OrderStatus` currently supports `OPEN`, `BILLED`, `PAID`, `CANCELLED`, and `REFUNDED`; requested delivery lifecycle statuses are not yet represented in the schema.
12. The backend order type supports `DINE_IN`, `TAKEAWAY`, `DELIVERY`, `AGGREGATOR`, and `PRE_ORDER`; mobile currently shows only dine-in, takeaway, and delivery.

## Plan

### 1. Fix Customer Search Completely

Goal: Searching by phone must fetch existing users from the first typed digit and update results on every digit change.

Steps:
- Add a POS/KDS customer search endpoint constant for `/pos-kds/customers/:phone`.
- Move customer search out of `pos.cart.page.dart` and into `PosKdsRepo`.
- Add `searchCustomersByPhone(String phone)` to `PosKdsRepo` returning `TaskResult<List<UserModel>>` or a POS-specific customer model if the backend projection is changed.
- Parse the backend wrapped response using `response.data['data']`.
- Add customer search state to `PosKdsState`: matching customers, selected customer, and a dedicated `searchCustomersInfo`.
- Add `searchCustomersByPhone` and `selectCustomer` methods to `PosKdsCubit`.
- In `pos.cart.page.dart`, debounce lightly but allow searching from one digit.
- Sanitize phone search input by trimming and keeping the exact user-entered digits needed by the backend.
- Clear selected customer when the user edits the phone after selecting a customer.
- Render matched customers below the phone input on every successful search.
- Show a small loading effect directly below the phone input while search is running.
- Show an empty result message below the input only after a completed search returns no users.
- Use `AppInput` instead of raw `TextField`.
- Remove direct `ApiClient` construction and direct API calls from the page.
- When a customer is selected, set the phone input text from that customer and store the selected customer id.
- Send the selected customer to create order as `uid`, not `customer_id`, unless the backend contract is intentionally changed to accept `customer_id`.

Acceptance checks:
- Typing `1` triggers a customer search.
- Typing `12`, `123`, etc. triggers a fresh search after debounce.
- Existing users with phone numbers containing the typed sequence appear below the input.
- Selecting a user attaches that user id to the order payload.
- No customer search code remains inside the page except controller handling and Cubit calls.

### 2. Preserve Cart Item UI and Move Qty Adjuster Only

Goal: In the item box only, place the quantity adjuster below the item label without touching other visual elements.

Steps:
- Modify only the cart item row layout inside `pos.cart.page.dart`.
- Keep the item name, veg indicator, price, and total price behavior intact.
- Move the green quantity stepper below the item label/price column.
- Use the standard green quantity stepper style from the UI standard.
- Keep increment/decrement wired to `PosKdsCubit.addToCart` and `removeFromCart`.
- Avoid changing unrelated cards, headers, order type chips, totals, or checkout button.

Acceptance checks:
- Quantity controls are below the item label within each item row.
- Cart totals update correctly after increment/decrement.
- No unrelated POS cart layout changes are introduced.

### 3. Fix Table Selection for Dine-In Orders

Goal: A dine-in order must allow table selection and attach the selected table id to the order.

Steps:
- Confirm `context.read<PosKdsCubit>().listTables()` loads tables when the cart opens.
- Render a loading state in the table section while tables are loading.
- Render a clear empty state if no tables are available.
- Replace the current dropdown if needed with a UI-standard selectable list/chip section so table selection is obvious and reliable.
- Filter out deleted tables and decide whether unavailable tables should be disabled or shown with status labels.
- Store the selected table id in page state or Cubit state consistently.
- Validate that a dine-in order cannot be placed without a selected table.
- Send `table_id` in the create order payload.
- After successful order placement, verify whether the backend should mark the selected table as `OCCUPIED`; if not already done, add that backend update in the order creation flow.

Acceptance checks:
- Dine-in order type shows available tables.
- Tapping/selecting a table visibly marks it selected.
- Place order sends the selected `table_id`.
- The order detail/receipt can show the selected table.

### 4. Add Placeholder UI for Customer History, Offers, Coupons, and Loyalty

Goal: After selecting a user, show UI placeholders for past orders and customer benefits. Backend implementation can be completed later.

Steps:
- Add a compact customer context section under the selected customer area.
- Show "Past Orders", "Available Offers", "Coupons", and "Loyalty" sections as UI-only placeholders.
- Use cards/rows that match the UI standard: white background, `AppColors.borderGrey`, `AppColors.shadowColor`, `12.r` to `16.r`, ScreenUtil sizes, Outfit text.
- Keep data dummy/local-only for now and clearly isolate it in constants or a local private builder until backend integration is requested.
- Do not block order placement if these sections have no real data.
- Design the section so it can later be fed by CRM endpoints for coupons and loyalty.

Acceptance checks:
- The UI appears only when a customer is selected or when the design intentionally supports anonymous placeholders.
- No fake data is submitted with the order.
- The UI does not disrupt table selection, order type, cart items, or totals.

### 5. Delivery Address Selection and Order Attachment

Goal: Pressing the delivery option must show all addresses of the selected user, allow selecting one, and attach the selected address to the order.

Steps:
- Confirm the customer search response includes user addresses. If not, update backend `findUserByPhone` to include addresses for `entity_type: USER` and the user id.
- Add selected address state to POS/KDS state or page state.
- When `DELIVERY` is selected, show a user address section below order type.
- If no customer is selected, show a compact prompt to select a customer first.
- If the selected customer has addresses, show each address as a selectable card.
- If no address exists, show an empty UI placeholder for now without building address creation unless explicitly requested.
- Add `delivery_address_id` or `delivery_address` to `OrderModel` and the create order payload.
- Update backend order schema/API only if the database currently has no field for storing the selected delivery address.
- Prefer storing `delivery_address_id` if addresses are stable records; use a snapshot object only if orders must preserve the address text even after user address edits.
- Validate that delivery orders require a selected address before placing the order.

Acceptance checks:
- Selecting delivery reveals the selected user's addresses.
- Tapping an address visually marks it selected.
- Delivery order payload includes the selected address field.
- Dine-in and takeaway orders are not forced to select an address.

### 6. Paid Amount, Paid/Unpaid, Cancellation, Delivery Statuses, and Other Status Options

Goal: The order workflow must support payment amount, payment state, cancellation, and all necessary fulfillment/delivery statuses.

Steps:
- Define order and payment status constants in POS/KDS constants instead of hardcoding status strings.
- Review backend Prisma enums and decide the final status model:
  - Existing `OrderStatus`: `OPEN`, `BILLED`, `PAID`, `CANCELLED`, `REFUNDED`.
  - Needed fulfillment/delivery statuses: likely `PLACED`, `ACCEPTED`, `PREPARING`, `READY`, `OUT_FOR_DELIVERY`, `DELIVERED`, `FAILED`, `RETURNED`, `NO_SHOW`.
  - Needed payment state: `UNPAID`, `PARTIALLY_PAID`, `PAID`, `REFUNDED`.
- Avoid mixing payment state and fulfillment state into one field if possible. Prefer separate fields:
  - `status` for order lifecycle.
  - `payment_status` for payment state.
  - `delivery_status` for delivery lifecycle when order type is `DELIVERY`.
  - `paid_amount` for amount collected.
- If backend schema changes are required, update Prisma schema, DTO/type, repo, service, controller, and mobile model together.
- Add paid amount input in cart checkout/payment section using `AppInput`.
- Add payment method selector using constants.
- Add paid/unpaid toggle using `AppToggle` or a UI-standard segmented control.
- Add order status selector where appropriate, not crowding the main checkout action.
- Ensure cancelling an order calls the existing cancel endpoint and frees the table if needed.
- Ensure paying an order calls the existing pay endpoint with `payment_method` and `amount`.
- If paid amount is less than total, mark payment as partial instead of fully paid.
- Keep the Place Order CTA behavior clear: creating an order should not silently mark it paid unless the paid controls explicitly say so.

Acceptance checks:
- Order can be created as unpaid.
- Order can be created/updated with paid amount.
- Paid amount cannot exceed the payable amount unless overpayment is intentionally supported.
- Cancellation remains available through the proper endpoint.
- Delivery status options are visible for delivery orders only.
- Backend and mobile model fields use snake_case names.

### 7. Receipt and Order Detail Alignment

Goal: Receipt and detail pages must display the new order data without breaking current behavior.

Steps:
- Update `OrderModel` to parse selected user, table, payment fields, delivery address field, and status fields.
- Update receipt page to show selected table, selected customer, order type, delivery address when applicable, paid amount, balance due, and status.
- Avoid assuming `table_id` is the table number; use included table data if backend provides it, otherwise show a safe fallback.
- Keep receipt navigation after successful order placement working.
- Store `lastPlacedOrder` correctly in `PosKdsState` when create order succeeds so receipt does not have to refetch blindly.

Acceptance checks:
- Receipt opens after order placement.
- Receipt shows the actual selected table/customer/address/payment details when available.
- Existing order list/detail screens still load and render.

### 8. Backend Contract Work If Needed

Goal: Mobile must not guess fields the backend does not support.

Steps:
- Update POS/KDS customer search backend to return users with addresses if delivery address selection depends on it.
- Confirm phone matching works as contains/regex-like search from one digit.
- If true regex is required, implement safe database-supported filtering without exposing unsafe regex input.
- Add order address/payment/delivery fields to Prisma only after confirming the desired data shape.
- Run Prisma generate after schema changes.
- Keep repository mutations transactional where required by `code_standard.md`.
- Add user logs for backend mutations if touching create/update/delete logic.
- Keep all backend constants in POS/KDS constants and avoid hardcoded success/error strings.

Acceptance checks:
- Backend customer route returns a wrapped list of users.
- Mobile parsing matches backend response shape.
- Order create accepts and persists all fields sent by mobile.

### 9. UI Standards Checklist

Every touched mobile UI file must satisfy:
- Manual app bar inside `Scaffold.body` where the page is being brought into standard compliance.
- `AppInput` for phone and paid amount.
- `AppToggle` for boolean paid/unpaid state if a toggle is used.
- `AppButton` for primary actions.
- `AppBottomAction` for bottom primary checkout action if the existing bottom action is refactored.
- All dimensions use `.w`, `.h`, `.sp`, and `.r`.
- Colors come from `AppColors` where possible.
- Loading indicators are small, thin, and scoped to the specific searching/placing action.
- No raw `TextField` for form fields.
- No hardcoded strings in pages after the relevant constants are added.
- No comments in Dart files.

### 10. Verification Plan

Run from `apps/mobile` after implementation:
- `flutter analyze`
- Targeted Flutter tests if present.
- Manual test: cart opens with existing items.
- Manual test: phone search starts from one digit and updates on every digit.
- Manual test: customer selection updates selected customer UI.
- Manual test: dine-in table selection attaches `table_id`.
- Manual test: takeaway order does not require table/address.
- Manual test: delivery order requires customer address and attaches it.
- Manual test: quantity adjuster remains functional after moving below item label.
- Manual test: unpaid order creation works.
- Manual test: paid/partial paid fields are sent correctly.
- Manual test: receipt shows selected order data.

## Implementation Order

1. Fix customer search repo/Cubit/state and page wiring.
2. Fix customer search UI loading/results below `AppInput`.
3. Fix create order customer id field from `customer_id` to `uid`.
4. Move cart item quantity adjuster below item label only.
5. Stabilize dine-in table selection and order payload.
6. Add selected customer placeholder UI for past orders, offers, coupons, and loyalty.
7. Add delivery address selection UI and payload field.
8. Add paid amount, paid/unpaid, payment method, and status controls.
9. Align `OrderModel`, receipt, order detail, and backend contract.
10. Run verification and clean any analyzer issues.
