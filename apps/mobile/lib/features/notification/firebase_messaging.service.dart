import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/globals.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/notification/notification.constant.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebaseMessagingNavigationService {
  static void configure() {
    FirebaseMessaging.onMessageOpenedApp.listen(_openMessage);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final message = await FirebaseMessaging.instance.getInitialMessage();
      if (message != null) {
        await _openMessage(message);
      }
    });
  }

  static Future<void> _openMessage(RemoteMessage message) async {
    final orderId = _extractOrderId(
      message.data['ref_link']?.toString(),
      message.data['ref_type']?.toString(),
    );
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
