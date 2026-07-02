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
        baseUrl: ApiConstants.BASE_URL,
        connectTimeout: const Duration(
          milliseconds: ApiConstants.CONNECT_TIMEOUT,
        ),
        receiveTimeout: const Duration(
          milliseconds: ApiConstants.RECEIVE_TIMEOUT,
        ),
        contentType: ApiConstants.CONTENT_TYPE_JSON,
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
            options.headers[ApiConstants.HEADER_AUTHORIZATION] =
                '${ApiConstants.BEARER_PREFIX} $token';
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

  Future<Response> uploadFiles(String path, List<String> filePaths) async {
    try {
      final files = await Future.wait(
        filePaths.map((path) => MultipartFile.fromFile(path)),
      );
      final formData = FormData.fromMap({
        'images': files, // Matches 'images' in multer upload.array('images')
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
      return const NetworkException(AppText.CONNECTION_TIMED_OUT);
    }

    final statusCode = e.response?.statusCode;

    if (statusCode == 401 || statusCode == 403) {
      final message =
          _readErrorMessage(e.response?.data) ?? AuthText.AUTHENTICATION_FAILED;
      return AuthException(message);
    }

    final message =
        _readErrorMessage(e.response?.data) ?? AppText.SOMETHING_WENT_WRONG;
    return ServerException(message);
  }

  String? _readErrorMessage(dynamic data) {
    if (data is Map<String, dynamic>) {
      final message =
          data[ApiConstants.MESSAGE_FIELD] ?? data[ApiConstants.ERROR_FIELD];
      return message?.toString();
    }
    if (data is Map) {
      final map = Map<String, dynamic>.from(data);
      final message =
          map[ApiConstants.MESSAGE_FIELD] ?? map[ApiConstants.ERROR_FIELD];
      return message?.toString();
    }
    if (data is String && data.trim().isNotEmpty) {
      return data;
    }
    return null;
  }
}
