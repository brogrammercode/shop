import 'package:dio/dio.dart';
import 'package:user/constants/api.dart';
import 'package:user/constants/text.dart';
import 'package:user/services/local_storage.dart';
import 'package:user/services/json_cache.dart';
import 'package:user/utils/error.dart';
import 'package:user/core/globals.dart';
import 'package:user/core/routes.dart';

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
        onError: (DioException error, ErrorInterceptorHandler handler) async {
          if (error.response?.statusCode == 401) {
            if (error.requestOptions.path.contains('/auth/refresh')) {
              await _forceLogout();
              return handler.next(error);
            }
            
            final refreshToken = await _localStorage.getRefreshToken();
            if (refreshToken != null) {
              try {
                final refreshDio = Dio(BaseOptions(baseUrl: ApiConstants.BASE_URL));
                final response = await refreshDio.post('/auth/refresh', data: {
                  'refreshToken': refreshToken,
                });
                
                final newToken = response.data['data']['accessToken'];
                await _localStorage.saveToken(newToken);
                
                final opts = error.requestOptions;
                opts.headers[ApiConstants.HEADER_AUTHORIZATION] = '${ApiConstants.BEARER_PREFIX} $newToken';
                final cloneReq = await _dio.request(opts.path,
                    options: Options(method: opts.method, headers: opts.headers),
                    data: opts.data,
                    queryParameters: opts.queryParameters);
                
                return handler.resolve(cloneReq);
              } catch (e) {
                await _forceLogout();
                return handler.next(error);
              }
            } else {
              await _forceLogout();
              return handler.next(error);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<void> _forceLogout() async {
    await _localStorage.clearSession();
    final jsonCache = JsonCache();
    await jsonCache.clearAll();
    if (navigatorKey.currentState != null) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRoutes.session, (route) => false);
    }
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
