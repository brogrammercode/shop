I want to have that, when we open the app, it will first check for some things:

- If the user is logged in or not via token, if expired silently refreshes it, also updates json file for user
- If the user is an employee or not, read json file
- if not get the user to crossroad page
- if yes, get the user to home page, and create/update the business context in json file

---

## Analysis & Implementation Plan

### What is Already Implemented
1. **Silent Token Refresh:** The `ApiClient` already has a Dio interceptor that automatically catches `401 Unauthorized` responses and silently requests a new access token using the stored refresh token.
2. **Local Storage & Caching:** We have `LocalStorage` managing the secure tokens, and `JsonCache` storing the saved user profile, employee info, and business context.
3. **Pages Existing:** The `AuthPage` (login), `CrossRoadPage` (no business context), and `HomeLayoutPage` (dashboard) all exist and are registered in `core/routes.dart`.
4. **Basic Rehydration:** We added `loginWithSavedProfile()` in `AuthPage.initState` which attempts to read the cached profile and instantly navigates to `Home` if it finds it.

### What is NOT Implemented
- **Everything from the original plan is now successfully implemented.**

### Action Plan (Optimistic UI - Offline First) - IMPLEMENTED

1. **[IMPLEMENTED] Create a `SplashPage` (Instant Routing)**
   - Created `features/core_hr/pages/splash.page.dart` (mobile) and `features/auth/splash_page.dart` (user).
   - Updated `main.dart` to use `SplashPage` as the `initialRoute`.
   - The `SplashPage` instantly reads the `JsonCache`.
   - **Routing Rules**: 
     - No cache -> `AppRoutes.login` / `AppRoutes.session`
     - Cache exists but no business context -> `AppRoutes.crossRoad`
     - Cache exists and has business context -> `AppRoutes.home`

2. **[IMPLEMENTED] Enhance `AuthCubit` Background Validation (`verifySessionInBackground`)**
   - After routing, fire `/auth/me` silently in the background.
   - **Success:** Update the `JsonCache` with fresh user/employee/business context data.
   - **Failure:** The `ApiClient` interceptor catches the `401`, silently asks for a new access token via `/auth/refresh`. If that fails, it wipes the `JsonCache`, clears tokens, and forcefully redirects to `AppRoutes.login` via the global `navigatorKey`.

3. **[IMPLEMENTED] Clean up `AuthPage`**
   - Removed the `loginWithSavedProfile()` logic from `AuthPage.initState`/`LoginPage.initState`, as the `SplashPage` and global interceptor now fully handle session management and routing.
