import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/auth/models/user_log.dart';
import 'package:mobile/features/auth/models/user_session.dart';
import 'package:mobile/features/auth/models/ad_banner.dart';
import 'package:mobile/utils/error.dart';

class UserState {
  final UserModel? user;
  final List<UserLogModel>? activities;
  final List<UserSessionModel>? sessions;
  final List<AdBannerModel>? adBanners;
  final OperationInfo loginInfo;
  final OperationInfo logoutInfo;
  final OperationInfo loadUserInfo;
  final OperationInfo loadActivitiesInfo;
  final OperationInfo logActivityInfo;
  final OperationInfo sendOtpInfo;
  final OperationInfo verifyOtpInfo;
  final OperationInfo loadSessionsInfo;
  final OperationInfo terminateSessionInfo;
  final OperationInfo createSessionInfo;
  final OperationInfo loadAdBannersInfo;

  const UserState({
    this.user,
    this.activities,
    this.sessions,
    this.adBanners,
    this.loginInfo = const OperationInfo(status: OperationStatus.initial),
    this.logoutInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadUserInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadActivitiesInfo = const OperationInfo(status: OperationStatus.initial),
    this.logActivityInfo = const OperationInfo(status: OperationStatus.initial),
    this.sendOtpInfo = const OperationInfo(status: OperationStatus.initial),
    this.verifyOtpInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadSessionsInfo = const OperationInfo(status: OperationStatus.initial),
    this.terminateSessionInfo = const OperationInfo(status: OperationStatus.initial),
    this.createSessionInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadAdBannersInfo = const OperationInfo(status: OperationStatus.initial),
  });

  UserState copyWith({
    UserModel? user,
    List<UserLogModel>? activities,
    List<UserSessionModel>? sessions,
    List<AdBannerModel>? adBanners,
    OperationInfo? loginInfo,
    OperationInfo? logoutInfo,
    OperationInfo? loadUserInfo,
    OperationInfo? loadActivitiesInfo,
    OperationInfo? logActivityInfo,
    OperationInfo? sendOtpInfo,
    OperationInfo? verifyOtpInfo,
    OperationInfo? loadSessionsInfo,
    OperationInfo? terminateSessionInfo,
    OperationInfo? createSessionInfo,
    OperationInfo? loadAdBannersInfo,
  }) {
    return UserState(
      user: user ?? this.user,
      activities: activities ?? this.activities,
      sessions: sessions ?? this.sessions,
      adBanners: adBanners ?? this.adBanners,
      loginInfo: loginInfo ?? this.loginInfo,
      logoutInfo: logoutInfo ?? this.logoutInfo,
      loadUserInfo: loadUserInfo ?? this.loadUserInfo,
      loadActivitiesInfo: loadActivitiesInfo ?? this.loadActivitiesInfo,
      logActivityInfo: logActivityInfo ?? this.logActivityInfo,
      sendOtpInfo: sendOtpInfo ?? this.sendOtpInfo,
      verifyOtpInfo: verifyOtpInfo ?? this.verifyOtpInfo,
      loadSessionsInfo: loadSessionsInfo ?? this.loadSessionsInfo,
      terminateSessionInfo: terminateSessionInfo ?? this.terminateSessionInfo,
      createSessionInfo: createSessionInfo ?? this.createSessionInfo,
      loadAdBannersInfo: loadAdBannersInfo ?? this.loadAdBannersInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UserState &&
        other.user == user &&
        other.activities == activities &&
        other.sessions == sessions &&
        other.adBanners == adBanners &&
        other.loginInfo == loginInfo &&
        other.logoutInfo == logoutInfo &&
        other.loadUserInfo == loadUserInfo &&
        other.loadActivitiesInfo == loadActivitiesInfo &&
        other.logActivityInfo == logActivityInfo &&
        other.sendOtpInfo == sendOtpInfo &&
        other.verifyOtpInfo == verifyOtpInfo &&
        other.loadSessionsInfo == loadSessionsInfo &&
        other.terminateSessionInfo == terminateSessionInfo &&
        other.createSessionInfo == createSessionInfo &&
        other.loadAdBannersInfo == loadAdBannersInfo;
  }

  @override
  int get hashCode =>
      user.hashCode ^
      activities.hashCode ^
      sessions.hashCode ^
      adBanners.hashCode ^
      loginInfo.hashCode ^
      logoutInfo.hashCode ^
      loadUserInfo.hashCode ^
      loadActivitiesInfo.hashCode ^
      logActivityInfo.hashCode ^
      sendOtpInfo.hashCode ^
      verifyOtpInfo.hashCode ^
      loadSessionsInfo.hashCode ^
      terminateSessionInfo.hashCode ^
      createSessionInfo.hashCode ^
      loadAdBannersInfo.hashCode;
}

