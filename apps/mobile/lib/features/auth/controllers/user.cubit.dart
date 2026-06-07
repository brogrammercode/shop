import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/features/auth/constants/user.constant.dart';
import 'package:mobile/features/auth/controllers/user.repo.dart';
import 'package:mobile/features/auth/controllers/user.state.dart';
import 'package:mobile/features/auth/models/user_log.dart';
import 'package:mobile/features/auth/models/user_session.dart';
import 'package:mobile/features/auth/models/user.dart';
import 'package:mobile/features/business/controllers/business.repo.dart';
import 'package:mobile/services/json_cache.dart';
import 'package:mobile/utils/error.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepo _userRepo;
  final BusinessRepo _businessRepo;
  final JsonCache _jsonCache;

  UserCubit({
    required UserRepo userRepo,
    required BusinessRepo businessRepo,
  })  : _userRepo = userRepo,
        _businessRepo = businessRepo,
        _jsonCache = JsonCache(),
        super(const UserState()) {
    _initFromCache();
  }

  Future<void> _initFromCache() async {
    final userData = await _jsonCache.getUser();
    if (userData != null) {
      try {
        final user = UserModel.fromJson(userData);
        emit(state.copyWith(user: user));
      } catch (_) {}
    }
  }

  Future<void> loginWithGoogle(String idToken) async {
    emit(
      state.copyWith(
        loginInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.loginWithGoogle(idToken);

    await result.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            loginInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (user) async {
        final contextResult = await _businessRepo.getContext();
        
        await contextResult.fold(
          (failure) async {
            await _userRepo.logout();
            await _jsonCache.clearAll();
            Fluttertoast.showToast(msg: 'Access denied: Employee profile required.');
            emit(
              state.copyWith(
                loginInfo: OperationInfo(
                  status: OperationStatus.error,
                  error: AuthFailure('No employee profile found.'),
                ),
              ),
            );
          },
          (businessContext) async {
            await _jsonCache.saveUser(user.toJson());
            await _jsonCache.saveBusinessContext(businessContext.toJson());
            Fluttertoast.showToast(msg: UserConstant.loginSuccessMessage);
            emit(
              state.copyWith(
                user: user,
                loginInfo: const OperationInfo(status: OperationStatus.success),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> getCurrentUser() async {
    emit(
      state.copyWith(
        loadUserInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.getCurrentUser();

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          loadUserInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (user) async {
        await _jsonCache.saveUser(user.toJson());
        emit(
          state.copyWith(
            user: user,
            loadUserInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> logout() async {
    emit(
      state.copyWith(
        logoutInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.logout();

    await result.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            logoutInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) async {
        await _jsonCache.clearAll();
        Fluttertoast.showToast(msg: UserConstant.logoutSuccessMessage);
        emit(
          const UserState(
            logoutInfo: OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> logActivity(UserLogModel log) async {
    emit(
      state.copyWith(
        logActivityInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.logActivity(log);

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          logActivityInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) async => emit(
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

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          loadActivitiesInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (activities) async => emit(
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

    await result.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            sendOtpInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) async {
        Fluttertoast.showToast(msg: UserConstant.otpSentSuccess);
        emit(
          state.copyWith(
            sendOtpInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    emit(
      state.copyWith(
        verifyOtpInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.verifyOtp(phoneNumber, otp);

    await result.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            verifyOtpInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (user) async {
        final contextResult = await _businessRepo.getContext();
        
        await contextResult.fold(
          (failure) async {
            await _userRepo.logout();
            await _jsonCache.clearAll();
            Fluttertoast.showToast(msg: 'Access denied: Employee profile required.');
            emit(
              state.copyWith(
                verifyOtpInfo: OperationInfo(
                  status: OperationStatus.error,
                  error: AuthFailure('No employee profile found.'),
                ),
              ),
            );
          },
          (businessContext) async {
            await _jsonCache.saveUser(user.toJson());
            await _jsonCache.saveBusinessContext(businessContext.toJson());
            Fluttertoast.showToast(msg: UserConstant.otpVerifiedSuccess);
            emit(
              state.copyWith(
                user: user,
                verifyOtpInfo: const OperationInfo(status: OperationStatus.success),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> getSessions() async {
    emit(
      state.copyWith(
        loadSessionsInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _userRepo.getSessions();

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          loadSessionsInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (sessions) async => emit(
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

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          createSessionInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) async => emit(
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

    await result.fold(
      (failure) async {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            terminateSessionInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) async {
        Fluttertoast.showToast(msg: UserConstant.sessionTerminatedSuccess);
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

    await result.fold(
      (failure) async => emit(
        state.copyWith(
          loadAdBannersInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (adBanners) async => emit(
        state.copyWith(
          adBanners: adBanners,
          loadAdBannersInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }
}
