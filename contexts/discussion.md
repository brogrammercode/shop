- is the confirmation dialog reusable throuhout the app
- if not make it reusable and use it everytime instea dof making everytime a new one
- also include this point inside the code standard that, everytime use the reusable widgets for every purpose like same bottom sheet, confirmation dialog, etc
- only make a new element (that is again reusable) only if it most necessary
-
- remove the cancel from conformation dialog and give a very small cross icon bounded with a low padded circular box
-

---

# Implementation Plan

## Goal Description
Standardize all confirmation dialogs across the app by creating a unified, reusable `ConfirmationDialog` widget. This eliminates boilerplate, enforces visual consistency, and adheres to strict DRY (Don't Repeat Yourself) principles. Additionally, the standard confirmation dialog UI will be upgraded to feature a minimal circular close icon instead of a bulky "Cancel" text button. Finally, `code_standard.md` will be updated to explicitly mandate the use of reusable components.

## Proposed Changes

### 1. Abstracting the Reusable Confirmation Dialog
**File:** `apps/mobile/lib/core/widgets/confirmation_dialog.dart` (New File)
- Create a stateless widget `ConfirmationDialog` that wraps the native `AlertDialog`.
- It will accept:
  - `String title`
  - `String content`
  - `String confirmText`
  - `VoidCallback onConfirm`
  - `Color confirmColor` (defaults to primary action color, e.g., red for destructive actions)
- **UI Update:** Remove the traditional "Cancel" text button from the `actions` array. Instead, add a small `Icons.close` bounded by a low-padded circular box (using `Container` with `BoxShape.circle` and a subtle grey background) at the top-right corner of the dialog title area, which pops the context when tapped.

### 2. Refactoring Existing Dialogs
**File:** `apps/mobile/lib/features/business/pages/join_branch_page.dart`
- Delete the highly redundant `_showLogoutConfirmation` and `_showWithdrawConfirmation` methods.
- Replace their invocations with the new static helper `ConfirmationDialog.show(...)`.
  - For **Logout**: Title "Confirm Logout", content "Are you sure you want to log out...?", action "Logout", color Red.
  - For **Withdraw**: Title "Withdraw Request", content "Are you sure you want to withdraw...?", action "Withdraw", color Red.

### 3. Enforcing UI Standards globally
**File:** `contexts/code_standard.md`
- Add a new section strictly mandating the use of reusable widgets.
- It will state: "Always utilize existing reusable widgets from `lib/core/widgets` (e.g., `ActionBottomSheet`, `ConfirmationDialog`). Do not construct raw generic elements (like `showModalBottomSheet` or `AlertDialog`) locally in feature files. Only create a new element if absolutely necessary, and always design it to be globally reusable."

## Verification Plan
### Manual Verification
- Test "Logout" inside the Global Actions menu: Ensure it triggers the new reusable dialog with the circular close icon and no "Cancel" text.
- Test "Withdraw Request": Ensure it also uses the new unified dialog, correctly closes when tapping the cross, and successfully executes when tapping "Withdraw".
- Run `dart analyze` to guarantee there are no typing or architectural errors.
