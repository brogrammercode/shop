# Auth Flow Deep Analysis: Old vs. Current Implementation

After deeply analyzing the old authentication architecture provided in `contexts/old_pages/auth.md` and comparing it against our current `core_hr` authentication flow, here is a detailed breakdown of the features, business logic, and security measures we are currently missing in the new implementation:

## 1. OTP State Management & Resilience
- **Old Flow (Database-Backed)**: OTPs were saved persistently in the database (`userOtp` table) with strict `valid_till` expirations. This supported a built-in 30-second rate limiter (preventing OTP spam) and handled distributed environments correctly. It also allowed a mock OTP (`123456`) bypass for dev environments.
- **Current Flow (In-Memory)**: OTPs are temporarily cached in an in-memory `Map` inside the `CoreHrService` (`this.otps`). If the Node API restarts while a user is authenticating, the OTP is lost. In a multi-instance/serverless environment, OTP verification will fail randomly depending on which instance handles the request. We are also missing the 30-second rate limiter.

## 2. Session Management & Token Refresh
- **Old Flow**: Full session tracking. Logging in generated both an `accessToken` and a `refreshToken`. The system supported robust features like:
  - Tracking all active sessions per user.
  - Ability to forcefully terminate specific sessions (`terminateSession`).
  - Refreshing access tokens seamlessly without forcing the user to log in again (`refreshAccessToken`).
- **Current Flow**: We issue a single JWT upon login. There is no `refreshToken`, no session database tracking, and no way to remotely revoke a user's access before the JWT naturally expires. The frontend also lacks the `getSessions` and `terminateSession` features.

## 3. Persistent User Caching & Auto-Login
- **Old Flow**: The frontend used `JsonCache` to securely store not only the token but the user's `UserModel` and `BusinessContext` offline. When the app booted, `loginWithSavedProfile()` seamlessly rehydrated this state to allow instant offline startup before refreshing the token.
- **Current Flow**: While we store the token, we do not fully cache the `UserModel` and Employee contexts for instant offline UI rendering. The app must fetch `getCurrentUser` on boot, creating a loading delay.

## 4. Automatic User Logging (Activity Trails)
- **Old Flow**: Maintained an explicit `UserLog` table. Important actions (like logging in, terminating sessions, etc.) generated an activity trail that the user could view (`getActivities`).
- **Current Flow**: We have no explicit triggers storing `UserLog` data when a user authenticates or performs major profile actions.

## 5. Ad Banners Integration
- **Old Flow**: Integrated directly with authentication, fetching targeted or system-wide ad banners (`getAdBanners`) that were automatically filtered by `valid_from`, `valid_to`, and `status = ACTIVE` dates on the backend.
- **Current Flow**: We lack the API endpoint and the frontend BLoC state variables to fetch, filter, and store promotional banners for users.

## 6. User Profiles & Addresses
- **Old Flow**: Included dedicated endpoints for `UserAddress` management (create, read, update, delete).
- **Current Flow**: Address management endpoints do not currently exist inside `core_hr` or `auth` routes.
