import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobile/core/globals.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/notification/notification.cubit.dart';
import 'package:mobile/features/notification/notification.constant.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebaseMessagingNavigationService {
  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _androidChannel =
      AndroidNotificationChannel(
        NotificationConstant.CHANNEL_ID,
        NotificationConstant.CHANNEL_NAME,
        description: NotificationConstant.CHANNEL_DESCRIPTION,
        importance: Importance.high,
      );

  static Future<void> configure() async {
    await _initializeLocalNotifications();
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
    FirebaseMessaging.onMessage.listen(_showForegroundNotification);
    FirebaseMessaging.onMessageOpenedApp.listen(_openMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final message = await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        await _openMessage(message);
      }
    });
  }

  static Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _localNotifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        _openPayload(response.payload);
      },
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  static Future<void> _showForegroundNotification(RemoteMessage message) async {
    final context = navigatorKey.currentContext;
    if (context != null) {
      context.read<NotificationCubit>().listNotifications(silent: true);
    }
    final title = message.notification?.title ?? message.data['title'];
    final body = message.notification?.body ?? message.data['message'];
    if (title == null && body == null) {
      return;
    }
    await _localNotifications.show(
      id: message.hashCode,
      title: title?.toString() ?? NotificationConstant.TITLE,
      body: body?.toString() ?? '',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          NotificationConstant.CHANNEL_ID,
          NotificationConstant.CHANNEL_NAME,
          channelDescription: NotificationConstant.CHANNEL_DESCRIPTION,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  static Future<void> _openPayload(String? payload) async {
    if (payload == null || payload.trim().isEmpty) {
      return;
    }
    final data = jsonDecode(payload);
    if (data is! Map) {
      return;
    }
    await _openOrderFromData(
      data['ref_link']?.toString(),
      data['ref_type']?.toString(),
    );
  }

  static Future<void> _openMessage(RemoteMessage message) async {
    await _openOrderFromData(
      message.data['ref_link']?.toString(),
      message.data['ref_type']?.toString(),
    );
  }

  static Future<void> _openOrderFromData(
    String? refLink,
    String? refType,
  ) async {
    final orderId = _extractOrderId(refLink, refType);
    if (orderId == null) {
      return;
    }
    final context = navigatorKey.currentContext;
    if (context == null) {
      return;
    }
    final posKdsCubit = context.read<PosKdsCubit>();
    await posKdsCubit.getOrder(orderId);
    if (navigatorKey.currentContext != null &&
        posKdsCubit.state.selectedOrder?.id == orderId) {
      navigatorKey.currentState?.pushNamed(AppRoutes.orderDetail);
    }
  }

  static String? _extractOrderId(String? refLink, String? refType) {
    if (refType != null &&
        refType.isNotEmpty &&
        refType != NotificationConstant.REF_TYPE_ORDER) {
      return null;
    }
    if (refLink == null || refLink.trim().isEmpty) {
      return null;
    }
    final uri = Uri.tryParse(refLink.trim());
    final segments = uri?.pathSegments ?? const [];
    if (segments.isNotEmpty) {
      return segments.last;
    }
    return refLink.trim();
  }
}
