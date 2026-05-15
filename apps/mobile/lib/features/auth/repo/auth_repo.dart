import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/auth/repo/auth_endpoints.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/services/local_storage.dart';
import 'package:mobile/utils/try_catch.dart';

class AuthRepo {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  AuthRepo({
    required ApiClient apiClient,
    required LocalStorage localStorage,
  })  : _apiClient = apiClient,
        _localStorage = localStorage;

  TaskResult<UserModel> loginWithGoogle(String idToken) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        AuthEndpoints.googleLogin,
        data: {'idToken': idToken},
      );
      final user = UserModel.fromJson(response.data);
      await _localStorage.saveToken(user.token);
      return user;
    });
  }

  TaskResult<void> logout() async {
    return tryCatchAsync(() async {
      await _apiClient.post(AuthEndpoints.logout);
      await _localStorage.clearToken();
    });
  }

  TaskResult<UserModel> getCurrentUser() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(AuthEndpoints.me);
      return UserModel.fromJson(response.data);
    });
  }
}
