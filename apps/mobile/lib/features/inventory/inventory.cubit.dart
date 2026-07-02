import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/inventory/inventory.repo.dart';
import 'package:mobile/features/inventory/inventory.state.dart';

class InventoryCubit extends Cubit<InventoryState> {
  final InventoryRepo _repo;

  InventoryCubit({required InventoryRepo repo})
      : _repo = repo,
        super(const InventoryState());

  Future<void> listSuppliers() async {
    emit(state.copyWith(loadSuppliersInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listSuppliers();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadSuppliersInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (suppliers) {
        emit(state.copyWith(
          suppliers: suppliers,
          loadSuppliersInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createSupplier(Map<String, dynamic> data) async {
    emit(state.copyWith(saveSuppliersInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createSupplier(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveSuppliersInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Supplier created');
        emit(state.copyWith(saveSuppliersInfo: const OperationInfo(status: OperationStatus.success)));
        listSuppliers();
      },
    );
  }

  Future<void> listItems() async {
    emit(state.copyWith(loadItemsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listItems();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadItemsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (items) {
        emit(state.copyWith(
          items: items,
          loadItemsInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createItem(Map<String, dynamic> data) async {
    emit(state.copyWith(saveItemsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createItem(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(saveItemsInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Item created');
        emit(state.copyWith(saveItemsInfo: const OperationInfo(status: OperationStatus.success)));
        listItems();
      },
    );
  }

  Future<void> listPurchaseOrders() async {
    emit(state.copyWith(loadPOInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listPurchaseOrders();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadPOInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (pos) {
        emit(state.copyWith(
          purchaseOrders: pos,
          loadPOInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createPurchaseOrder(Map<String, dynamic> data) async {
    emit(state.copyWith(savePOInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createPurchaseOrder(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(savePOInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Purchase order created');
        emit(state.copyWith(savePOInfo: const OperationInfo(status: OperationStatus.success)));
        listPurchaseOrders();
      },
    );
  }

  Future<void> getPurchaseOrder(String id) async {
    emit(state.copyWith(loadPOInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getPurchaseOrder(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadPOInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (po) {
        emit(state.copyWith(
          selectedPO: po,
          loadPOInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> sendPurchaseOrder(String id) async {
    emit(state.copyWith(savePOInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.sendPurchaseOrder(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(savePOInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Purchase order sent');
        emit(state.copyWith(savePOInfo: const OperationInfo(status: OperationStatus.success)));
        getPurchaseOrder(id);
      },
    );
  }

  Future<void> receivePurchaseOrder(String id, Map<String, dynamic> data) async {
    emit(state.copyWith(receiveInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.receivePurchaseOrder(id, data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(receiveInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Purchase order received');
        emit(state.copyWith(receiveInfo: const OperationInfo(status: OperationStatus.success)));
        getPurchaseOrder(id);
      },
    );
  }

  Future<void> getStockLevels() async {
    emit(state.copyWith(stockInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getStockLevels();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(stockInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (levels) {
        emit(state.copyWith(
          stockLevels: levels,
          stockInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> getStockLedger() async {
    emit(state.copyWith(stockInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.getStockLedger();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(stockInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (ledger) {
        emit(state.copyWith(
          stockLedger: ledger,
          stockInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> logUsage(Map<String, dynamic> data) async {
    emit(state.copyWith(usageInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.logUsage(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(usageInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Usage logged');
        emit(state.copyWith(usageInfo: const OperationInfo(status: OperationStatus.success)));
        getStockLevels();
      },
    );
  }

  Future<void> logWastage(Map<String, dynamic> data) async {
    emit(state.copyWith(wastageInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.logWastage(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(wastageInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Wastage logged');
        emit(state.copyWith(wastageInfo: const OperationInfo(status: OperationStatus.success)));
        getStockLevels();
      },
    );
  }

  Future<void> listStockTransfers() async {
    emit(state.copyWith(loadTransferInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.listStockTransfers();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(loadTransferInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (transfers) {
        emit(state.copyWith(
          stockTransfers: transfers,
          loadTransferInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createStockTransfer(Map<String, dynamic> data) async {
    emit(state.copyWith(transferInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.createStockTransfer(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(transferInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Stock transfer created');
        emit(state.copyWith(transferInfo: const OperationInfo(status: OperationStatus.success)));
        listStockTransfers();
      },
    );
  }

  Future<void> receiveStockTransfer(String id) async {
    emit(state.copyWith(transferInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _repo.receiveStockTransfer(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(state.copyWith(transferInfo: OperationInfo(status: OperationStatus.error, error: failure)));
      },
      (_) {
        Fluttertoast.showToast(msg: 'Transfer received');
        emit(state.copyWith(transferInfo: const OperationInfo(status: OperationStatus.success)));
        listStockTransfers();
      },
    );
  }
}
