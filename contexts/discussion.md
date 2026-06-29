Look, I am in a big hurry so i am writing my requirements and based on that you have to make a complete comprehensive case study on what we exactly have to do very descriptively, complete ignore what direction we are going just tell me what exactly we need to do's to achieve my requirements end to end

mobile (employee's app):

- First of all there should be a auth screen where the employee will login with his credentials (phone/gmail google)
- it will check if he already a employee pf any branch, if yes, it will redirect to home/main app page
- if no, then the employee have two option to either send a request to join a branch or create its own branch
- if he creates, some bootstrap process will happen such as role creation as Owner having permission ["ALL"]
- now
- i want only these operations for now
- 1. if we are buying any thing in bulk such as goods, rations, etc, i need a system to audit everything and record everything and have a documented data for it with tracking it
- 2. if any of the worker/employee using those goods i want to have a track of that
- 3. we will be having 3 kind of order channels - online, takeaway, chair from each table order system
- 4. i want to have a system where the kitchen guys can see all kind of orders and update the status and assign themselves
- 5. i want a system where the finance will have a centralized record of truth

user (costumer/public app)

- auth system to save costumers
- offer/coupon system for costumers to activate/claim those coupons and its usage
- loyalty system for costumers
- menu presentation
- order placement
- delivery tracking

---

# CASE STUDY

## Overview

This case study maps your stated requirements to what needs to be built, end to end, across three layers: the backend API (`apps/api`), the employee mobile app (`apps/mobile`), and the customer mobile app (`apps/user`). Each section describes exactly what needs to exist and what it needs to do.

The database schema is already fully designed. The API infrastructure (Express, Prisma, Socket.IO, Firebase) is already in place. What does not exist yet is any actual feature implementation: no controllers, no services, no repositories, no routes, and no wired mobile cubits. Everything described below needs to be built from scratch on top of the existing skeleton.

---

## PART 1 — Employee App (apps/mobile)

---

### Feature 1: Authentication & Branch Onboarding

#### What This Is

The entry point of the entire staff-facing system. An employee opens the app, signs in, and the system decides where to send them based on whether they are already linked to a branch.

#### What Needs to Be Built

**API — Auth Feature**

- `POST /api/v1/auth/login`
  Accepts a Firebase ID token (from Google Sign-In or phone auth). The API verifies it via Firebase Admin, finds or creates a `User` record in PostgreSQL, generates a JWT, and returns the user object plus token.

- `GET /api/v1/auth/me`
  Protected endpoint. Validates the JWT, fetches the user's full record, checks if a linked `Employee` record exists, and returns `{ user, employee: null | EmployeeRecord }`. The mobile app calls this on every startup to decide the redirect.

- `POST /api/v1/branch/create`
  Creates a new `Branch` record (name, code). Then bootstraps: creates a `Role` named "Owner" with `permissions: ["ALL"]`. Creates an `Employee` record linking the calling user to the new branch with that Owner role. Returns the created branch and employee context.

- `POST /api/v1/branch/join-request`
  Creates a pending join request record (use `UserLog` or a dedicated join request table). Stores `uid`, `branch_id`, and optionally `requested_role_id`.

- `GET /api/v1/branch/search?q=`
  Searches branches by name or code. Returns a list of matching branches for the employee to browse and pick from.

- `GET /api/v1/branch/join-requests` (manager-only)
  Lists pending join requests for the calling user's branch.

- `POST /api/v1/branch/join-requests/:id/approve`
  Manager approves a request. Creates the `Employee` record with the assigned role.

- `POST /api/v1/branch/join-requests/:id/reject`
  Manager rejects the request.

**Mobile — Auth Feature (`features/auth/`)**

- `auth.page.dart` — Login screen with Google Sign-In button and Phone auth option.
- `auth.repo.dart` — Calls Firebase Sign-In SDK, sends ID token to `POST /auth/login`, saves JWT via `LocalStorage`.
- `auth.cubit.dart` — Manages login state, calls `auth.repo`, on success triggers the session gate.
- `auth.state.dart` — States: idle, loading, authenticated, error.
- `auth.model.dart` — `UserModel` with `id`, `name`, `phone`, `email`, `token`, `created_at`, `updated_at`.

**Mobile — Onboarding Feature (`features/onboarding/`)**

- `onboarding.page.dart` — Two-option screen: "Join a Branch" or "Create a Branch".
- `branch_search.page.dart` — Search page listing branches, select one and submit join request.
- `create_branch.page.dart` — Form to enter branch name and code, triggers bootstrap.
- `onboarding.repo.dart` — Calls `GET /auth/me`, `POST /branch/create`, `GET /branch/search`, `POST /branch/join-request`.
- `onboarding.cubit.dart` — Manages routing logic: if `employee != null` push to home; if pending request show pending screen; else show onboarding options.
- `pending_approval.page.dart` — A static waiting screen shown when the employee has a pending join request.

**Session Gate Logic (startup)**

On every app cold start, call `GET /auth/me`. Three outcomes:
1. Employee record exists and is ACTIVE → push to Home.
2. Employee record exists but is pending (join request sent) → push to Pending Approval screen.
3. No employee record → push to Onboarding.
4. No valid token at all → push to Login.

---

### Feature 2: Procurement Audit — Bulk Goods Purchasing

#### What This Is

Every time the business buys goods (rations, ingredients, packaging, supplies) in bulk, every detail must be recorded: what was ordered, from whom, at what price, what actually arrived, and what was returned. This creates a fully auditable paper trail.

#### What Needs to Be Built

**API — Inventory Feature**

- `POST /api/v1/inventory/suppliers` — Create a supplier (name, contact, tax number).
- `GET /api/v1/inventory/suppliers` — List suppliers for the branch.
- `POST /api/v1/inventory/items` — Create an inventory item (name, type, category).
- `GET /api/v1/inventory/items` — List all items with their variants.
- `POST /api/v1/inventory/items/:id/variants` — Add a variant (SKU, UOM, base cost, min stock level).
- `POST /api/v1/inventory/purchase-orders` — Create a Purchase Order (supplier, list of line items with qty and unit price). Status defaults to DRAFT.
- `PATCH /api/v1/inventory/purchase-orders/:id/send` — Change PO status to SENT (marks it as dispatched to supplier).
- `POST /api/v1/inventory/purchase-orders/:id/receive` — Record a Goods Receipt. Creates a `GoodsReceipt` record. Updates PO status to PARTIALLY_RECEIVED or RECEIVED. For each received line item, creates a `StockLedger` entry with `transaction_type: PURCHASE`, increments running balance.
- `POST /api/v1/inventory/purchase-orders/:id/return` — Create a `VendorReturn` record with reason and refund value. Creates a `StockLedger` entry with `transaction_type: RETURN`, decrements running balance.
- `GET /api/v1/inventory/purchase-orders` — List all POs with their current status and line items.
- `GET /api/v1/inventory/purchase-orders/:id` — Full detail view of one PO including receipt history and returns.
- `GET /api/v1/inventory/stock` — Current stock levels per variant (last running_balance from StockLedger per variant).

**Mobile — Inventory Feature (`features/inventory/`)**

- `supplier.model.dart`, `purchase_order.model.dart`, `stock_ledger.model.dart`, `item_variant.model.dart`
- `inventory.repo.dart` — All API calls above.
- `inventory.cubit.dart` + `inventory.state.dart` — State per operation (loadInfo, createInfo, receiveInfo).
- Pages:
  - `supplier_list.page.dart` — List suppliers, add new.
  - `item_list.page.dart` — Browse items and variants, add new.
  - `purchase_order_list.page.dart` — List all POs with status badges.
  - `purchase_order_detail.page.dart` — Full PO detail: line items, receipt log, return log.
  - `create_purchase_order.page.dart` — Form: pick supplier, add line items (item variant + qty + price).
  - `receive_goods.page.dart` — Mark goods as received per PO.
  - `stock_levels.page.dart` — Dashboard showing current stock per item variant with low-stock highlights.

---

### Feature 3: Employee Goods Usage Tracking

#### What This Is

When a worker consumes or uses inventory items in the course of their work (e.g. a cook uses 2kg of flour), this must be logged. This connects to the `StockLedger` and `WastageLog` models.

#### What Needs to Be Built

**API — Usage & Wastage Endpoints**

- `POST /api/v1/inventory/usage` — Log a stock consumption event. Creates a `StockLedger` entry with `transaction_type: PRODUCTION_OUT` (or a new USAGE type). Records `variant_id`, `quantity_change` (negative), `reference_id` (optional: batch or shift ID), `created_by` (employee ID).
- `POST /api/v1/inventory/wastage` — Log a wastage event. Creates a `WastageLog` record and a `StockLedger` entry with `transaction_type: WASTAGE`. Records reason, quantity, and `logged_by`.
- `GET /api/v1/inventory/usage-log` — List all usage events for the branch, filterable by employee, date range, and item variant.
- `GET /api/v1/inventory/wastage-log` — List all wastage events, filterable by date and item.

**Mobile — Usage Tracking (inside `features/inventory/`)**

- `log_usage.page.dart` — Form: pick item variant, enter quantity used, optional note. Submits to usage endpoint.
- `log_wastage.page.dart` — Form: pick item variant, enter quantity, enter reason. Submits to wastage endpoint.
- `usage_log.page.dart` — Scrollable list of all usage events. Shows employee name, item, quantity, and timestamp.
- `wastage_log.page.dart` — Same pattern for wastage events.

---

### Feature 4: Order Management — Three Channels

#### What This Is

Orders come in through three channels: online (via the customer app), takeaway (walk-in, no table), and dine-in (table-assigned). All three produce the same `Order` record but with different `order_type` values and optional table assignment.

#### What Needs to Be Built

**API — Order Feature**

- `POST /api/v1/orders` — Create an order. Body includes `order_type` (DINE_IN, TAKEAWAY, DELIVERY), optional `table_id`, optional `uid` (customer), list of `OrderItem`s (menu_item_id + qty + notes). Calculates subtotal, applies tax. Status defaults to OPEN. After creation, auto-creates a `KitchenOrderTicket` for each relevant kitchen station based on item categories.
- `GET /api/v1/orders` — List orders for the branch. Filterable by status, order_type, and date.
- `GET /api/v1/orders/:id` — Full order detail with items and KOT statuses.
- `PATCH /api/v1/orders/:id/bill` — Change status to BILLED. Generates bill totals.
- `PATCH /api/v1/orders/:id/pay` — Record payment. Creates `AdvancePayment` record. Changes status to PAID. Creates `StockLedger` SALE entries for each sold item variant. Creates `LedgerEntry` for revenue account. If customer is linked, awards `LoyaltyTrans` points (EARNED).
- `PATCH /api/v1/orders/:id/cancel` — Cancel order. Reverses any stock movements.
- `GET /api/v1/tables` — List tables with current status (AVAILABLE / OCCUPIED).
- `PATCH /api/v1/tables/:id/status` — Update table status.
- `GET /api/v1/menu` — Public + authenticated endpoint. Returns all active MenuCategories with their MenuItems (used by both staff app and customer app).

**Mobile — POS Feature (`features/pos/`)**

- `order_list.page.dart` — Live list of all open orders. Color-coded by order_type. Tapping opens detail.
- `create_order.page.dart` — POS screen: browse menu by category, add items, select table (for dine-in), confirm and place order.
- `order_detail.page.dart` — Full order view: items, KOT statuses, bill total, payment button.
- `table_map.page.dart` — Visual grid of tables showing status. Tap an occupied table to open its active order.
- `pos.repo.dart`, `pos.cubit.dart`, `pos.state.dart` — Standard cubit pattern. State holds: orders list, active order, tables list, menu.

---

### Feature 5: Kitchen Display System (KDS)

#### What This Is

When an order is placed, Kitchen Order Tickets (KOTs) are created for the relevant kitchen stations. Kitchen staff see a live board of all pending tickets, can claim a ticket, update its status, and mark it as ready or served. This board updates in real time via WebSocket.

#### What Needs to Be Built

**API — KDS Feature**

- `GET /api/v1/kds/tickets` — List all KOTs for the branch, optionally filtered by station and status.
- `PATCH /api/v1/kds/tickets/:id/assign` — Employee assigns themselves to a ticket (`assigned_to` field). Emits Socket.IO event `kot:updated` to all clients in the branch room.
- `PATCH /api/v1/kds/tickets/:id/status` — Update KOT status (PREPARING → READY → SERVED). Emits `kot:updated` Socket.IO event.
- Socket.IO: on order creation, emit `order:new` to the branch room. On KOT status change, emit `kot:updated`. Kitchen display clients subscribe to the branch room on connect.

**Mobile — KDS Feature (`features/kds/`)**

- `kds.page.dart` — Full-screen board showing KOT cards. Each card shows: order number, order type, items, station, current status, and assigned employee. Cards auto-update via WebSocket events.
- `kds.repo.dart` — HTTP calls for initial ticket fetch and status updates. Also manages WebSocket subscription to the branch Socket.IO room.
- `kds.cubit.dart` + `kds.state.dart` — State holds list of tickets. On WebSocket `kot:updated` event, cubit replaces the relevant ticket in state and triggers a UI refresh.
- Filter bar on the KDS page to show tickets by station (HOT_FOOD, BAKERY, DRINKS, etc.).

---

### Feature 6: Finance — Centralized Record of Truth

#### What This Is

Every money movement in the business (sales revenue, purchase costs, wages, wastage write-offs) must be recorded in the double-entry ledger system. The finance module gives managers a single source of truth for all financial activity.

#### What Needs to Be Built

**API — Finance Feature**

- `POST /api/v1/finance/accounts` — Create a chart-of-accounts entry (name, account_type: ASSET / LIABILITY / EQUITY / REVENUE / EXPENSE).
- `GET /api/v1/finance/accounts` — List all accounts for the branch.
- `GET /api/v1/finance/ledger` — List all ledger entries. Filterable by account, date range, and reference type.
- `GET /api/v1/finance/summary` — Aggregated P&L summary: total revenue, total purchase cost, total wastage write-offs, net position. Computed by summing credits and debits per account type.
- Auto-posting rules (triggered by other features, not manual API calls):
  - On order PAID → credit Revenue account, debit Cash/Card/Online account.
  - On PO Goods Receipt → debit Inventory/Asset account, credit Accounts Payable.
  - On WastageLog → debit Wastage Expense account, credit Inventory account.
  - On RoyaltyTrans → debit Royalty Expense account, credit Royalties Payable.

**Mobile — Finance Feature (`features/finance/`)**

- `account_list.page.dart` — List all accounts with their current balance (sum of debit minus credit).
- `ledger_entries.page.dart` — Scrollable, searchable list of every ledger entry. Shows: date, account, debit, credit, reference type, and reference ID.
- `finance_summary.page.dart` — Dashboard cards: Total Revenue, Total Costs, Gross Profit, and a breakdown by account type.
- `finance.repo.dart`, `finance.cubit.dart`, `finance.state.dart` — Standard pattern.

---

## PART 2 — Customer App (apps/user)

---

### Feature 1: Customer Authentication

#### What This Is

Customers sign in once to get a persistent identity. Their order history, loyalty points, complaints, and coupon usage are all tied to this identity.

#### What Needs to Be Built

**API**

- Reuse the same `POST /api/v1/auth/login` endpoint (same Firebase ID token flow). The API creates a `User` record if one does not exist. Returns user object and JWT. No `Employee` record is created for customers.

**Mobile — Customer Auth Feature (`features/auth/`)**

- `auth.page.dart` — Google Sign-In and Phone auth options.
- `auth.repo.dart` — Same Firebase + API token exchange flow as the staff app. Saves JWT.
- `auth.cubit.dart` + `auth.state.dart` — On success, navigate to home.

---

### Feature 2: Menu Presentation

#### What This Is

Customers browse the menu before placing an order. They see categories, items, descriptions, prices, and images.

#### What Needs to Be Built

**API**

- `GET /api/v1/menu?branch_id=` — Returns all active `MenuCategory` records with nested active `MenuItem` records (display_name, description, selling_price, image_url).

**Mobile — Store Feature (`features/store/`)**

- `store.page.dart` — Category tab bar at the top. Scrollable item grid or list below. Tapping an item opens a detail sheet with description, price, modifier options, and an "Add to Cart" button.
- `menu_item_detail.page.dart` — Item detail with modifier group selection (e.g. size, add-ons).
- `store.repo.dart`, `store.cubit.dart`, `store.state.dart` — Fetches menu on load. Holds cart state locally (list of selected items with chosen modifiers and quantities).

---

### Feature 3: Order Placement

#### What This Is

The customer assembles a cart and places an order. Order type will be DELIVERY or TAKEAWAY from the customer app.

#### What Needs to Be Built

**API**

- `POST /api/v1/orders` — Same endpoint used by the staff POS. Customer JWT is used to attach `uid`. `order_type` will be DELIVERY or TAKEAWAY.
- `GET /api/v1/orders?uid=` — Fetch order history for the logged-in customer.
- `GET /api/v1/orders/:id` — Order detail view.

**Mobile — Order Feature (`features/order/`)**

- `cart.page.dart` — Cart summary with item list, quantities, modifiers, subtotal, and a Place Order button.
- `checkout.page.dart` — Collect delivery address or confirm takeaway. Apply coupon code. Show total with discount. Submit order.
- `order_history.page.dart` — List of past orders with status and total.
- `order_tracking.page.dart` — Live status view of the active order (OPEN → BILLED → PAID; KOT statuses PREPARING → READY → SERVED). Updates via WebSocket subscription or polling.
- `order.repo.dart`, `order.cubit.dart`, `order.state.dart` — Standard pattern. Cart state is local; order state comes from API.

---

### Feature 4: Coupon & Offer System

#### What This Is

Customers can enter a coupon code at checkout to receive a discount. The system validates the code, checks eligibility (min order value, expiry, usage limits), applies the discount, and records the usage.

#### What Needs to Be Built

**API**

- `POST /api/v1/coupons/validate` — Body: `{ code, order_subtotal }`. Returns: `{ valid: true, discount_amount, coupon }` or an error. Checks: code exists, not expired, status ACTIVE, order_subtotal >= min_order_val, discount not exceeding max_discount.
- `POST /api/v1/coupons/redeem` — Called when order is placed with a coupon. Records the usage (you may add a `CouponUsage` join table tracking `uid + coupon_id`). Applies discount to the order total.
- `GET /api/v1/coupons` (staff/manager) — List all coupons. Create, activate, deactivate.

**Mobile — Customer App**

- Coupon code input field on `checkout.page.dart`. On submit, calls validate endpoint. Shows discount applied or error message.
- `coupon.model.dart` inside the order feature.

---

### Feature 5: Loyalty System

#### What This Is

Customers earn points on every paid order. They can redeem points for discounts on future orders. All point transactions are recorded.

#### What Needs to Be Built

**API**

- Points are awarded automatically on `PATCH /api/v1/orders/:id/pay`. Creates a `LoyaltyTrans` record with `trans_type: EARNED` and `points` computed from total_amount (e.g. 1 point per currency unit, configurable).
- `GET /api/v1/loyalty/balance?uid=` — Returns the sum of all EARNED minus REDEEMED points for the user.
- `GET /api/v1/loyalty/history?uid=` — Returns full transaction history.
- `POST /api/v1/loyalty/redeem` — Called at checkout if the customer chooses to use points. Creates a `LoyaltyTrans` record with `trans_type: REDEEMED`. Deducts from order total up to the points balance.

**Mobile — Customer App**

- `loyalty.page.dart` — Shows current points balance, points history (earned / redeemed per order), and an option to redeem at checkout.
- Points balance and a "Use Points" toggle shown on `checkout.page.dart`.
- `loyalty.model.dart` + `loyalty.repo.dart` inside the home or order feature.

---

### Feature 6: Delivery Tracking

#### What This Is

After an order is placed with `order_type: DELIVERY`, the customer can track its status in real time from their app.

#### What Needs to Be Built

**API**

- Order status updates (OPEN → BILLED → PAID) and KOT statuses (PREPARING → READY → SERVED) are already emitted via Socket.IO.
- `PATCH /api/v1/orders/:id/assign-partner` (staff) — Assign a `DeliveryPartner` to the order. Emits `order:updated` Socket.IO event.
- `PATCH /api/v1/orders/:id/dispatch` — Marks the order as out for delivery. Emits `order:dispatched`.
- `PATCH /api/v1/orders/:id/delivered` — Marks the order as delivered.

**Mobile — Customer App**

- `order_tracking.page.dart` — Visual step tracker showing: Order Placed → Preparing → Ready → Out for Delivery → Delivered. Each step lights up as the status progresses. Subscribes to the Socket.IO branch room for the active order and reacts to `order:updated` and `kot:updated` events.
- Delivery partner name shown when assigned.

---

## PART 3 — What to Build and In What Order

This is the recommended build sequence to go end to end, unblocking each layer before the next.

### Phase 1 — API Auth + Branch Bootstrap

Build first because everything else depends on a verified user and a branch context.

1. `POST /auth/login` — Firebase token verification, user create/find, JWT issue.
2. `GET /auth/me` — Session validation, employee lookup.
3. `POST /branch/create` — Branch creation + Owner role + Employee record bootstrap.
4. `GET /branch/search` + `POST /branch/join-request` — Join flow.
5. `GET /branch/join-requests` + approve/reject — Manager approval flow.

### Phase 2 — Mobile Auth + Onboarding

Wire the mobile auth feature to Phase 1 API. Implement session gate routing.

### Phase 3 — Menu API + Customer App Store

Build the menu endpoint and the customer app store feature. This unblocks order placement from both apps.

### Phase 4 — Order API + Staff POS Mobile

Build the order creation, table management, and payment flow. This unblocks KDS and Finance.

### Phase 5 — Customer App Order Placement + Order History

Wire the customer app cart and checkout to the order API.

### Phase 6 — KDS API + Socket.IO + Staff KDS Mobile

Build ticket management, real-time broadcast, and the staff KDS screen.

### Phase 7 — Customer App Order Tracking

Wire the customer tracking screen to Socket.IO order events.

### Phase 8 — Inventory / Procurement API + Mobile

Build supplier management, purchase orders, goods receipt, stock ledger, usage logging, and wastage logging. Wire all mobile procurement screens.

### Phase 9 — Finance API + Mobile

Build the chart of accounts, auto-posting ledger entries, and the finance summary. Wire finance screens.

### Phase 10 — Coupon, Loyalty, and Delivery Tracking

Build coupon validation and redemption. Build loyalty point earn/redeem. Build delivery partner assignment and dispatch status. Wire all customer app features.

---

## PART 4 — What Already Exists vs. What Needs to Be Created

| Layer | Already Exists | Needs to Be Created |
|---|---|---|
| Database | Full schema with all 50+ tables and relations | Nothing — schema is complete |
| API Infrastructure | Express app, Prisma client, Socket.IO manager, Firebase Admin, Zod config, Winston logger, error middleware | Every single feature: types, repos, services, controllers, routes |
| API Routes | Empty router (all routes commented out) | All routes registered in src/routes/index.ts |
| Mobile Staff App | Folder skeleton for all 7 modules, core setup, DI, theme, AppColors, AppButton, AppInput | Every model, repo, cubit, state, and page file |
| Mobile Customer App | Folder skeleton for auth/home/order/store/setting | Every model, repo, cubit, state, and page file |
| Real-Time | socket.manager.ts initialised | Room management, event emission in order and KDS controllers, client subscription in mobile |
