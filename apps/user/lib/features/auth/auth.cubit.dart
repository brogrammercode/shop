import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:user/features/auth/auth.repo.dart';
import 'package:user/features/auth/auth.state.dart';
import 'package:user/features/auth/user.constant.dart';
import 'package:user/utils/error.dart';
import 'package:user/services/json_cache.dart';
import 'package:user/features/auth/user.model.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  final JsonCache _cache = JsonCache();

  AuthCubit({required AuthRepo authRepo})
      : _authRepo = authRepo,
        super(const AuthState());

  Future<void> loginWithSavedProfile() async {
    emit(state.copyWith(loginWithSavedProfileInfo: const OperationInfo(status: OperationStatus.loading)));
    try {
      final profile = await _cache.getSavedProfile();
      if (profile != null && profile['user'] != null) {
        emit(state.copyWith(
          user: UserModel.fromJson(profile['user']),
          loginWithSavedProfileInfo: const OperationInfo(status: OperationStatus.success),
        ));
      } else {
        emit(state.copyWith(loginWithSavedProfileInfo: const OperationInfo(status: OperationStatus.initial)));
      }
    } catch (e) {
      emit(state.copyWith(loginWithSavedProfileInfo: const OperationInfo(status: OperationStatus.initial)));
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    emit(state.copyWith(sendOtpInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _authRepo.sendOtp(phoneNumber);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(
          sendOtpInfo: OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (_) {
        Fluttertoast.showToast(msg: UserConstant.OTP_SENT_SUCCESSFULLY);
        emit(state.copyWith(sendOtpInfo: const OperationInfo(status: OperationStatus.success)));
      },
    );
  }

  Future<void> login(String phoneNumber, String otp, {bool rememberLogin = false}) async {
    emit(state.copyWith(loginInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _authRepo.login(phoneNumber, otp, rememberLogin: rememberLogin);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(
          loginInfo: OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (user) {
        Fluttertoast.showToast(msg: UserConstant.LOGIN_SUCCESS_MESSAGE);
        _cache.saveSavedProfile({'user': user.toJson()});
        emit(state.copyWith(
          user: user,
          loginInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> loginWithGoogle() async {
    emit(state.copyWith(googleSignInInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _authRepo.loginWithGoogle();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(
          googleSignInInfo: OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (user) {
        Fluttertoast.showToast(msg: UserConstant.LOGIN_SUCCESS_MESSAGE);
        _cache.saveSavedProfile({'user': user.toJson()});
        emit(state.copyWith(
          user: user,
          googleSignInInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> logout(String sessionId) async {
    emit(state.copyWith(logoutInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _authRepo.logout(sessionId);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(logoutInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        _cache.clearSavedProfile();
        emit(state.copyWith(
          user: null,
          logoutInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> getSessions() async {
    emit(state.copyWith(sessionInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _authRepo.getSessions();
    result.fold(
      (failure) => emit(state.copyWith(sessionInfo: OperationInfo(status: OperationStatus.error, error: failure))),
      (data) => emit(state.copyWith(sessions: data, sessionInfo: const OperationInfo(status: OperationStatus.success))),
    );
  }

  Future<void> terminateSession(String sessionId) async {
    emit(state.copyWith(sessionInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _authRepo.terminateSession(sessionId);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(sessionInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) => getSessions(),
    );
  }

  Future<void> getActivities() async {
    emit(state.copyWith(activityInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _authRepo.getActivities();
    result.fold(
      (failure) => emit(state.copyWith(activityInfo: OperationInfo(status: OperationStatus.error, error: failure))),
      (data) => emit(state.copyWith(activities: data, activityInfo: const OperationInfo(status: OperationStatus.success))),
    );
  }

  Future<void> getCurrentUser() async {
    emit(state.copyWith(loadUserInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _authRepo.getMe();
    result.fold(
      (failure) {
        emit(state.copyWith(
          loadUserInfo: OperationInfo(status: OperationStatus.error, error: failure),
        ));
      },
      (user) {
        emit(state.copyWith(
          user: user,
          loadUserInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }
}
