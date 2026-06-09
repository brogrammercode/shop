the current problems/requirements:

- the google login of mobile app is done but user app is not done so complete it
- the user model will be cached locally in the app for future usage (based on remember my login for faster sign in check, if not check then on access token expiry, will log out the user and again need to login)
- the ad banner in lock screen and home screen will be fetched in login page only
- terms of service, privacy policy and content policies will get user to the link
- the textfileds inside login page need to match the height of flag icon textfield
- flag icon should also be configured to add prefix before actual number
- remove +91, 0, 91 (if 12 digit) prefix and give limit to only enter 10 characters inside the textfield of login page
- crop the otp field a little
- give resent otp option once sent with timer to make it eligible and also update api according to that

implementation_plan:

### 1. Google Login & Local User Caching
- **`apps/user/lib/features/auth/repo/auth_repo.dart`**: Implement `loginWithGoogle` calling the appropriate backend endpoint.
- **`apps/user/lib/services/local_storage.dart`**: Ensure standard methods exist to safely store and retrieve the user context and token.
- **`apps/user/lib/features/auth/cubit/auth_cubit.dart`**: Add Google login logic mapped to `OperationStatus`. Check the "Remember my login" state: if true, persist the token/user via `LocalStorage`; if false, handle it as an ephemeral session.
- **`apps/user/lib/features/auth/pages/login_page.dart`**: Wire the Google login UI button directly to `AuthCubit.loginWithGoogle()`.

### 2. Ad Banner Prefetching on Login (Both User & Mobile Apps)
- **`apps/user/lib/features/auth/pages/login_page.dart` & `apps/mobile/lib/features/auth/pages/login_page.dart`**: Trigger the fetching of lock screen and home screen banners upon login page initialization.
- **`apps/user/lib/features/user/cubit/user_cubit.dart` & `apps/mobile/lib/features/user/cubit/user_cubit.dart`**: Expose a method inside `UserCubit` to fetch and cache these ad banners ahead of navigating to the Home screen, avoiding the use of a separate `promo_cubit.dart`.

### 3. Legal Links 
- **`apps/user/lib/features/auth/constants/user.constant.dart`**: Add string constants for all external URLs (Terms of Service, Privacy Policy, Content Policies) to adhere strictly to the no-hardcoding rule.
- **`apps/user/lib/features/auth/pages/login_page.dart`**: Update the footer text gestures to use `url_launcher` and route users to the constants-defined URLs.

### 4. Phone Input Formatting & Validation
- **`apps/user/lib/features/auth/pages/login_page.dart`** (or the respective input component):
  - **Height Alignment**: Use ScreenUtil (`.h`) to explicitly define matching heights for both the flag dropdown container and the text input field.
  - **Character Limitation**: Implement `LengthLimitingTextInputFormatter(10)` to cap input at exactly 10 digits.
  - **Prefix Stripping Formatter**: Add a custom `TextInputFormatter` to intercept any typed or pasted content, stripping out `+91`, `91` (if length > 10), and leading `0`s to leave a clean 10-digit string.
  - **Country Code Handling**: Track the selected country code from the flag icon and prepend it to the sanitized 10 digits dynamically only when dispatching the login payload to the Cubit.

### 5. OTP Field UI & Resend Functionality (Both Apps & API)
- **API (`apps/api/src/features/auth/`)**: Ensure the auth controller and router expose a standard endpoint for resending the OTP, complete with rate-limit validation to prevent spamming.
- **`apps/user/...` & `apps/mobile/...` OTP Field UI**:
  - **Crop OTP Field**: Adjust the width of the OTP input fields (or their wrapping container) using ScreenUtil (`.w`) to nicely "crop" them, making the layout visually balanced instead of spanning the entire width excessively.
- **`apps/user/...` & `apps/mobile/...` Resend Timer Logic**:
  - Using a `StatefulWidget` (or dedicated Cubit), implement a countdown timer (e.g., 30s) starting immediately upon OTP dispatch.
  - Display disabled "Resend OTP in [Xs]" text while the timer is active. Once 0 is reached, enable a clickable "Resend OTP" text button that triggers the `AuthCubit` to call the resend API, subsequently resetting the timer upon success.

### 6. Complete Standard Compliance Validation
- Check that absolutely no code contains comments.
- Ensure all models strictly retain `snake_case` fields (`created_at`, `user_id`) mirroring backend structures.
- All layout elements must leverage `AppColors` and ScreenUtil variables (`.w`, `.h`, `.sp`, `.r`).
