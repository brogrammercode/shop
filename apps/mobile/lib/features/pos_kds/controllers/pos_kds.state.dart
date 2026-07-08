import 'package:mobile/utils/error.dart';
import 'package:mobile/features/core_hr/models/user.model.dart';
import 'package:mobile/features/pos_kds/models/order.model.dart';
import 'package:mobile/features/pos_kds/models/table.model.dart';
import 'package:mobile/features/pos_kds/models/kitchen_order_ticket.model.dart';
import 'package:mobile/features/pos_kds/models/advance_payment.model.dart';
import 'package:mobile/features/pos_kds/models/table_zone.model.dart';

class PosKdsState {
  final List<OrderModel> orders;
  final OrderModel? selectedOrder;
  final List<TableModel> tables;
  final List<TableZoneModel> tableZones;
  final List<KitchenOrderTicketModel> kots;
  final List<AdvancePaymentModel> payments;
  final List<UserModel> matchingCustomers;
  final UserModel? selectedCustomer;
  final List<String> printLogs;

  final Map<String, int> cart;

  final OperationInfo loadOrdersInfo;
  final OperationInfo saveOrdersInfo;
  final OperationInfo loadTablesInfo;
  final OperationInfo saveTablesInfo;
  final OperationInfo loadTableZonesInfo;
  final OperationInfo saveTableZonesInfo;
  final OperationInfo loadKotsInfo;
  final OperationInfo saveKotsInfo;
  final OperationInfo loadPaymentsInfo;
  final OperationInfo searchCustomersInfo;
  final OperationInfo printReceiptInfo;
  final OrderModel? lastPlacedOrder;

  const PosKdsState({
    this.orders = const [],
    this.selectedOrder,
    this.tables = const [],
    this.tableZones = const [],
    this.kots = const [],
    this.payments = const [],
    this.matchingCustomers = const [],
    this.selectedCustomer,
    this.printLogs = const [],
    this.cart = const {},
    this.loadOrdersInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveOrdersInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadTablesInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveTablesInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadTableZonesInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.saveTableZonesInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.loadKotsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveKotsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadPaymentsInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.searchCustomersInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.printReceiptInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.lastPlacedOrder,
  });

  PosKdsState copyWith({
    List<OrderModel>? orders,
    OrderModel? selectedOrder,
    List<TableModel>? tables,
    List<TableZoneModel>? tableZones,
    List<KitchenOrderTicketModel>? kots,
    List<AdvancePaymentModel>? payments,
    List<UserModel>? matchingCustomers,
    UserModel? selectedCustomer,
    List<String>? printLogs,
    bool clearSelectedCustomer = false,
    Map<String, int>? cart,
    OperationInfo? loadOrdersInfo,
    OperationInfo? saveOrdersInfo,
    OperationInfo? loadTablesInfo,
    OperationInfo? saveTablesInfo,
    OperationInfo? loadTableZonesInfo,
    OperationInfo? saveTableZonesInfo,
    OperationInfo? loadKotsInfo,
    OperationInfo? saveKotsInfo,
    OperationInfo? loadPaymentsInfo,
    OperationInfo? searchCustomersInfo,
    OperationInfo? printReceiptInfo,
    OrderModel? lastPlacedOrder,
    bool clearLastPlacedOrder = false,
  }) {
    return PosKdsState(
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      tables: tables ?? this.tables,
      tableZones: tableZones ?? this.tableZones,
      kots: kots ?? this.kots,
      payments: payments ?? this.payments,
      matchingCustomers: matchingCustomers ?? this.matchingCustomers,
      selectedCustomer: clearSelectedCustomer
          ? null
          : selectedCustomer ?? this.selectedCustomer,
      printLogs: printLogs ?? this.printLogs,
      cart: cart ?? this.cart,
      loadOrdersInfo: loadOrdersInfo ?? this.loadOrdersInfo,
      saveOrdersInfo: saveOrdersInfo ?? this.saveOrdersInfo,
      loadTablesInfo: loadTablesInfo ?? this.loadTablesInfo,
      saveTablesInfo: saveTablesInfo ?? this.saveTablesInfo,
      loadTableZonesInfo: loadTableZonesInfo ?? this.loadTableZonesInfo,
      saveTableZonesInfo: saveTableZonesInfo ?? this.saveTableZonesInfo,
      loadKotsInfo: loadKotsInfo ?? this.loadKotsInfo,
      saveKotsInfo: saveKotsInfo ?? this.saveKotsInfo,
      loadPaymentsInfo: loadPaymentsInfo ?? this.loadPaymentsInfo,
      searchCustomersInfo: searchCustomersInfo ?? this.searchCustomersInfo,
      printReceiptInfo: printReceiptInfo ?? this.printReceiptInfo,
      lastPlacedOrder: clearLastPlacedOrder
          ? null
          : lastPlacedOrder ?? this.lastPlacedOrder,
    );
  }
}
