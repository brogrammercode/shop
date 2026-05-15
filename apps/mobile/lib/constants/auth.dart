// ignore_for_file: constant_identifier_names

class AuthConstants {
  // User Activity Modules
  static const String AUTH = "AUTH";
  static const String GANG = "GANG";
  static const String PLAYER = "PLAYER";
  static const String MISSION = "MISSION";
  static const String SYSTEM = "SYSTEM";

  static const List<String> userActivityModule = [
    AUTH,
    GANG,
    PLAYER,
    MISSION,
    SYSTEM,
  ];

  // User Activity Types
  // Auth
  static const String LOGIN = "login";
  static const String REGISTER = "register";
  static const String LOGOUT = "logout";
  static const String PASSWORD_CHANGE = "password-change";
  static const String PASSWORD_RESET = "password-reset";
  static const String EMAIL_VERIFY = "email-verify";

  // Gang
  static const String GANG_CREATE = "gang-create";
  static const String GANG_JOIN = "gang-join";
  static const String GANG_LEAVE = "gang-leave";
  static const String GANG_UPDATE = "gang-update";
  static const String GANG_KICK = "gang-kick";
  static const String GANG_INVITE = "gang-invite";

  // Player
  static const String PLAYER_UPDATE = "player-update";
  static const String PLAYER_LEVEL_UP = "player-level-up";
  static const String PLAYER_ACHIEVEMENT = "player-achievement";
  static const String PLAYER_XP_GAIN = "player-xp-gain";

  // Mission
  static const String MISSION_START = "mission-start";
  static const String MISSION_COMPLETE = "mission-complete";
  static const String MISSION_FAIL = "mission-fail";

  static const List<String> userActivityType = [
    LOGIN,
    REGISTER,
    LOGOUT,
    PASSWORD_CHANGE,
    PASSWORD_RESET,
    EMAIL_VERIFY,
    GANG_CREATE,
    GANG_JOIN,
    GANG_LEAVE,
    GANG_UPDATE,
    GANG_KICK,
    GANG_INVITE,
    PLAYER_UPDATE,
    PLAYER_LEVEL_UP,
    PLAYER_ACHIEVEMENT,
    PLAYER_XP_GAIN,
    MISSION_START,
    MISSION_COMPLETE,
    MISSION_FAIL,
  ];
}
