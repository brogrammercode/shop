import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/auth/cubit/auth_state.dart';
import 'package:mobile/features/auth/repo/auth_repo.dart';
import 'package:mobile/services/google_auth_service.dart';
import 'package:mobile/utils/error.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;
  final GoogleAuthService _googleAuthService;

  AuthCubit({
    required AuthRepo authRepo,
    required GoogleAuthService googleAuthService,
  }) : _authRepo = authRepo,
       _googleAuthService = googleAuthService,
       super(const AuthState());

  Future<void> loginWithGoogle() async {
    emit(
      state.copyWith(
        loginInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    late final String idToken;
    try {
      idToken = await _googleAuthService.getIdToken();
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          loginInfo: OperationInfo(
            status: OperationStatus.error,
            error: AuthFailure(error.message, statusCode: error.statusCode),
          ),
        ),
      );
      return;
    }

    final result = await _authRepo.loginWithGoogle(idToken);

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

  Future<void> logout() async {
    emit(
      state.copyWith(
        logoutInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    await _googleAuthService.signOut();
    final result = await _authRepo.logout();

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
        const AuthState(
          logoutInfo: OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> getCurrentUser() async {
    emit(
      state.copyWith(
        sessionInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _authRepo.getCurrentUser();

    result.fold(
      (failure) => emit(
        state.copyWith(
          sessionInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (user) => emit(
        state.copyWith(
          user: user,
          sessionInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }
}
