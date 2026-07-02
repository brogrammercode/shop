import 'package:mobile/utils/error.dart';
import 'package:mobile/features/pos_kds/order.model.dart';
import 'package:mobile/features/pos_kds/table.model.dart';
import 'package:mobile/features/pos_kds/kitchen_order_ticket.model.dart';
import 'package:mobile/features/pos_kds/advance_payment.model.dart';

class PosKdsState {
  final List<OrderModel> orders;
  final OrderModel? selectedOrder;
  final List<TableModel> tables;
  final List<KitchenOrderTicketModel> kots;
  final List<AdvancePaymentModel> payments;

  final OperationInfo loadOrdersInfo;
  final OperationInfo saveOrdersInfo;
  final OperationInfo loadTablesInfo;
  final OperationInfo saveTablesInfo;
  final OperationInfo loadKotsInfo;
  final OperationInfo saveKotsInfo;
  final OperationInfo loadPaymentsInfo;

  const PosKdsState({
    this.orders = const [],
    this.selectedOrder,
    this.tables = const [],
    this.kots = const [],
    this.payments = const [],
    this.loadOrdersInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveOrdersInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadTablesInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveTablesInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadKotsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveKotsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadPaymentsInfo = const OperationInfo(status: OperationStatus.initial),
  });

  PosKdsState copyWith({
    List<OrderModel>? orders,
    OrderModel? selectedOrder,
    List<TableModel>? tables,
    List<KitchenOrderTicketModel>? kots,
    List<AdvancePaymentModel>? payments,
    OperationInfo? loadOrdersInfo,
    OperationInfo? saveOrdersInfo,
    OperationInfo? loadTablesInfo,
    OperationInfo? saveTablesInfo,
    OperationInfo? loadKotsInfo,
    OperationInfo? saveKotsInfo,
    OperationInfo? loadPaymentsInfo,
  }) {
    return PosKdsState(
      orders: orders ?? this.orders,
      selectedOrder: selectedOrder ?? this.selectedOrder,
      tables: tables ?? this.tables,
      kots: kots ?? this.kots,
      payments: payments ?? this.payments,
      loadOrdersInfo: loadOrdersInfo ?? this.loadOrdersInfo,
      saveOrdersInfo: saveOrdersInfo ?? this.saveOrdersInfo,
      loadTablesInfo: loadTablesInfo ?? this.loadTablesInfo,
      saveTablesInfo: saveTablesInfo ?? this.saveTablesInfo,
      loadKotsInfo: loadKotsInfo ?? this.loadKotsInfo,
      saveKotsInfo: saveKotsInfo ?? this.saveKotsInfo,
      loadPaymentsInfo: loadPaymentsInfo ?? this.loadPaymentsInfo,
    );
  }
}
