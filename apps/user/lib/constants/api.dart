import 'dart:io';

class ApiConstants {
  static const int connectTimeout = 10000;
  static const int receiveTimeout = 10000;
  static const int notFoundStatusCode = 404;

  static const bool _usePhysicalDevice = true;

  static final String baseUrl = Platform.isAndroid
      ? _usePhysicalDevice
            ? 'http://192.168.1.7:5001/api/v1'
            : 'http://10.0.2.2:5001/api/v1'
      : 'http://localhost:5001/api/v1';

  static const String contentTypeJson = 'application/json';
  static const String headerAuthorization = 'Authorization';
  static const String bearerPrefix = 'Bearer';
  static const String messageField = 'message';
  static const String errorField = 'error';
}
