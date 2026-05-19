class AuthConstants {
  static const String loginTitle = 'Run every shop from one place';
  static const String loginSubtitle =
      'Sign in to create your business, add the first branch, and start managing orders with the right permissions.';
  static const String continueWithGoogle = 'Continue with Google';
  static const String signingIn = 'Signing in';
  static const String termsText =
      'By continuing, you agree to the shop terms and privacy policy.';
  static const String userSessionNotFound = 'User session not found';
  static const String googleSignInCancelled = 'Google sign in was cancelled';
  static const String googleSignInUnavailable =
      'Google sign in is not available on this device';
  static const String googleIdTokenMissing =
      'Google sign in did not return an identity token';

  static const String auth = "AUTH";

  static const List<String> userActivityModule = [auth];

  static const String login = "login";
  static const String register = "register";
  static const String logout = "logout";
  static const String passwordChange = "password-change";
  static const String passwordReset = "password-reset";
  static const String emailVerify = "email-verify";

  static const List<String> userActivityType = [
    login,
    register,
    logout,
    passwordChange,
    passwordReset,
    emailVerify,
  ];
}
