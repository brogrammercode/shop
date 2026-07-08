import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobile/features/notification/models/notification.model.dart';
import 'package:mobile/features/notification/notification.constant.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';

class NotificationRepo {
  final ApiClient _apiClient;
  final FirebaseMessaging _firebaseMessaging;

  NotificationRepo({
    required ApiClient apiClient,
    FirebaseMessaging? firebaseMessaging,
  }) : _apiClient = apiClient,
       _firebaseMessaging = firebaseMessaging ?? FirebaseMessaging.instance;

  TaskResult<List<AppNotificationModel>> listNotifications() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        NotificationEndpoints.notifications,
      );
      final data = response.data['data'] as List;
      return data.map((item) => AppNotificationModel.fromJson(item)).toList();
    });
  }

  TaskResult<void> markAllRead() async {
    return tryCatchAsync(() async {
      await _apiClient.patch(NotificationEndpoints.markAllRead);
    });
  }

  TaskResult<void> markRead(String id) async {
    return tryCatchAsync(() async {
      await _apiClient.patch(NotificationEndpoints.markRead(id));
    });
  }

  TaskResult<void> initializeFirebaseMessaging() async {
    return tryCatchAsync(() async {
      await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      final token = await _firebaseMessaging.getToken();
      if (token != null && token.trim().isNotEmpty) {
        await _saveToken(token);
      }
      _firebaseMessaging.onTokenRefresh.listen((token) {
        _saveToken(token);
      });
    });
  }

  Future<void> _saveToken(String token) async {
    await _apiClient.post(
      NotificationEndpoints.deviceToken,
      data: {'token': token, 'platform': _platform},
    );
  }

  String get _platform {
    if (Platform.isAndroid) {
      return NotificationConstant.PLATFORM_ANDROID;
    }
    if (Platform.isIOS) {
      return NotificationConstant.PLATFORM_IOS;
    }
    return NotificationConstant.PLATFORM_OTHER;
  }
}
