import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/auth/cubit/auth_state.dart';
import 'package:mobile/features/auth/repo/auth_repo.dart';
import 'package:mobile/utils/error.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo _authRepo;

  AuthCubit(this._authRepo) : super(const AuthState());

  Future<void> loginWithGoogle(String idToken) async {
    emit(
      state.copyWith(
        loginInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

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
    final result = await _authRepo.getCurrentUser();

    result.fold((failure) => null, (user) => emit(state.copyWith(user: user)));
  }
}
