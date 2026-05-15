// ignore_for_file: constant_identifier_names

class NotificationConstants {
  // Notification Modules
  static const String GANG = "GANG";
  static const String PLAYER = "PLAYER";
  static const String SYSTEM = "SYSTEM";
  static const String SOCIAL = "SOCIAL";
  static const String ACHIEVEMENT = "ACHIEVEMENT";

  static const List<String> notificationModule = [
    GANG,
    PLAYER,
    SYSTEM,
    SOCIAL,
    ACHIEVEMENT,
  ];

  // Notification Types
  // Gang
  static const String GANG_INVITE = "gang-invite";
  static const String GANG_ANNOUNCEMENT = "gang-announcement";
  static const String GANG_LEVEL_UP = "gang-level-up";
  static const String GANG_DISSOLVED = "gang-dissolved";

  // Social
  static const String FRIEND_REQUEST = "friend-request";
  static const String FRIEND_ACCEPTED = "friend-accepted";
  static const String DIRECT_MESSAGE = "direct-message";
  static const String PLAYER_MENTION = "player-mention";

  // System
  static const String SYSTEM_MAINTENANCE = "system-maintenance";
  static const String SECURITY_ALERT = "security-alert";
  static const String VERSION_UPDATE = "version-update";

  // Achievement
  static const String NEW_ACHIEVEMENT = "new-achievement";
  static const String MILESTONE_REACHED = "milestone-reached";

  static const List<String> notificationType = [
    GANG_INVITE,
    GANG_ANNOUNCEMENT,
    GANG_LEVEL_UP,
    GANG_DISSOLVED,
    FRIEND_REQUEST,
    FRIEND_ACCEPTED,
    DIRECT_MESSAGE,
    PLAYER_MENTION,
    SYSTEM_MAINTENANCE,
    SECURITY_ALERT,
    VERSION_UPDATE,
    NEW_ACHIEVEMENT,
    MILESTONE_REACHED,
  ];
}
