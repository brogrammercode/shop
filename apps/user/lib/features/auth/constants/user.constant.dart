class UserConstant {
  static const String loginSuccessMessage = 'Login successful';
  static const String logoutSuccessMessage = 'Logout successful';
  static const String otpSentSuccess = 'OTP sent successfully';
  static const String otpVerifiedSuccess = 'OTP verified successfully';
  static const String sessionTerminatedSuccess = 'Session terminated successfully';
  
  static const String googleTokenRetrievalFailed = 'Failed to retrieve Google token';
  static const String noEmployeeProfileFound = 'No employee profile found.';
  static const String accessDeniedEmployeeRequired = 'Access denied: Employee profile required.';
  static const String pleaseEnterPhoneNumber = 'Please enter phone number';
  static const String pleaseEnterOtp = 'Please enter OTP';
  static const String invalidOtp = 'Invalid OTP entered. Please try again.';
  static const String noSavedProfileFound = 'No saved profile found. Please login manually.';

  static const String chooseYourAccount = 'Choose your account';
  static const String logInOrSignUp = 'Log in or sign up';
  static const String enterPhoneNumber = 'Enter Phone Number';
  static const String enterOtp = 'Enter 6-digit OTP';
  static const String verifyOtp = 'Verify OTP';
  static const String resendOtp = 'Resend OTP';
  static String resendOtpIn(int seconds) => 'Resend OTP in ${seconds}s';
  static const String googleSignInCanceled = 'Google sign in canceled';
  static const String rememberLogin = 'Remember my login for faster sign-in';
  static const String continueText = 'Continue';
  static const String byContinuingYouAgreeToOur = 'By continuing, you agree to our ';
  static const String termsOfService = 'Terms of Service';
  static const String privacyPolicy = 'Privacy Policy';
  static const String contentPolicies = 'Content Policies';
  
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String contentPoliciesUrl = 'https://example.com/content';

  static const String unknownUser = 'Unknown User';
}
