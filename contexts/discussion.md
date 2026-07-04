# Application Architecture & UI Plan

Based on the requirements provided, here is the detailed implementation plan to achieve the desired goals:

## 1. Nested Navigation in Layout (Replacing `Navigator.push`)
**Problem**: Currently, tapping items in the various layout navigation bars (like Procurement, Catalog, HR, Finance) triggers a full screen transition using `Navigator.pushNamed`. This breaks the app experience as the bottom navigation bars disappear, requiring the user to tap "back" to see the layout again.
**Solution**:
- **State-driven Body Replacement**: We will refactor `HomeLayoutPage` to hold a state variable `String _currentRoute` (defaulting to the initial view).
- **Dynamic Rendering**: Inside `_buildBody()`, instead of rendering hardcoded placeholder pages like `BillingPage`, we will dynamically render the requested page using our existing route definitions: `AppRoutes.routes[_currentRoute]!(context)`.
- **Navigation Update**: Every `onTap` in the secondary/tertiary nav bars will be updated to `setState(() { _currentRoute = newRoute; })` instead of `Navigator.pushNamed(...)`.
- **Nested Scaffolds**: The individual pages already use `Scaffold`. Rendering them inside the layout's `Scaffold` body works seamlessly in Flutter, retaining their custom app bars while keeping the global navigation persistent at the bottom.

## 2. Global Pull-to-Refresh (`RefreshIndicator`)
**Problem**: Pages do not allow users to manually refresh the data.
**Solution**:
- Every page that fetches data (list pages, detail pages, dashboards) will have its scrollable body (e.g., `ListView`, `SingleChildScrollView`) wrapped in a `RefreshIndicator`.
- The `onRefresh` callback will trigger the respective Cubit method (e.g., `context.read<CoreHrCubit>().listEmployees()`) and return the Future so the indicator animates correctly until the data is fetched.
- This provides a standard, intuitive way for users to sync the app state with the backend.

## 3. Standard Updates
**Problem**: The codebase lacks official documentation for this new nested navigation pattern and pull-to-refresh requirement.
**Solution**:
- **Update `code_standard.md`**: Add rules mandating that layout-level navigation must use state-based body replacement rather than `Navigator.push`. Also, mandate that any data-fetching page must implement a `RefreshIndicator` returning the async fetch function.
- **Update `ui_standard.md`**: Add UI guidelines for the `RefreshIndicator` (e.g., matching the theme colors with `AppColors.primaryGreen`). Specify that nested pages should use `Scaffold` without a bottom navigation bar, as they will be hosted inside the `HomeLayoutPage`'s main layout.

---
*Ready to begin execution upon approval.*
