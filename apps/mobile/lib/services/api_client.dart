import 'package:dio/dio.dart';
import 'package:mobile/constants/api.dart';
import 'package:mobile/constants/text.dart';
import 'package:mobile/services/local_storage.dart';
import 'package:mobile/utils/error.dart';

class ApiClient {
  late final Dio _dio;
  final LocalStorage _localStorage;

  ApiClient({LocalStorage? localStorage})
    : _localStorage = localStorage ?? LocalStorage() {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.connectTimeout,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.receiveTimeout,
        ),
        contentType: ApiConstants.contentTypeJson,
      ),
    );
    _dio.interceptors.add(
      LogInterceptor(responseBody: true, requestBody: true),
    );
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _localStorage.getToken();
          if (token != null) {
            options.headers[ApiConstants.headerAuthorization] =
                '${ApiConstants.bearerPrefix} $token';
          }
          handler.next(options);
        },
      ),
    );
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response> post(String path, {dynamic data}) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response> uploadFile(String path, String filePath) async {
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      return await _dio.post(path, data: formData);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response> put(String path, {dynamic data}) async {
    try {
      return await _dio.put(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response> patch(String path, {dynamic data}) async {
    try {
      return await _dio.patch(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response> delete(String path, {dynamic data}) async {
    try {
      return await _dio.delete(path, data: data);
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkException(AppText.connectionTimedOut);
    }

    final statusCode = e.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      final message =
          _readErrorMessage(e.response?.data) ?? AuthText.authenticationFailed;
      return AuthException(message);
    }

    final message =
        _readErrorMessage(e.response?.data) ?? AppText.somethingWentWrong;
    return ServerException(message);
  }

  String? _readErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message =
          data[ApiConstants.messageField] ?? data[ApiConstants.errorField];
      return message?.toString();
    }
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final message =
          map[ApiConstants.messageField] ?? map[ApiConstants.errorField];
      return message?.toString();
    }
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return null;
  }
}
