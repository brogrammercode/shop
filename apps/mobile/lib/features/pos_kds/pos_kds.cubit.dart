import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/pos_kds/pos_kds.repo.dart';
import 'package:mobile/features/pos_kds/pos_kds.state.dart';

class PosKdsCubit extends Cubit<PosKdsState> {
  final PosKdsRepo _repo;

  PosKdsCubit({required PosKdsRepo repo})
      : _repo = repo,
        super(const PosKdsState());

  Future<void> listOrders() async {
    emit(state.copyWith(loadOrdersInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listOrders();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadOrdersInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (orders) {
        emit(state.copyWith(
          orders: orders,
          loadOrdersInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createOrder(Map<String, dynamic> data) async {
    emit(state.copyWith(saveOrdersInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createOrder(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveOrdersInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Order created');
        emit(state.copyWith(saveOrdersInfo: const OperationInfo(status: OperationStatus.success)));
        listOrders();
      },
    );
  }

  Future<void> getOrder(String id) async {
    emit(state.copyWith(loadOrdersInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getOrder(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadOrdersInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (order) {
        emit(state.copyWith(
          selectedOrder: order,
          loadOrdersInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> payOrder(String id, Map<String, dynamic> data) async {
    emit(state.copyWith(saveOrdersInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.payOrder(id, data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveOrdersInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Order paid');
        emit(state.copyWith(saveOrdersInfo: const OperationInfo(status: OperationStatus.success)));
        getOrder(id);
      },
    );
  }

  Future<void> cancelOrder(String id) async {
    emit(state.copyWith(saveOrdersInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.cancelOrder(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveOrdersInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Order cancelled');
        emit(state.copyWith(saveOrdersInfo: const OperationInfo(status: OperationStatus.success)));
        getOrder(id);
      },
    );
  }

  Future<void> listTables() async {
    emit(state.copyWith(loadTablesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listTables();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadTablesInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (tables) {
        emit(state.copyWith(
          tables: tables,
          loadTablesInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createTable(Map<String, dynamic> data) async {
    emit(state.copyWith(saveTablesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createTable(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveTablesInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Table created');
        emit(state.copyWith(saveTablesInfo: const OperationInfo(status: OperationStatus.success)));
        listTables();
      },
    );
  }

  Future<void> listKOTs() async {
    emit(state.copyWith(loadKotsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listKOTs();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadKotsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (kots) {
        emit(state.copyWith(
          kots: kots,
          loadKotsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> updateKOTStatus(String id, String status) async {
    emit(state.copyWith(saveKotsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.updateKOTStatus(id, status);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveKotsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'KOT status updated');
        emit(state.copyWith(saveKotsInfo: const OperationInfo(status: OperationStatus.success)));
        listKOTs();
      },
    );
  }

  Future<void> listPayments() async {
    emit(state.copyWith(loadPaymentsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listPayments();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadPaymentsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (payments) {
        emit(state.copyWith(
          payments: payments,
          loadPaymentsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }
}
