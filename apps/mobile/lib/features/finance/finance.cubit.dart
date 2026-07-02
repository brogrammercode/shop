import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/finance/finance.repo.dart';
import 'package:mobile/features/finance/finance.state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  final FinanceRepo _repo;

  FinanceCubit({required FinanceRepo repo})
      : _repo = repo,
        super(const FinanceState());

  Future<void> listAccounts() async {
    emit(state.copyWith(loadAccountsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listAccounts();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadAccountsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (accounts) {
        emit(state.copyWith(
          accounts: accounts,
          loadAccountsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createAccount(Map<String, dynamic> data) async {
    emit(state.copyWith(saveAccountsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createAccount(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveAccountsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Account created');
        emit(state.copyWith(saveAccountsInfo: const OperationInfo(status: OperationStatus.success)));
        listAccounts();
      },
    );
  }

  Future<void> listTransactions() async {
    emit(state.copyWith(loadTransactionsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listTransactions();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadTransactionsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (transactions) {
        emit(state.copyWith(
          transactions: transactions,
          loadTransactionsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createTransaction(Map<String, dynamic> data) async {
    emit(state.copyWith(saveTransactionsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createTransaction(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveTransactionsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Transaction recorded');
        emit(state.copyWith(saveTransactionsInfo: const OperationInfo(status: OperationStatus.success)));
        listTransactions();
        listAccounts(); // Refresh balances
      },
    );
  }

  Future<void> listAssets() async {
    emit(state.copyWith(loadAssetsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listAssets();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadAssetsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (assets) {
        emit(state.copyWith(
          assets: assets,
          loadAssetsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createAsset(Map<String, dynamic> data) async {
    emit(state.copyWith(saveAssetsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createAsset(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveAssetsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Asset created');
        emit(state.copyWith(saveAssetsInfo: const OperationInfo(status: OperationStatus.success)));
        listAssets();
      },
    );
  }

  Future<void> listRoyalties() async {
    emit(state.copyWith(loadRoyaltiesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listRoyalties();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadRoyaltiesInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (royalties) {
        emit(state.copyWith(
          royalties: royalties,
          loadRoyaltiesInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> payRoyalty(String id) async {
    emit(state.copyWith(saveRoyaltiesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.payRoyalty(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveRoyaltiesInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Royalty paid');
        emit(state.copyWith(saveRoyaltiesInfo: const OperationInfo(status: OperationStatus.success)));
        listRoyalties();
      },
    );
  }
}
