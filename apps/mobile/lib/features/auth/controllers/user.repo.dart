import 'package:mobile/features/auth/constants/user.endpoints.dart';
import 'package:mobile/features/auth/constants/user.params.dart';
import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/auth/models/user_log.dart';
import 'package:mobile/features/auth/models/user_session.dart';
import 'package:mobile/features/auth/models/ad_banner.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/services/local_storage.dart';
import 'package:mobile/utils/try_catch.dart';

class UserRepo {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  UserRepo({
    required ApiClient apiClient,
    required LocalStorage localStorage,
  })  : _apiClient = apiClient,
        _localStorage = localStorage;

  TaskResult<UserModel> loginWithGoogle(String idToken) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        UserEndpoints.loginEndpoint,
        data: {UserParams.idTokenKey: idToken},
      );
      final data = response.data[UserParams.dataKey];
      final user = UserModel.fromJson(data[UserParams.userKey]);
      final token = data[UserParams.tokensKey][UserParams.accessTokenKey]?.toString() ?? '';
      await _localStorage.saveToken(token);
      return user;
    });
  }

  TaskResult<UserModel> getCurrentUser() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(UserEndpoints.meEndpoint);
      final data = response.data[UserParams.dataKey];
      return UserModel.fromJson(data);
    });
  }

  TaskResult<void> logout() async {
    return tryCatchAsync(() async {
      await _localStorage.clearSession();
    });
  }

  TaskResult<void> logActivity(UserLogModel log) async {
    return tryCatchAsync(() async {
      await _apiClient.post(
        UserEndpoints.activityEndpoint,
        data: log.toJson(),
      );
    });
  }

  TaskResult<List<UserLogModel>> getActivities(String userId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        '${UserEndpoints.activityEndpoint}/$userId',
      );
      final list = response.data[UserParams.dataKey] as List;
      return list.map((item) => UserLogModel.fromJson(item)).toList();
    });
  }

  TaskResult<void> sendOtp(String phoneNumber) async {
    return tryCatchAsync(() async {
      await _apiClient.post(
        UserEndpoints.sendOtp,
        data: {UserParams.phoneNumberKey: phoneNumber},
      );
    });
  }

  TaskResult<UserModel> verifyOtp(String phoneNumber, String otp) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        UserEndpoints.verifyOtp,
        data: {
          UserParams.phoneNumberKey: phoneNumber,
          UserParams.otpKey: otp,
        },
      );
      final data = response.data[UserParams.dataKey];
      final user = UserModel.fromJson(data[UserParams.userKey]);
      final token = data[UserParams.tokensKey][UserParams.accessTokenKey]?.toString() ?? '';
      await _localStorage.saveToken(token);
      return user;
    });
  }

  TaskResult<List<UserSessionModel>> getSessions() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(UserEndpoints.sessions);
      final list = response.data[UserParams.dataKey] as List;
      return list.map((item) => UserSessionModel.fromJson(item)).toList();
    });
  }

  TaskResult<void> createSession(UserSessionModel session) async {
    return tryCatchAsync(() async {
      await _apiClient.post(
        UserEndpoints.sessions,
        data: session.toJson(),
      );
    });
  }

  TaskResult<void> terminateSession(String sessionId) async {
    return tryCatchAsync(() async {
      await _apiClient.delete(
        '${UserEndpoints.sessions}/$sessionId',
      );
    });
  }

  TaskResult<List<AdBannerModel>> getAdBanners() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(UserEndpoints.adBanners);
      final list = response.data[UserParams.dataKey] as List;
      final banners = list.map((item) => AdBannerModel.fromJson(item)).toList();
      final now = DateTime.now();
      return banners.where((banner) {
        final isActive = banner.status.toUpperCase() == 'ACTIVE';
        DateTime? fromDate;
        DateTime? toDate;
        try {
          fromDate = DateTime.parse(banner.valid_from);
        } catch (_) {}
        try {
          toDate = DateTime.parse(banner.valid_to);
        } catch (_) {}
        final isFromValid = fromDate == null || now.isAfter(fromDate);
        final isToValid = toDate == null || now.isBefore(toDate);
        return isActive && isFromValid && isToValid;
      }).toList();
    });
  }
}
