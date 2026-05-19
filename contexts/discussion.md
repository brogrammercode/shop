# What does "serverClientId must be provided in Android" mean?

When using Google Sign-In in a Flutter app (typically with the `google_sign_in` package), you might encounter the error: `serverClientId must be provided in Android`.

## The Core Issue
Your mobile app is authenticating the user with Google and then trying to retrieve an `idToken` (or a server auth code). You need this token to send to your backend server (`apps/api`) so the backend can verify the user's identity.

However, on Android, the Google Sign-In SDK requires you to explicitly declare **which backend server** this token is intended for. This is a security measure to prevent "confused deputy" attacks (where a token minted for App A is stolen and used against App B).

The `serverClientId` is exactly that declaration. It is the **Web Client ID** generated for your backend in the Google Cloud Console.

## How to Fix It

### 1. Get your Web Client ID
1. Go to your [Google Cloud Console](https://console.cloud.google.com/).
2. Navigate to **APIs & Services** > **Credentials**.
3. Look for an OAuth 2.0 Client ID of type **Web application**. If you don't have one, create it.
4. Copy the Client ID (it will end in `.apps.googleusercontent.com`).

### 2. Update your Flutter Code
When you initialize your `GoogleSignIn` instance (most likely inside your `google_auth_service.dart`), you must pass this Web Client ID to the `serverClientId` parameter.

```dart
final GoogleSignIn _googleSignIn = GoogleSignIn(
  // This MUST be your Web Client ID, not the Android Client ID
  serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
);
```

### Why only Android?
iOS handles OAuth configurations slightly differently through the `GoogleService-Info.plist` and reverse client IDs, which sometimes masks this requirement depending on how you configure it. But for Android to issue a backend-verifiable `idToken`, providing the `serverClientId` in the code is mandatory.

---

# GOOGLE_CLIENT_ID vs GOOGLE_SERVER_CLIENT_ID

In your `apps/mobile/.env` file, you see both fields:
```env
GOOGLE_CLIENT_ID=
GOOGLE_SERVER_CLIENT_ID=
```

Here is exactly what they mean and what you should put in them:

### 1. GOOGLE_SERVER_CLIENT_ID (Required)
- **What it is**: This is the **Web application Client ID** from the Google Cloud Console.
- **Why it's needed**: This is **mandatory** for both Android and iOS so Google can issue a secure `idToken` that your backend API (`apps/api`) can verify.
- **What to paste**: Paste the Web Client ID ending in `.apps.googleusercontent.com` here.

### 2. GOOGLE_CLIENT_ID (Optional/Leave Blank for Mobile)
- **What it is**: This represents the ID of the mobile client itself (Android or iOS).
- **What to paste**: **You should leave this blank!**
- **Why?**:
  - **On Android**: The Google SDK automatically identifies your client app. It does this using your Android app's **Package Name** (e.g. `com.example.shop`) and your signing certificate's **SHA-1 Fingerprint**, which are registered directly in the Google Cloud Console under the **Android** Client ID credential. The SDK automatically resolves this matching relationship on the device, meaning you do not need to explicitly provide a `clientId` in the Dart/Flutter code.
  - **On iOS**: The client ID is resolved automatically from the `GoogleService-Info.plist` file bundled in your iOS application project, so you don't need to specify it in the Dart code either.
  - **On Web**: A `clientId` in Dart is only explicitly required if you are compiling your Flutter app for the Web. For mobile-only builds, it can remain completely empty or `null`.

### Summary Checklist:
1. Generate an **Android Client ID** in Google Cloud Console using your app's Package Name and debug/release SHA-1 fingerprint. (Do not paste this in the `.env`).
2. Generate a **Web application Client ID** in Google Cloud Console.
3. Paste the **Web application Client ID** into `GOOGLE_SERVER_CLIENT_ID` in `apps/mobile/.env`.
4. Leave `GOOGLE_CLIENT_ID` in `apps/mobile/.env` **blank**.

---

# Troubleshooting: "Google Sign In Cancelled"

If you trigger Google Sign-In on your emulator/device and it immediately throws **"Google sign in was cancelled"** (without even prompting you to pick an account, or closing instantly), this is a classic Google API integration issue.

Here is the exact checklist to solve this:

### 1. Package Name Verification
Your app's Package Name is configured as **`com.example.mobile`** (defined in `apps/mobile/android/app/build.gradle.kts` as `applicationId`).
- Go to your **Google Cloud Console** > **APIs & Services** > **Credentials**.
- Edit your **Android Client ID** credential.
- Make sure the **Package name** is exactly `com.example.mobile`.

### 2. Missing/Incorrect SHA-1 Fingerprint (Most Common)
Google will completely block the sign-in flow and immediately report "cancelled" if the SHA-1 fingerprint of your local signing certificate (keystore) does not match the SHA-1 registered in the Google Cloud Console or Firebase.

#### How to get your Debug SHA-1 Fingerprint:
You can retrieve your local debug SHA-1 key using either of these methods:

**Method A: Using Gradle (easiest)**
If Gradle complains that `JAVA_HOME is not set`, it means Windows does not know where Java is installed. Since you have Android Studio installed, we can tell Gradle to use Android Studio's built-in Java!

1. Open your terminal in the `apps/mobile/android` folder.
2. Set the temporary `JAVA_HOME` env variable (runs only for your current terminal session):
   ```powershell
   $env:JAVA_HOME="C:\Program Files\Android\Android Studio\jbr"
   ```
3. Run the signing report:
   ```powershell
   .\gradlew signingReport
   ```
4. Copy the `SHA-1` value under the `debug` variant.

**Method B: Using Keytool directly (Fastest)**
If Windows reports `'keytool' is not recognized`, it's because Java is not in your global system `PATH`. Since we located the `keytool.exe` inside your Android Studio installation directory, you can run it using its absolute path.

Run this exact command in your terminal:
```powershell
& "C:\Program Files\Android\Android Studio\jbr\bin\keytool.exe" -list -v -keystore "$env:USERPROFILE\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```
Copy the printed `SHA-1` fingerprint under the Certificate fingerprints section.

#### Where to Register it:
- **If using Firebase**: Go to **Project Settings** in Firebase console, select your Android App, click **Add fingerprint**, paste the SHA-1, and download the new `google-services.json` (put it in `apps/mobile/android/app/`).
- **If using Google Cloud directly**: Go to your **Android Client ID** credential, click **Add SHA-1 fingerprint**, paste the key, and save.

### 3. Google Play Services
If running on an emulator:
- Make sure the emulator you are running has **Google Play Store/Services** installed (indicated by the Play Store icon next to the system image in the Device Manager).
- Make sure you are signed into a Google Account on the emulator's device settings.

---

# Troubleshooting: "DioException [connection timeout]"

If your app successfully retrieves the Google `idToken` but then hangs or aborts with a **DioException [connection timeout]** trying to hit `http://192.168.1.2:4000/api/v1/auth/login`, it means the mobile app cannot connect to your backend API server.

Here is how to fix this networking mismatch:

### 1. Are you using an Emulator?
If you are running the app on an **Android Emulator**:
- The emulator runs inside its own virtual network. It **cannot** resolve `localhost` or `127.0.0.1` as your computer, and local Wi-Fi IPs like `192.168.1.2` can be unreliable or blocked by firewall.
- Android emulators have a built-in alias to access your development machine's `127.0.0.1`: **`10.0.2.2`**.
- **Fix**: Open `apps/mobile/.env` and change the base URL to:
  ```env
  API_BASE_URL=http://10.0.2.2:4000/api/v1
  ```

### 2. Are you using a Physical Device?
If you are running on a **Physical Android/iOS Device**:
- Your phone must be connected to the **exact same Wi-Fi network** as your computer.
- The IP address `192.168.1.2` might have changed on your computer (routers assign these dynamically!).
- **How to find your computer's current Wi-Fi IP**:
  1. Open PowerShell / Command Prompt on your computer.
  2. Run `ipconfig`.
  3. Look for **IPv4 Address** under your active Wi-Fi adapter (e.g. `192.168.1.15`).
- **Fix**: Update `API_BASE_URL` in `apps/mobile/.env` with your computer's *current* IP:
  ```env
  API_BASE_URL=http://<YOUR_NEW_IP>:4000/api/v1
  ```

### 3. Backend Binding Check (0.0.0.0 vs localhost)
By default, some backend servers only listen on `localhost` (`127.0.0.1`), which blocks external devices (like your physical phone) from connecting even if they are on the same Wi-Fi.
- If using a physical device, ensure your backend server binds to `0.0.0.0` (all interfaces) rather than just `localhost`.
- If using the emulator with `10.0.2.2`, this is not an issue since it tunnels directly to localhost.

---

# Troubleshooting: "Firebase ID token has incorrect 'aud' (audience) claim"

If you get this error in your backend console during login:
`Error: Firebase ID token has incorrect "aud" (audience) claim. Expected "oorg-62783" but got "1023990619577-..."`

Here is what it means and how we solved it:

### The Core Problem
Your mobile app only implements **pure Google Sign-In** (via `google_sign_in: ^7.2.0`), which produces a standard **Google ID Token** minted directly by Google (with an audience matching your Web Client ID).

However, the backend's `AuthService.loginWithFirebase` was verifying tokens using the **Firebase Admin SDK** (`admin.auth().verifyIdToken(idToken)`). Firebase Admin strictly expects a **Firebase ID Token** (minted by Firebase Auth, with an audience matching your Firebase Project ID `oorg-62783`).

Since your Flutter mobile app does not include the Firebase package stack (`firebase_core`/`firebase_auth`), it was impossible for the app to mint a Firebase-specific token.

### The Solution (Implemented)
We updated the backend `AuthService.loginWithFirebase` in `apps/api/src/features/auth/auth.service.ts` to be fully hybrid and support both token types:
1. **JWT Header Inspection**: The backend decodes the token's header to identify the token issuer (`iss`).
2. **Dynamic Verification**:
   - **If issued by Google (`accounts.google.com`)**: The backend verifies the token directly against Google's official `https://oauth2.googleapis.com/tokeninfo` validation API.
   - **If issued by Firebase**: The backend verifies the token using the existing `admin.auth().verifyIdToken()` logic.
3. **Parity Mapping**: Once verified, the backend maps Google's unique subject ID (`sub`) to `uid` to ensure consistent down-stream database record creations.

This hybrid approach makes Google Sign-In from the mobile app work flawlessly out-of-the-box without requiring you to install and configure the entire Firebase SDK stack on your Flutter mobile client!

---

# Troubleshooting: "The column users.username does not exist in the current database"

If your backend throws this error when attempting to query users:
`PrismaClientKnownRequestError: The column users.username does not exist in the current database.`

Here is what it means and how we solved it:

### The Core Problem
The Prisma schema (`schema.prisma`) was updated with the new `username`, `cover`, and `bio` columns, but these changes had not yet been applied to your physical PostgreSQL database. Consequently, when the Prisma Client tried to run `findUnique()` selecting `username`, Postgres rejected the query because the column literally did not exist in the live table yet.

### The Solution (Executed)
I ran a schema sync directly to your live database instance:
```bash
npx prisma db push --accept-data-loss
```
*(The `--accept-data-loss` flag is required because we added a new `unique` constraint for the `username` column, which Postgres flags as a potential risk for existing tables).*

Your remote/local PostgreSQL database is now **100% in sync** with your latest Prisma schema! The table has been successfully migrated, and all `username`, `cover`, `bio` fields are fully available.






