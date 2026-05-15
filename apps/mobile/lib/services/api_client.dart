import 'package:dio/dio.dart';
import 'package:mobile/constants/api.dart';
import 'package:mobile/services/local_storage.dart';
import 'package:mobile/utils/error.dart';

class ApiClient {
  late final Dio dio;
  final LocalStorage _localStorage = LocalStorage();

  ApiClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.BASE_URL,
        connectTimeout: const Duration(milliseconds: ApiConstants.CONNECT_TIMEOUT),
        receiveTimeout: const Duration(milliseconds: ApiConstants.RECEIVE_TIMEOUT),
        contentType: 'application/json',
      ),
    );

    dio.interceptors.add(LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ));

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _localStorage.getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          return handler.next(e);
        },
      ),
    );
  }

  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      throw _mapDioException(e);
    }
  }

  Exception _mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout) {
      return const NetworkException("Connection timed out");
    }

    if (e.type == DioExceptionType.connectionError) {
      return const NetworkException("No internet connection");
    }

    if (e.response != null) {
      final statusCode = e.response?.statusCode;
      final data = e.response?.data;
      
      String message = "Server Error";
      if (data is Map) {
        message = data['message'] ?? data['error'] ?? "Something went wrong";
      }

      if (statusCode == 401 || statusCode == 403) {
        return AuthException(message, statusCode: statusCode);
      }

      return ServerException(message, statusCode: statusCode);
    }

    return ServerException(e.message ?? "Unknown Error occurred");
  }
}
