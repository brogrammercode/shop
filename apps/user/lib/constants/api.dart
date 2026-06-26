

import 'package:user/core/config.dart';

class ApiConstants {
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  static const int notFoundStatusCode = 404;

  static final String baseUrl = AppConfig.apiBaseUrl;

  static const String contentTypeJson = 'application/json';
  static const String headerAuthorization = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String messageField = 'message';
  static const String errorField = 'error';
}
