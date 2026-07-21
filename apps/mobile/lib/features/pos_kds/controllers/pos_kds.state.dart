import 'package:mobile/utils/error.dart';
import 'package:mobile/features/core_hr/models/user.model.dart';
import 'package:mobile/features/pos_kds/models/order.model.dart';
import 'package:mobile/features/pos_kds/models/table.model.dart';
import 'package:mobile/features/pos_kds/models/kitchen_order_ticket.model.dart';
import 'package:mobile/features/pos_kds/models/advance_payment.model.dart';
import 'package:mobile/features/pos_kds/models/table_zone.model.dart';
import 'package:mobile/features/pos_kds/models/pos_cart_line.model.dart';
import 'package:mobile/features/pos_kds/models/ladyluck.model.dart';

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
  final LadyluckSummaryModel ladyluckSummary;
  final String selectedLadyluckDiscountId;

  final Map<String, PosCartLineModel> cart;

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
  final OperationInfo loadLadyluckInfo;
  final OperationInfo scratchLadyluckInfo;
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
    this.ladyluckSummary = const LadyluckSummaryModel(
      account: LadyluckAccountModel(points_balance: 0, lifetime_points: 0),
      available_scratch_cards: [],
      active_discounts: [],
    ),
    this.selectedLadyluckDiscountId = '',
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
    this.loadLadyluckInfo = const OperationInfo(
      status: OperationStatus.initial,
    ),
    this.scratchLadyluckInfo = const OperationInfo(
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
    LadyluckSummaryModel? ladyluckSummary,
    String? selectedLadyluckDiscountId,
    bool clearSelectedCustomer = false,
    bool clearLadyluck = false,
    Map<String, PosCartLineModel>? cart,
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
    OperationInfo? loadLadyluckInfo,
    OperationInfo? scratchLadyluckInfo,
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
      ladyluckSummary: clearLadyluck
          ? LadyluckSummaryModel.empty()
          : ladyluckSummary ?? this.ladyluckSummary,
      selectedLadyluckDiscountId: clearLadyluck
          ? ''
          : selectedLadyluckDiscountId ?? this.selectedLadyluckDiscountId,
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
      loadLadyluckInfo: loadLadyluckInfo ?? this.loadLadyluckInfo,
      scratchLadyluckInfo: scratchLadyluckInfo ?? this.scratchLadyluckInfo,
      printReceiptInfo: printReceiptInfo ?? this.printReceiptInfo,
      lastPlacedOrder: clearLastPlacedOrder
          ? null
          : lastPlacedOrder ?? this.lastPlacedOrder,
    );
  }

  double get cartSubtotal {
    return cart.values.fold(0.0, (total, line) => total + line.total);
  }

  LadyluckDiscountModel? get activeLadyluckDiscount {
    if (ladyluckSummary.active_discounts.isEmpty) {
      return null;
    }
    return ladyluckSummary.active_discounts.firstWhere(
      (discount) => discount.id == selectedLadyluckDiscountId,
      orElse: () => ladyluckSummary.active_discounts.first,
    );
  }

  double get ladyluckDiscountAmount {
    final discount = activeLadyluckDiscount;
    if (discount == null || cartSubtotal < discount.min_order_amount) {
      return 0.0;
    }
    final rawAmount = discount.discount_type == 'PERCENTAGE'
        ? cartSubtotal * discount.discount_value / 100
        : discount.discount_value;
    final cappedAmount = discount.max_discount_amount > 0
        ? rawAmount.clamp(0.0, discount.max_discount_amount).toDouble()
        : rawAmount;
    return cappedAmount.clamp(0.0, cartSubtotal).toDouble();
  }

  double get cartPayable {
    return (cartSubtotal - ladyluckDiscountAmount).clamp(0.0, cartSubtotal).toDouble();
  }
}
