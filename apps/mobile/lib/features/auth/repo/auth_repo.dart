import 'package:mobile/features/auth/constants/auth.dart';
import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/auth/repo/auth_endpoints.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/services/local_storage.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/utils/try_catch.dart';

class AuthRepo {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  AuthRepo({required ApiClient apiClient, required LocalStorage localStorage})
    : _apiClient = apiClient,
      _localStorage = localStorage;

  TaskResult<UserModel> loginWithGoogle(String idToken) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        AuthEndpoints.login,
        data: {'idToken': idToken},
      );
      final data = _unwrapResponseData(response.data);
      final loginData = Map<String, dynamic>.from(data);
      final tokens = Map<String, dynamic>.from(loginData['tokens'] ?? {});
      final userData = Map<String, dynamic>.from(loginData['user'] ?? {});
      final user = UserModel.fromJson(
        userData,
      ).copyWith(token: (tokens['accessToken'] ?? '').toString());
      await _localStorage.saveToken(user.token);
      await _localStorage.saveUser(user);
      return user;
    });
  }

  TaskResult<void> logout() async {
    return tryCatchAsync(() async {
      await _localStorage.clearSession();
    });
  }

  TaskResult<UserModel> getCurrentUser() async {
    return tryCatchAsync(() async {
      final token = await _localStorage.getToken();
      if (token == null || token.isEmpty) {
        throw const CacheException(AuthConstants.userSessionNotFound);
      }

      try {
        final response = await _apiClient.get(AuthEndpoints.me);
        final data = _unwrapResponseData(response.data);
        final user = UserModel.fromJson(
          Map<String, dynamic>.from(data),
        ).copyWith(token: token);
        await _localStorage.saveUser(user);
        return user;
      } on AuthException {
        await _localStorage.clearSession();
        rethrow;
      }
    });
  }

  TaskResult<UserModel> getCachedUser() async {
    return tryCatchAsync(() async {
      final user = await _localStorage.getUser();
      if (user == null) {
        throw const CacheException(AuthConstants.userSessionNotFound);
      }
      return user;
    });
  }

  dynamic _unwrapResponseData(dynamic responseData) {
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('data')) {
      return responseData['data'];
    }

    return responseData;
  }
}
