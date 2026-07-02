import 'package:user/utils/error.dart';
import 'package:user/features/auth/user.model.dart';

class AuthState {
  final UserModel? user;
  final List<dynamic> sessions;
  final List<dynamic> activities;
  final OperationInfo loginInfo;
  final OperationInfo googleSignInInfo;
  final OperationInfo sendOtpInfo;
  final OperationInfo loadUserInfo;
  final OperationInfo logoutInfo;
  final OperationInfo sessionInfo;
  final OperationInfo activityInfo;
  final OperationInfo loginWithSavedProfileInfo;

  const AuthState({
    this.user,
    this.sessions = const [],
    this.activities = const [],
    this.loginInfo = const OperationInfo(status: OperationStatus.initial),
    this.googleSignInInfo = const OperationInfo(status: OperationStatus.initial),
    this.sendOtpInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadUserInfo = const OperationInfo(status: OperationStatus.initial),
    this.logoutInfo = const OperationInfo(status: OperationStatus.initial),
    this.sessionInfo = const OperationInfo(status: OperationStatus.initial),
    this.activityInfo = const OperationInfo(status: OperationStatus.initial),
    this.loginWithSavedProfileInfo = const OperationInfo(status: OperationStatus.initial),
  });

  AuthState copyWith({
    UserModel? user,
    List<dynamic>? sessions,
    List<dynamic>? activities,
    OperationInfo? loginInfo,
    OperationInfo? googleSignInInfo,
    OperationInfo? sendOtpInfo,
    OperationInfo? loadUserInfo,
    OperationInfo? logoutInfo,
    OperationInfo? sessionInfo,
    OperationInfo? activityInfo,
    OperationInfo? loginWithSavedProfileInfo,
  }) {
    return AuthState(
      user: user ?? this.user,
      sessions: sessions ?? this.sessions,
      activities: activities ?? this.activities,
      loginInfo: loginInfo ?? this.loginInfo,
      googleSignInInfo: googleSignInInfo ?? this.googleSignInInfo,
      sendOtpInfo: sendOtpInfo ?? this.sendOtpInfo,
      loadUserInfo: loadUserInfo ?? this.loadUserInfo,
      logoutInfo: logoutInfo ?? this.logoutInfo,
      sessionInfo: sessionInfo ?? this.sessionInfo,
      activityInfo: activityInfo ?? this.activityInfo,
      loginWithSavedProfileInfo: loginWithSavedProfileInfo ?? this.loginWithSavedProfileInfo,
    );
  }
}
