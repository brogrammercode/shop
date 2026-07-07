import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/features/core_hr/models/user.model.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.repo.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.state.dart';

class PosKdsCubit extends Cubit<PosKdsState> {
  final PosKdsRepo _repo;

  PosKdsCubit({required PosKdsRepo repo})
    : _repo = repo,
      super(const PosKdsState());

  void addToCart(String menuItemId) {
    final currentCart = Map<String, int>.from(state.cart);
    currentCart[menuItemId] = (currentCart[menuItemId] ?? 0) + 1;
    emit(state.copyWith(cart: currentCart));
  }

  void removeFromCart(String menuItemId) {
    final currentCart = Map<String, int>.from(state.cart);
    if (currentCart.containsKey(menuItemId)) {
      if (currentCart[menuItemId]! > 1) {
        currentCart[menuItemId] = currentCart[menuItemId]! - 1;
      } else {
        currentCart.remove(menuItemId);
      }
      emit(state.copyWith(cart: currentCart));
    }
  }

  void setCartQuantity(String menuItemId, int quantity) {
    final currentCart = Map<String, int>.from(state.cart);
    if (quantity > 0) {
      currentCart[menuItemId] = quantity;
    } else {
      currentCart.remove(menuItemId);
    }
    emit(state.copyWith(cart: currentCart));
  }

  void clearCart() {
    emit(state.copyWith(cart: {}));
  }

  Future<void> placeOrderFromCart(
    double totalAmount,
    List<Map<String, dynamic>> items,
    String orderType,
    String? tableId,
    String? customerId, {
    String? deliveryAddressId,
    double? finalPayingPrice,
    List<String>? tableSideIds,
    String? notes,
  }) async {
    if (items.isEmpty) return;

    final payload = <String, dynamic>{
      'order_type': orderType,
      'table_id': tableId,
      'table_side_ids': tableSideIds,
      'uid': customerId,
      'delivery_address_id': deliveryAddressId,
      'status': 'PLACED',
      'total_amount': totalAmount,
      'items': items,
      if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
    };
    if (finalPayingPrice != null) {
      payload['final_paying_price'] = finalPayingPrice;
    }

    await createOrder(payload);
    if (state.saveOrdersInfo.status == OperationStatus.success) {
      clearCart();
    }
  }

  Future<void> searchCustomersByPhone(String phone) async {
    final query = phone.trim();
    if (query.isEmpty) {
      emit(
        state.copyWith(
          matchingCustomers: const [],
          searchCustomersInfo: const OperationInfo(
            status: OperationStatus.initial,
          ),
          clearSelectedCustomer: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        searchCustomersInfo: const OperationInfo(
          status: OperationStatus.loading,
        ),
        clearSelectedCustomer: true,
      ),
    );

    final result = await _repo.searchCustomersByPhone(query);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            matchingCustomers: const [],
            searchCustomersInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
            clearSelectedCustomer: true,
          ),
        );
      },
      (customers) {
        emit(
          state.copyWith(
            matchingCustomers: customers,
            searchCustomersInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  void selectCustomer(UserModel customer) {
    emit(
      state.copyWith(selectedCustomer: customer, matchingCustomers: const []),
    );
  }

  Future<void> listOrders() async {
    emit(
      state.copyWith(
        loadOrdersInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listOrders();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            loadOrdersInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (orders) {
        emit(
          state.copyWith(
            orders: orders,
            loadOrdersInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  Future<void> createOrder(Map<String, dynamic> data) async {
    emit(
      state.copyWith(
        saveOrdersInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createOrder(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveOrdersInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (order) {
        Fluttertoast.showToast(msg: 'Order created');
        emit(
          state.copyWith(
            lastPlacedOrder: order,
            selectedOrder: order,
            saveOrdersInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
        listOrders();
      },
    );
  }

  Future<void> getOrder(String id) async {
    emit(
      state.copyWith(
        loadOrdersInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.getOrder(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            loadOrdersInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (order) {
        emit(
          state.copyWith(
            selectedOrder: order,
            loadOrdersInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  Future<void> payOrder(String id, Map<String, dynamic> data) async {
    emit(
      state.copyWith(
        saveOrdersInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.payOrder(id, data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveOrdersInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Order paid');
        emit(
          state.copyWith(
            saveOrdersInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
        getOrder(id);
      },
    );
  }

  Future<void> cancelOrder(String id) async {
    emit(
      state.copyWith(
        saveOrdersInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.cancelOrder(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveOrdersInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Order cancelled');
        emit(
          state.copyWith(
            saveOrdersInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
        getOrder(id);
      },
    );
  }

  Future<void> deleteOrder(String id) async {
    emit(
      state.copyWith(
        saveOrdersInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.deleteOrder(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveOrdersInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Order deleted');
        emit(
          state.copyWith(
            saveOrdersInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
        listOrders();
      },
    );
  }

  Future<void> listTables() async {
    emit(
      state.copyWith(
        loadTablesInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listTables();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            loadTablesInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (tables) {
        emit(
          state.copyWith(
            tables: tables,
            loadTablesInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  Future<void> createTable(Map<String, dynamic> data) async {
    emit(
      state.copyWith(
        saveTablesInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createTable(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveTablesInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Table created');
        emit(
          state.copyWith(
            saveTablesInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  Future<void> updateTable(String id, Map<String, dynamic> data) async {
    emit(
      state.copyWith(
        saveTablesInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.updateTable(id, data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveTablesInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Table updated');
        emit(
          state.copyWith(
            saveTablesInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
        listTables();
      },
    );
  }

  Future<void> listTableZones() async {
    emit(
      state.copyWith(
        loadTablesInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listTableZones();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            loadTablesInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (zones) {
        emit(
          state.copyWith(
            tableZones: zones,
            loadTablesInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }

  Future<void> createTableZone(Map<String, dynamic> data) async {
    emit(
      state.copyWith(
        saveTablesInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.createTableZone(data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveTablesInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Table zone created');
        emit(
          state.copyWith(
            saveTablesInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
        listTableZones();
      },
    );
  }

  Future<void> updateTableZone(String id, Map<String, dynamic> data) async {
    emit(
      state.copyWith(
        saveTablesInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.updateTableZone(id, data);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveTablesInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Table zone updated');
        emit(
          state.copyWith(
            saveTablesInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
        listTableZones();
      },
    );
  }

  Future<void> deleteTableZone(String id) async {
    emit(
      state.copyWith(
        saveTablesInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.deleteTableZone(id);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveTablesInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'Table zone deleted');
        emit(
          state.copyWith(
            saveTablesInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
        listTableZones();
      },
    );
  }

  Future<void> listKOTs() async {
    emit(
      state.copyWith(
        loadKotsInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listKOTs();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            loadKotsInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (kots) {
        emit(
          state.copyWith(
            kots: kots,
            loadKotsInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> updateKOTStatus(String id, String status) async {
    emit(
      state.copyWith(
        saveKotsInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.updateKOTStatus(id, status);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            saveKotsInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (_) {
        Fluttertoast.showToast(msg: 'KOT status updated');
        emit(
          state.copyWith(
            saveKotsInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
        listKOTs();
      },
    );
  }

  Future<void> updateOrderStatus(String id, String status) async {
    final result = await _repo.updateOrderStatus(id, status);
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
      },
      (_) {
        Fluttertoast.showToast(msg: 'Order marked as $status');
        listOrders();
      },
    );
  }

  Future<void> listPayments() async {
    emit(
      state.copyWith(
        loadPaymentsInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );
    final result = await _repo.listPayments();
    result.fold(
      (failure) {
        Fluttertoast.showToast(msg: failure.message);
        emit(
          state.copyWith(
            loadPaymentsInfo: OperationInfo(
              status: OperationStatus.error,
              error: failure,
            ),
          ),
        );
      },
      (payments) {
        emit(
          state.copyWith(
            payments: payments,
            loadPaymentsInfo: const OperationInfo(
              status: OperationStatus.success,
            ),
          ),
        );
      },
    );
  }
}
