class NotificationConstant {
  static const String TITLE = 'Notifications';
  static const String FILTERS = 'Filters';
  static const String TODAY = 'Today';
  static const String PREVIOUS = 'Previous';
  static const String NO_NOTIFICATIONS = 'No notifications found';
  static const String MARKED_READ = 'Notifications marked as read';
  static const String DEVICE_TOKEN_SAVED = 'Notification device ready';
  static const String OPEN_ORDER_FAILED = 'Unable to open order';
  static const String NOTIFICATION_SETTINGS = 'NOTIFICATION SETTINGS';
  static const String NOTIFICATION_POLLING = 'Notification polling';
  static const String KDS_POLLING = 'KDS polling';
  static const String POLLING_SUBTITLE = 'Refresh interval';
  static const String SECONDS_SUFFIX = 'sec';
  static const String MINUTES_SUFFIX = 'min';
  static const String ACCOUNT = 'ACCOUNT';
  static const String SETTINGS = 'Settings';
  static const String LOG_OUT = 'Log Out';
  static const String LOG_OUT_CONFIRM = 'Are you sure you want to log out?';
  static const String LOG_OUT_ACTION = 'Log out';
  static const String CHANNEL_ID = 'order_notifications';
  static const String CHANNEL_NAME = 'Order Notifications';
  static const String CHANNEL_DESCRIPTION =
      'Notifications for POS and KDS order lifecycle updates';
  static const String REF_TYPE_ORDER = 'ORDER';
  static const String PLATFORM_ANDROID = 'android';
  static const String PLATFORM_IOS = 'ios';
  static const String PLATFORM_OTHER = 'other';
}

class NotificationEndpoints {
  static const String notifications = '/notifications';
  static const String deviceToken = '/notifications/device-token';
  static const String markAllRead = '/notifications/read-all';

  static String markRead(String id) {
    return '/notifications/$id/read';
  }
}
