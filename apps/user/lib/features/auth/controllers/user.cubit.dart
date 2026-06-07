import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user/features/auth/controllers/user.repo.dart';
import 'package:user/features/auth/controllers/user.state.dart';
import 'package:user/features/auth/models/user_log.dart';
import 'package:user/features/auth/models/user_session.dart';
import 'package:user/utils/error.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepo _userRepo;

  UserCubit({required UserRepo userRepo})
      : _userRepo = userRepo,
        super(const UserState());

  Future<void> loginWithGoogle(String idToken) async {
    emit(
      state.copyWith(
        loginInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.loginWithGoogle(idToken);

    result.fold(
      (failure) => emit(
        state.copyWith(
          loginInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (user) => emit(
        state.copyWith(
          user: user,
          loginInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> getCurrentUser() async {
    emit(
      state.copyWith(
        loadUserInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.getCurrentUser();

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadUserInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (user) => emit(
        state.copyWith(
          user: user,
          loadUserInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> logout() async {
    emit(
      state.copyWith(
        logoutInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.logout();

    result.fold(
      (failure) => emit(
        state.copyWith(
          logoutInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) => emit(
        const UserState(
          logoutInfo: OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> logActivity(UserLogModel log) async {
    emit(
      state.copyWith(
        logActivityInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.logActivity(log);

    result.fold(
      (failure) => emit(
        state.copyWith(
          logActivityInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) => emit(
        state.copyWith(
          logActivityInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> getActivities(String userId) async {
    emit(
      state.copyWith(
        loadActivitiesInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.getActivities(userId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadActivitiesInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (activities) => emit(
        state.copyWith(
          activities: activities,
          loadActivitiesInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> sendOtp(String phoneNumber) async {
    emit(
      state.copyWith(
        sendOtpInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.sendOtp(phoneNumber);

    result.fold(
      (failure) => emit(
        state.copyWith(
          sendOtpInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) => emit(
        state.copyWith(
          sendOtpInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    emit(
      state.copyWith(
        verifyOtpInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.verifyOtp(phoneNumber, otp);

    result.fold(
      (failure) => emit(
        state.copyWith(
          verifyOtpInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (user) => emit(
        state.copyWith(
          user: user,
          verifyOtpInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> getSessions() async {
    emit(
      state.copyWith(
        loadSessionsInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.getSessions();

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadSessionsInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (sessions) => emit(
        state.copyWith(
          sessions: sessions,
          loadSessionsInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> createSession(UserSessionModel session) async {
    emit(
      state.copyWith(
        createSessionInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.createSession(session);

    result.fold(
      (failure) => emit(
        state.copyWith(
          createSessionInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) => emit(
        state.copyWith(
          createSessionInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> terminateSession(String sessionId) async {
    emit(
      state.copyWith(
        terminateSessionInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.terminateSession(sessionId);

    result.fold(
      (failure) => emit(
        state.copyWith(
          terminateSessionInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) {
        final currentSessions = state.sessions != null
            ? List<UserSessionModel>.from(state.sessions!)
            : <UserSessionModel>[];
        currentSessions.removeWhere((session) => session.id == sessionId);
        emit(
          state.copyWith(
            sessions: currentSessions,
            terminateSessionInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> getAdBanners() async {
    emit(
      state.copyWith(
        loadAdBannersInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.getAdBanners();

    result.fold(
      (failure) => emit(
        state.copyWith(
          loadAdBannersInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (adBanners) => emit(
        state.copyWith(
          adBanners: adBanners,
          loadAdBannersInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }
}
