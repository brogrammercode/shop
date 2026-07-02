

import 'package:user/core/config.dart';

class ApiConstants {
  static const int CONNECT_TIMEOUT = 10000;
  static const int RECEIVE_TIMEOUT = 10000;
  static const int NOT_FOUND_STATUS_CODE = 404;

  static final String BASE_URL = AppConfig.apiBaseUrl;

  static const String CONTENT_TYPE_JSON = 'application/json';
  static const String HEADER_AUTHORIZATION = 'Authorization';
  static const String BEARER_PREFIX = 'Bearer';
  static const String MESSAGE_FIELD = 'message';
  static const String ERROR_FIELD = 'error';
}
