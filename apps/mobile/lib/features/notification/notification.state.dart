import 'package:mobile/features/notification/models/notification.model.dart';
import 'package:mobile/utils/error.dart';

class NotificationState {
  final List<AppNotificationModel> notifications;
  final OperationInfo loadInfo;
  final OperationInfo readInfo;
  final OperationInfo deviceTokenInfo;

  const NotificationState({
    this.notifications = const [],
    this.loadInfo = const OperationInfo(status: OperationStatus.initial),
    this.readInfo = const OperationInfo(status: OperationStatus.initial),
    this.deviceTokenInfo = const OperationInfo(status: OperationStatus.initial),
  });

  int get unreadCount {
    return notifications.where((notification) => !notification.read).length;
  }

  NotificationState copyWith({
    List<AppNotificationModel>? notifications,
    OperationInfo? loadInfo,
    OperationInfo? readInfo,
    OperationInfo? deviceTokenInfo,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      loadInfo: loadInfo ?? this.loadInfo,
      readInfo: readInfo ?? this.readInfo,
      deviceTokenInfo: deviceTokenInfo ?? this.deviceTokenInfo,
    );
  }
}
