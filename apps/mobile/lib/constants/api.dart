import 'package:mobile/core/config.dart';

class ApiConstants {
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  static const int notFoundStatusCode = 404;

  static String get baseUrl {
    return AppConfig.apiBaseUrl;
  }
}
