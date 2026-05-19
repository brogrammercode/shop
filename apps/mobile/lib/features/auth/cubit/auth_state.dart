import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/auth/models/user_activity.dart';
import 'package:mobile/utils/error.dart';

class AuthState {
  final UserModel? user;
  final List<UserActivityModel>? userActivities;
  final OperationInfo loginInfo;
  final OperationInfo logoutInfo;
  final OperationInfo sessionInfo;

  const AuthState({
    this.user,
    this.userActivities,
    this.loginInfo = const OperationInfo(status: OperationStatus.initial),
    this.logoutInfo = const OperationInfo(status: OperationStatus.initial),
    this.sessionInfo = const OperationInfo(status: OperationStatus.initial),
  });

  AuthState copyWith({
    UserModel? user,
    List<UserActivityModel>? userActivities,
    OperationInfo? loginInfo,
    OperationInfo? logoutInfo,
    OperationInfo? sessionInfo,
  }) {
    return AuthState(
      user: user ?? this.user,
      userActivities: userActivities ?? this.userActivities,
      loginInfo: loginInfo ?? this.loginInfo,
      logoutInfo: logoutInfo ?? this.logoutInfo,
      sessionInfo: sessionInfo ?? this.sessionInfo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AuthState &&
        other.user == user &&
        other.userActivities == userActivities &&
        other.loginInfo == loginInfo &&
        other.logoutInfo == logoutInfo &&
        other.sessionInfo == sessionInfo;
  }

  @override
  int get hashCode =>
      user.hashCode ^
      userActivities.hashCode ^
      loginInfo.hashCode ^
      logoutInfo.hashCode ^
      sessionInfo.hashCode;
}
