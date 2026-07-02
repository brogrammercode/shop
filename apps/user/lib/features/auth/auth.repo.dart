import 'package:google_sign_in/google_sign_in.dart';
import 'package:user/core/config.dart';
import 'package:user/features/auth/user.constant.dart';
import 'package:user/features/auth/user.endpoints.dart';
import 'package:user/features/auth/user.model.dart';
import 'package:user/services/api_client.dart';
import 'package:user/services/local_storage.dart';
import 'package:user/utils/error.dart';
import 'package:user/utils/try_catch.dart';

class AuthRepo {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  AuthRepo({
    required ApiClient apiClient,
    required LocalStorage localStorage,
  })  : _apiClient = apiClient,
        _localStorage = localStorage;

  TaskResult<void> sendOtp(String phoneNumber) async {
    return tryCatchAsync(() async {
      await _apiClient.post(
        UserEndpoints.sendOtpEndpoint,
        data: {'phone_number': phoneNumber},
      );
    });
  }

  TaskResult<UserModel> login(
    String phoneNumber,
    String otp, {
    bool rememberLogin = false,
  }) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        UserEndpoints.loginEndpoint,
        data: {
          'phone_number': phoneNumber,
          'otp': otp,
        },
      );
      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);
      await _localStorage.saveToken(data['tokens']['accessToken']);
      await _localStorage.saveRefreshToken(data['tokens']['refreshToken']);
      return user;
    });
  }

  TaskResult<UserModel> loginWithGoogle() async {
    return tryCatchAsync(() async {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: AppConfig.googleClientId,
        serverClientId: AppConfig.googleServerClientId,
      );

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw AuthException(UserConstant.googleSignInCancelled);
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final String? idToken = googleAuth.idToken;
      if (idToken == null) {
        throw AuthException(UserConstant.googleSignInFailed);
      }

      final response = await _apiClient.post(
        UserEndpoints.loginEndpoint,
        data: {'idToken': idToken},
      );

      final data = response.data['data'];
      final user = UserModel.fromJson(data['user']);
      await _localStorage.saveToken(data['tokens']['accessToken']);
      await _localStorage.saveRefreshToken(data['tokens']['refreshToken']);
      return user;
    });
  }

  TaskResult<void> logout(String sessionId) async {
    return tryCatchAsync(() async {
      await _apiClient.post('/hr/auth/logout', data: {'sessionId': sessionId});
      await _localStorage.clearSession();
    });
  }

  TaskResult<String> refreshAccessToken(String refreshToken) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post('/hr/auth/refresh', data: {'refreshToken': refreshToken});
      final accessToken = response.data['data']['accessToken'];
      await _localStorage.saveToken(accessToken);
      return accessToken;
    });
  }

  TaskResult<List<dynamic>> getSessions() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get('/hr/auth/sessions');
      return response.data['data'] as List<dynamic>;
    });
  }

  TaskResult<void> terminateSession(String sessionId) async {
    return tryCatchAsync(() async {
      await _apiClient.delete('/hr/auth/sessions/$sessionId');
    });
  }

  TaskResult<void> logActivity(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      await _apiClient.post('/hr/auth/activity', data: data);
    });
  }

  TaskResult<List<dynamic>> getActivities() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get('/hr/auth/activity');
      return response.data['data'] as List<dynamic>;
    });
  }

  TaskResult<UserModel> getMe() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(UserEndpoints.meEndpoint);
      final data = response.data['data'];
      return UserModel.fromJson(data['user'] ?? data);
    });
  }
}
