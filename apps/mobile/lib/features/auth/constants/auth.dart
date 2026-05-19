// ignore_for_file: constant_identifier_names

class AuthConstants {
  // User Activity Modules
  static const String AUTH = "AUTH";

  static const List<String> userActivityModule = [AUTH];

  // User Activity Types
  // Auth
  static const String LOGIN = "login";
  static const String REGISTER = "register";
  static const String LOGOUT = "logout";
  static const String PASSWORD_CHANGE = "password-change";
  static const String PASSWORD_RESET = "password-reset";
  static const String EMAIL_VERIFY = "email-verify";

  static const List<String> userActivityType = [
    LOGIN,
    REGISTER,
    LOGOUT,
    PASSWORD_CHANGE,
    PASSWORD_RESET,
    EMAIL_VERIFY,
  ];
}
