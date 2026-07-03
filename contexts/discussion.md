# Discussion: Navigation Race Conditions & Premature Navigation Issues

## Problem Statement

> "Sometimes it doesn't do the thing and after completion of the process it should navigate to the following page but it is sending me early and then do the process."

The app has multiple places where navigation happens **before** the async process is fully complete, or where a state change listener triggers navigation too eagerly. The following is a complete investigation and fix plan for each occurrence.

---

## Investigation Results

### Issue 1 — `create.branch.page.dart`: Navigate to home before business context is saved

**File:** `apps/mobile/lib/features/core_hr/pages/create.branch.page.dart`  
**Lines:** 174–177

**Problem:**  
The `BlocConsumer` listener fires `Navigator.pushReplacementNamed(context, '/home')` the moment `branchInfo.status == OperationStatus.success`. However, at this point, the **business context** (branch_id, employee_id) is **never written to the JSON cache**. On the next app restart (via `splash.page.dart`), the cached profile will have an employee but no `branch_id` populated in the business context file because only `verifySessionInBackground` does it — and that happens only on the splash page. The user would be sent back to crossroad on next launch unless they had already hit splash at least once since creating the branch.

Additionally: the profile saved to cache in `signInWithGoogle` / `login` cubit methods does NOT update after `createBranch` — so the cache shows `employee: null` even though the user is now an employee.

**Fix Plan:**
1. In the `createBranch` success handler in `core_hr.cubit.dart`, after emitting the new state, also call `_cache.saveSavedProfile(...)` with the updated user + employee data, and call `_cache.saveBusinessContext(...)` with `branch_id` and `employee_id`.
2. In `create.branch.page.dart`, the listener should only navigate **after** the cache is persisted. Since the cubit already does cache-writing before emitting success, the listener is fine — but the cubit must be fixed first.

---

### Issue 2 — `setting.page.dart`: Logout navigates immediately without API call or confirmation

**File:** `apps/mobile/lib/features/core_hr/pages/setting.page.dart`  
**Lines:** 37–46

**Problem:**  
The current logout in Settings page does **only** `JsonCache().clearAll()` and immediately navigates to `/login`. It does NOT:
- Show a confirmation dialog (required by the AppDialog standard)
- Call the backend `/logout` API to invalidate the session
- Use the `CoreHrCubit.logout()` method (which handles the token, API call, and cache clearing)
- Show a loading state while the process completes

This is both a premature navigation issue (navigates instantly without waiting for anything) and a missing API call (session remains active on the server).

**Fix Plan:**
1. Rewrite `setting.page.dart` to use `CoreHrCubit` properly via `BlocConsumer`.
2. On logout tap: show `AppDialog.showConfirmation`.
3. On confirmation: call `context.read<CoreHrCubit>().logout()`.
4. Listen for `logoutInfo.status == OperationStatus.success` → then navigate to `/login` with `pushNamedAndRemoveUntil`.
5. Show a `CircularProgressIndicator` (strokeWidth: 2, small, centered) while `logoutInfo.status == OperationStatus.loading`.
6. Also fix the page to NOT use `Scaffold.appBar` (violates `ui_standard.md` rule 9.2) — use a manual app bar built inside the `body` Column.

---

### Issue 3 — `crossroad.page.dart`: `branchInfo.status` stale from previous create session can trigger premature crossroad→home skip

**File:** `apps/mobile/lib/features/core_hr/pages/crossroad.page.dart`

**Problem:**  
After creating a branch, if the user navigates back to crossroad (e.g., via back button from create branch page before it succeeds), the `branchInfo` state may still be `success` from a previous successful operation. If any listener was watching this, it would fire incorrectly.

Currently crossroad doesn't listen to `branchInfo` — but the broader issue is that the cubit state is **never reset** between operations. After any `success` status, if you go back and try the action again, `listenWhen` will not fire because `previous == current`.

**Fix Plan:**
1. In `core_hr.cubit.dart`, add a `resetBranchInfo()` method that emits `branchInfo` back to `OperationStatus.initial`.
2. Call `resetBranchInfo()` in `create.branch.page.dart`'s `initState` via `WidgetsBinding.instance.addPostFrameCallback`.
3. Similarly add `resetJoinInfo()` and call it in `join.branch.page.dart`'s `initState`.

---

### Issue 4 — `join.branch.page.dart`: No navigation after join request — user stays on the same page with no feedback about "next step"

**File:** `apps/mobile/lib/features/core_hr/pages/join.branch.page.dart`

**Problem:**  
After a successful `sendJoinRequest`, the app only shows a toast "Join request sent" and updates the button state. The user has no idea what happens next or where to go. There is no listener that navigates or shows a "pending state" screen. The user is stuck on the join branch search page indefinitely.

**Fix Plan:**
1. After `joinInfo.status == OperationStatus.success` (specifically for a send-request, not withdraw), navigate back or show a bottom sheet / dedicated "Pending Approval" page explaining that the request is pending.
2. The simplest fix: after successful join request send → `Navigator.pop(context)` to go back to crossroad. Crossroad already shows "Join a Branch" option, so the user will see the pending state described via toast.
3. A better UX: show a full-screen "Request Sent" confirmation page (similar to a success state) with instructions. Mark as stretch goal.

---

### Issue 5 — `signInWithGoogle` / `login` cubit: profile cache not updated with employee after createBranch

**File:** `apps/mobile/lib/features/core_hr/controllers/core_hr.cubit.dart`  
**Lines:** 81–97, 156–169

**Problem:**  
`saveSavedProfile` is called with `{'user': ..., 'employee': ...}` right at login time. After `createBranch` succeeds, the cubit emits the new `currentEmployee`, but **never** calls `_cache.saveSavedProfile(...)` again. On the next cold start, `splash.page.dart` reads `savedProfile['employee']` from disk — which is still `null` — so the user is sent to crossroad despite having just created a branch.

**Fix Plan:**
1. In `createBranch` success handler in `core_hr.cubit.dart`, call:
   ```dart
   await _cache.saveSavedProfile({
     'user': state.currentUser?.toJson(),
     'employee': data['employee']?.toJson(),
   });
   await _cache.saveBusinessContext({
     'branch_id': data['employee'].branch_id,
     'employee_id': data['employee'].id,
   });
   ```
2. Note: the `(data)` success callback is currently synchronous — it must be made `async` to await cache writes before emitting state.

---

## Summary of All Files to Fix

| # | File | Problem | Fix |
|---|------|---------|-----|
| 1 | `core_hr.cubit.dart` | `createBranch` success never saves profile/business context to cache | Save profile + business context in success handler |
| 2 | `setting.page.dart` | Logout bypasses API, no confirmation, no loading state, uses `Scaffold.appBar` | Rewrite with `BlocConsumer`, `AppDialog`, loading state, manual app bar |
| 3 | `create.branch.page.dart` | `branchInfo` state never reset on re-entry | Add `resetBranchInfo()` + call in `initState` |
| 4 | `join.branch.page.dart` | No navigation after successful join request | Navigate back after successful join send |
| 5 | `core_hr.cubit.dart` | `branchInfo` / `joinInfo` states not reset between operations | Add reset methods for both |

---

## Execution Plan

### Step 1 — Fix `core_hr.cubit.dart`
- Make `createBranch` success handler `async`
- After success: save profile + business context to cache
- Add `resetBranchInfo()` method: emits `branchInfo` to `OperationStatus.initial`
- Add `resetJoinInfo()` method: emits `joinInfo` to `OperationStatus.initial`

### Step 2 — Fix `create.branch.page.dart`
- In `initState`, call `resetBranchInfo()` via `addPostFrameCallback`
- The navigation on success is already correct (goes to `/home`) — no change needed there

### Step 3 — Fix `join.branch.page.dart`
- In `initState`, call `resetJoinInfo()` via `addPostFrameCallback`
- Add `BlocListener` for `joinInfo.status == OperationStatus.success`
- On success (specifically when it was a send-request action, not withdraw): `Navigator.pop(context)` back to crossroad

### Step 4 — Rewrite `setting.page.dart`
- Convert to `StatefulWidget` wrapping a `BlocConsumer<CoreHrCubit, CoreHrState>`
- Remove `Scaffold.appBar`, replace with manual app bar in body Column
- Show confirmation dialog before logout
- Show loading indicator while `logoutInfo.status == OperationStatus.loading`
- Navigate to login on success via `pushNamedAndRemoveUntil`

### Step 5 — Verify end-to-end flow
- Cold start after createBranch → should go to `/home`
- Cold start after logout → should go to `/login`  
- Settings logout → should call API, clear cache, then navigate to login
- Join request → should navigate back to crossroad after success

---

## Standards Compliance

All fixes must comply with:
- `ui_standard.md` §9.2: No `Scaffold.appBar` — all app bars are manual widgets inside the body `Column`
- `ui_standard.md` §1.1: All sizes use `.w`, `.h`, `.sp`, `.r`
- `ui_standard.md` §6.4: All destructive/critical actions use `AppDialog.showConfirmation`
- `code_standard.md`: No comments in `.dart` files
- `code_standard.md`: Circular indicator is `strokeWidth: 2`, very small, centered
- `code_standard.md`: Loading states in buttons use thin circular indicator inside button
