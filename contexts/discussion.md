# Customer Identity And Google Login Implementation Plan

## 1. Problem Summary

The current order flow can create orders without a real user identity when the vendor enters a customer phone number and no existing user is found. That creates guest-like orders, breaks customer history, and later makes it impossible to reliably merge vendor-created orders with customer self-service orders.

The required behavior is:

- A vendor-entered phone number must always resolve to a real `User.id`.
- If the phone number is new, the system must create a user automatically and return that new `uid`.
- If the phone number has no country code, it must default to India by adding `+91`.
- The next lookup for that phone number must return the created user.
- Customer self-ordering on web and mobile must move away from phone OTP login because SMS/Twilio cost is not acceptable.
- Customer self-ordering must use Google login.
- After Google login, if the user has no phone number, the app must force a phone number capture step before allowing normal app usage or order placement.
- Phone capture requires no OTP, but must enforce duplicate phone rules.
- If the entered phone already belongs to another account with an email, the app must show that the number is already registered with another account.
- If the entered phone belongs to a phone-only account with no email, the system must merge the Google account into that phone account, keep the phone account as the primary user, move all related data, delete or deactivate the temporary Google account, issue fresh tokens for the primary account, and refresh local auth state.

## 2. Target Identity Rules

### 2.1 Canonical Phone Format

All phone numbers must be normalized in the API before lookup or save.

Rules:

- Trim spaces, dashes, brackets, and other visual separators.
- If the value starts with `+`, keep the country code and normalize digits.
- If the value has exactly 10 digits and no country code, store it as `+91XXXXXXXXXX`.
- If the value has digits but no plus and is not 10 digits, prefix `+` and validate it as an international number.
- Reject impossible values with a clear validation error.
- Store only one canonical phone value in `User.phone`.
- Never compare raw phone strings in business logic.

### 2.2 User Types

There should not be a separate guest order identity. Every order must have one of these real user identities:

- Vendor-created phone user: created from POS customer search when phone is unknown.
- Google user with phone: normal customer account.
- Google user without phone: temporary incomplete account that cannot place orders until phone is added or merged.

### 2.3 Account Priority

If two user rows must be merged, the phone user is the primary account when it already existed before Google login, because vendor-created orders and customer history may already point to it.

Priority order:

1. Existing phone account with order history.
2. Existing phone account without email.
3. Google account only when no phone account exists.

## 3. Backend Plan

### 3.1 Add Identity Constants

Update `apps/api/src/features/core_hr/core_hr.constant.ts`.

Add constants for:

- Phone required.
- Invalid phone.
- Phone already registered with another account.
- Phone merge completed.
- Google login requires phone.
- Account merge failed.
- Customer created from POS phone lookup.

Keep all new constant keys in the existing API constant style.

### 3.2 Add Phone Normalization Utility

Create a small core/user utility in the API, preferably under `apps/api/src/features/core_hr/`.

Required functions:

- `normalizePhoneNumber(rawPhone: string): string`
- `isPhoneOnlyUser(user): boolean`
- `isGoogleBackedUser(user): boolean`

This utility must be used by:

- `sendOtp`, while OTP still exists during transition.
- Google phone completion.
- POS customer lookup/create.
- Any future profile phone update.

### 3.3 Vendor POS Customer Lookup Must Never Return Empty For A Valid New Phone

Current flow:

- Vendor enters phone.
- API searches users.
- If no user is found, frontend can continue without `uid`.

Required flow:

1. Add or update an API service method like `findOrCreateCustomerByPhone(phone)`.
2. Normalize the phone.
3. Search `User.phone`.
4. If found, return the user.
5. If not found, create a user:
   - `id`: use existing ID generation approach.
   - `phone`: normalized phone.
   - `name`: a safe default such as `Customer <last4>`, stored in constants.
   - `email`: null.
   - `avatar`: null.
   - `status`: active default.
6. Return the created user in the same response shape as search results.
7. Update POS create-order validation so customer phone flows cannot submit a customer order without `uid` when the phone is valid.

Repository requirements:

- Use Prisma through `CoreHrRepo` or the existing relevant repo.
- Wrap user creation in a transaction.
- Write `UserLog` for auto customer creation.
- Do not create duplicate users under race conditions. Use the unique phone constraint and catch unique conflict by re-reading the user.

### 3.4 Google Login API Shape

Keep one backend login endpoint if possible:

- `POST /hr/auth/login`

For Google login:

Request:

```json
{
  "idToken": "google-id-token"
}
```

Response when phone exists:

```json
{
  "user": {},
  "employee": null,
  "addresses": [],
  "bankDetails": [],
  "tokens": {
    "accessToken": "",
    "refreshToken": ""
  },
  "requires_phone": false
}
```

Response when Google account has no phone:

```json
{
  "user": {},
  "tokens": {
    "accessToken": "",
    "refreshToken": ""
  },
  "requires_phone": true
}
```

The access token may be valid, but the client must route only to the phone capture page until `requires_phone` is false.

### 3.5 Add Complete Phone Endpoint

Add an authenticated endpoint:

- `POST /hr/auth/complete-phone`

Request:

```json
{
  "phone": "9876543210"
}
```

Behavior:

1. Authenticate current Google user from token.
2. Normalize phone.
3. Find `User` by normalized phone.
4. If no phone user exists:
   - Update current Google user with the phone.
   - Return updated user and tokens.
5. If phone user exists and it is the same user:
   - Return current user and tokens.
6. If phone user exists and has an email:
   - Return validation error: phone already registered with another account.
7. If phone user exists and has no email:
   - Merge current Google user into phone user.
   - Keep phone user id as primary.
   - Copy Google fields into phone user when missing:
     - `email`
     - `name`
     - `avatar`
   - Move all related records from temporary Google user id to phone user id.
   - Delete or soft-delete the temporary Google user after related records move.
   - Invalidate old sessions for the temporary Google user.
   - Create a new session for the primary phone user.
   - Return fresh tokens for the phone user.

### 3.6 Merge Scope

The merge must update every table that references `User.id` through a `uid`, `created_by`, `updated_by`, `entity_id`, or recipient field.

Minimum required updates:

- `orders.uid`
- `table_sessions.uid`
- `addresses` where `entity_type = USER` and `entity_id = googleUser.id`
- `bank_details` where `entity_type = USER` and `entity_id = googleUser.id`
- `loyalty_trans.uid`
- `complaints.uid`
- `notifications` recipient metadata if stored as ids
- `user_logs.uid`
- `user_sessions.uid`
- `employees.uid` only if the Google account somehow became an employee
- Any join requests or HR records with `uid`

Implementation rule:

- Do the merge in one Prisma transaction.
- Create a merge log entry before and after the merge.
- Prefer an explicit `mergeUserAccounts(primaryUid, secondaryUid)` service method over scattering updates across controllers.

### 3.7 Data Safety Decision

Do not physically delete the Google user unless all FK references are guaranteed moved. Safer plan:

- Move all known references.
- Mark the Google user `is_deleted = true`.
- Clear or suffix unique fields on the deleted Google row only if required by unique constraints.
- Store a merge audit log with `primary_uid` and `secondary_uid`.

If the schema cannot preserve a deleted duplicate email due to uniqueness, use one of these safe patterns:

- Move email to primary user and set deleted secondary email to `merged_<id>_<email>`.
- Add a nullable `merged_into_uid` field later if deeper auditability is needed.

## 4. Mobile App Plan

### 4.1 Remove Phone OTP Login From Mobile Auth UI

Target files:

- `apps/mobile/lib/features/core_hr/pages/auth.page.dart`
- `apps/mobile/lib/features/core_hr/controllers/core_hr.cubit.dart`
- `apps/mobile/lib/features/core_hr/controllers/core_hr.repo.dart`
- `apps/mobile/lib/features/core_hr/constants/hr.constant.dart`

Required changes:

- Remove or hide phone OTP fields from the login screen.
- Make Google login the primary login action.
- Keep repository-layer Google Sign-In integration, following the standard that third-party SDK logic stays in the repository.
- Remove UI paths that call `sendOtp` and OTP login for customer-facing login.
- If employee/admin OTP is still required later, split it into a separate employee login flow instead of mixing it with customer login.

### 4.2 Add Phone Capture Page

Create a required phone capture screen in the auth/core HR feature.

Behavior:

- It appears after Google login if `requires_phone` is true or if `currentUser.phone` is empty.
- It uses `AppInput`, `AppButton`, `AppBottomAction`, `ScreenUtil`, and constants.
- It defaults bare 10 digit phone values to `+91` by sending raw input to the API and showing the normalized value after success.
- It calls `completePhone(phone)` through Cubit.
- It shows duplicate-phone errors from the Cubit.
- It does not ask for OTP.
- It does not navigate from repository or Cubit.

Navigation:

- Splash/session page checks saved token.
- If token valid and phone missing, route to phone capture.
- If token valid and phone present, route to normal destination.
- After successful phone completion or merge, replace route to the correct destination.

### 4.3 Local Storage And Token Refresh

When merge occurs:

- API returns new `accessToken`, `refreshToken`, and primary phone user.
- Mobile repository saves the new token.
- Mobile updates local user profile.
- Old Google temporary user id must not remain in local storage.

### 4.4 Mobile Models

Update `UserModel` only if required by backend response:

- Add `requires_phone` to auth/session response model, not necessarily to `UserModel`.
- Keep backend parity fields snake_case.
- Ensure `phone`, `email`, `addresses`, and `bank_details` parse safely.

### 4.5 Mobile POS Customer Search

The POS customer lookup should call the new find-or-create backend behavior.

Required UI behavior:

- Vendor enters phone.
- If existing user found, show selectable user.
- If new user was auto-created, show it immediately as selected or first result.
- Do not allow a customer phone order to proceed as guest if the phone is valid.
- If phone invalid, show Cubit-driven validation message.

## 5. Web App Plan

### 5.1 Remove Phone OTP Login From Web

Target files:

- `apps/web/src/app/login/page.tsx`
- `apps/web/src/features/auth/repo/auth.repo.ts`
- `apps/web/src/core/store/user.store.ts`

Required changes:

- Remove phone OTP fields from customer login UI.
- Add Google Sign-In button.
- Use Google Identity Services on web.
- Send Google `idToken` to `POST /hr/auth/login`.
- Store returned token, refresh token if currently supported, and user.
- Store `requires_phone`.

### 5.2 Add Phone Capture Route

Add route:

- `/complete-phone`

Behavior:

- If user is not logged in, redirect to `/login`.
- If user has phone, redirect to intended destination.
- If user has no phone, show phone form.
- Form calls `POST /hr/auth/complete-phone`.
- On success, replace local user and tokens with API response.
- On duplicate-with-email error, show "This phone number is already registered with another account."
- On merge success, continue as the primary phone user.

### 5.3 Route Guarding

Any order placement path must enforce:

- Logged in.
- Phone completed.

Apply to:

- `/cart`
- delivery order submit
- dine-in order submit
- profile/address page if required

If `requires_phone` is true or `user.phone` is empty:

- Redirect to `/complete-phone?next=<current path>`.

### 5.4 Address And Profile Compatibility

After phone merge:

- Web store must replace user id with primary phone account id.
- Cart must use addresses belonging to primary account.
- Existing cart session should remain intact.
- Order payload must use `uid` from the refreshed primary user.

## 6. API Endpoint Summary

### 6.1 Existing Endpoint To Keep

- `POST /hr/auth/login`
  - Accepts Google `idToken`.
  - Existing phone OTP path can remain temporarily for migration, but customer UI should stop using it.

### 6.2 New Or Updated Endpoints

- `POST /hr/auth/complete-phone`
  - Authenticated.
  - Completes phone or merges account.

- `GET /pos-kds/customers/:phone`
  - Should become find-or-create for POS phone lookup, or a new explicit endpoint should be added:
  - `POST /pos-kds/customers/resolve-phone`

Preferred endpoint:

```json
POST /pos-kds/customers/resolve-phone
{
  "phone": "9876543210"
}
```

Reason:

- A GET request should not create data.
- Creating a new user is a mutation, so POST is cleaner.

## 7. Data Migration Plan

Before releasing:

1. Find existing orders where `uid` is null and a customer phone exists in notes or related metadata.
2. If a phone can be identified, normalize it and create/find the user.
3. Update those orders with `uid`.
4. Find duplicate users by normalized phone-like values.
5. Merge phone-only and Google-created duplicate accounts using the new merge service.
6. Export a backup before running any merge migration.
7. Log every migration merge with primary and secondary ids.

If orders have no recoverable phone, leave them unchanged and report them as unresolved legacy records.

## 8. Edge Cases And Solutions

### 8.1 Vendor Types Wrong Phone

Problem:

- Auto-creating users can create wrong identities for mistyped numbers.

Solution:

- Normalize and validate phone format.
- Show the normalized phone before final customer selection.
- Allow staff to edit customer phone before order submission.
- Add a future admin-only customer merge tool for correcting mistakes.

### 8.2 Google User Enters Phone Belonging To Someone Else With Email

Problem:

- A user could try to claim another complete account.

Solution:

- Block the operation.
- Do not merge.
- Show a clear duplicate error.
- Optionally add future support workflow for account recovery.

### 8.3 Google User Enters Phone-Only Vendor Account

Problem:

- The phone-only account may have order history and the Google user has email/avatar.

Solution:

- Keep phone account primary.
- Move Google identity details into phone account.
- Move temporary Google references to phone account.
- Refresh tokens for phone account.

### 8.4 Same Google Email Already Exists

Problem:

- `findOrCreateUser` currently may return by email and accidentally attach to a user before phone is confirmed.

Solution:

- For Google login, prefer lookup by stable Google provider id first.
- Add a dedicated provider identity concept if possible.
- If schema is not changing now, ensure Google-created id is deterministic and email lookup does not incorrectly hijack phone-only accounts before phone merge rules run.

### 8.5 Employee Accounts

Problem:

- The same auth table appears to serve customer and employee flows.

Solution:

- Do not remove backend OTP immediately if employees still need it.
- Remove phone OTP only from customer-facing web/mobile screens.
- If employee phone login remains, label it clearly as employee/admin login and keep it separate.

### 8.6 Orders During Incomplete Phone State

Problem:

- A Google user without phone could place a delivery/dine-in order and recreate identity fragmentation.

Solution:

- API order creation should reject customer self-order when authenticated user has no phone unless the order is being created by POS staff for a resolved phone user.
- Web/mobile should route to phone capture before cart submit.

## 9. Implementation Order

### Phase 1: Backend Identity Foundation

1. Add phone normalization utility.
2. Add constants and typed errors.
3. Add repository methods:
   - find user by normalized phone
   - create phone user
   - update user phone
   - merge users
   - invalidate sessions for merged user
4. Add `complete-phone` service/controller/route.
5. Update Google login response with `requires_phone`.
6. Update POS customer phone resolver to find-or-create.
7. Add API tests or targeted manual checks.

### Phase 2: Mobile Auth Flow

1. Remove customer OTP UI from login page.
2. Ensure Google login is the only customer login CTA.
3. Add phone capture page and route.
4. Add Cubit/repo method for `completePhone`.
5. Update splash/session routing.
6. Update local token/user refresh on merge.
7. Update POS phone customer lookup to use resolver endpoint.
8. Run `flutter analyze`.

### Phase 3: Web Auth Flow

1. Remove phone OTP UI from login page.
2. Add Google Identity Services login.
3. Add `/complete-phone`.
4. Guard cart/order/profile flows for phone completion.
5. Refresh user and tokens after merge.
6. Run `npx tsc --noEmit`, `npm run lint`, and `npm run build`.

### Phase 4: Data Cleanup

1. Backup production database.
2. Dry-run duplicate user report.
3. Dry-run nullable order `uid` report.
4. Run migration script only after reviewing output.
5. Verify customer histories, active orders, and address ownership.

## 10. Acceptance Criteria

- Vendor enters a new valid phone number and receives a created user with `uid`.
- Vendor-created order cannot become a guest order when a valid phone is present.
- Re-entering that phone later returns the same user.
- Bare 10 digit Indian numbers are stored and matched as `+91XXXXXXXXXX`.
- Customer web login uses Google, not phone OTP.
- Customer mobile login uses Google, not phone OTP.
- Google user without phone is forced to complete phone before ordering.
- Duplicate phone with an existing email account is blocked with a clear error.
- Duplicate phone with a phone-only account merges into the phone account.
- After merge, local tokens point to the primary phone account.
- Existing orders for the phone account remain visible under the merged Google login.
- Delivery, dine-in, and takeaway order creation use a real `uid`.
- API compile passes.
- Web typecheck, lint, and production build pass.
- Mobile `flutter analyze` passes.

## 11. Verification Checklist

Backend:

- `npx tsc --noEmit`
- Google login with new email returns `requires_phone = true`.
- Complete phone with unused number updates current user.
- Complete phone with phone-only account merges and returns new tokens.
- Complete phone with email-backed account returns duplicate error.
- POS resolve phone creates user once and returns same user on repeat.
- Order creation rejects missing `uid` for customer self-order where required.

Mobile:

- `flutter analyze`
- Google login works.
- Phone capture appears when phone missing.
- Phone completion updates local user and token.
- POS customer search creates/selects user for new phone.
- No phone OTP customer UI remains.

Web:

- `npx tsc --noEmit`
- `npm run lint`
- `npm run build`
- Google login works in production build.
- `/complete-phone` guard works.
- Cart submit blocks until phone is complete.
- Address/profile data belongs to the primary merged user.

## 12. Notes For Implementation Standards

- Keep all user-facing strings in constants.
- Keep all endpoint paths in endpoint constants.
- Do not hardcode route strings in pages.
- Keep Google SDK work inside repositories/services, not UI pages.
- Keep Cubits and stores responsible for state, not raw API parsing in pages.
- Keep mobile UI responsive with ScreenUtil and existing shared widgets.
- Do not add code comments in Dart or TypeScript source files.
- Use transactions for all merge operations.
- Do not physically delete records unless every reference has been moved and verified.
