import 'package:user/utils/error.dart';
import 'order.model.dart';

class OrderState {
  final List<CartItemModel> cartItems;
  final CartAddress? activeAddress;
  final PaymentMethod? selectedPaymentMethod;
  final bool jioSaavnAdded;
  final bool goldApplied;
  final LadyluckSummaryModel ladyluckSummary;
  final String selectedLadyluckDiscountId;
  final OperationInfo ladyluckLoadInfo;
  final OperationInfo ladyluckScratchInfo;
  final OperationInfo placeOrderInfo;

  const OrderState({
    this.cartItems = const [],
    this.activeAddress,
    this.selectedPaymentMethod,
    this.jioSaavnAdded = false,
    this.goldApplied = false,
    this.ladyluckSummary = const LadyluckSummaryModel(
      account: LadyluckAccountModel(points_balance: 0, lifetime_points: 0),
      available_scratch_cards: [],
      active_discounts: [],
    ),
    this.selectedLadyluckDiscountId = '',
    this.ladyluckLoadInfo = const OperationInfo(status: OperationStatus.initial),
    this.ladyluckScratchInfo = const OperationInfo(status: OperationStatus.initial),
    this.placeOrderInfo = const OperationInfo(status: OperationStatus.initial),
  });

  OrderState copyWith({
    List<CartItemModel>? cartItems,
    CartAddress? activeAddress,
    PaymentMethod? selectedPaymentMethod,
    bool? jioSaavnAdded,
    bool? goldApplied,
    LadyluckSummaryModel? ladyluckSummary,
    String? selectedLadyluckDiscountId,
    OperationInfo? ladyluckLoadInfo,
    OperationInfo? ladyluckScratchInfo,
    OperationInfo? placeOrderInfo,
  }) {
    return OrderState(
      cartItems: cartItems ?? this.cartItems,
      activeAddress: activeAddress ?? this.activeAddress,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      jioSaavnAdded: jioSaavnAdded ?? this.jioSaavnAdded,
      goldApplied: goldApplied ?? this.goldApplied,
      ladyluckSummary: ladyluckSummary ?? this.ladyluckSummary,
      selectedLadyluckDiscountId: selectedLadyluckDiscountId ?? this.selectedLadyluckDiscountId,
      ladyluckLoadInfo: ladyluckLoadInfo ?? this.ladyluckLoadInfo,
      ladyluckScratchInfo: ladyluckScratchInfo ?? this.ladyluckScratchInfo,
      placeOrderInfo: placeOrderInfo ?? this.placeOrderInfo,
    );
  }
  double get calculateItemTotal {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
      for (var sub in item.subItems) {
        total += sub.price * sub.quantity;
      }
    }
    return total;
  }

  int get totalItems {
    int count = 0;
    for (var item in cartItems) {
      count += item.quantity;
    }
    return count;
  }

  double get taxesAndCharges {
    final double total = calculateItemTotal;
    if (total >= 300) {
      return 27.99;
    }
    return 33.04;
  }

  double get deliveryCharge {
    if (goldApplied) {
      return 0.0;
    }
    return 42.0;
  }

  double get grandTotal {
    return calculateItemTotal + deliveryCharge + taxesAndCharges - ladyluckDiscountAmount;
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
    if (discount == null || calculateItemTotal < discount.min_order_amount) {
      return 0.0;
    }
    final rawAmount = discount.discount_type == 'PERCENTAGE'
        ? calculateItemTotal * discount.discount_value / 100
        : discount.discount_value;
    final cappedAmount = discount.max_discount_amount > 0
        ? rawAmount.clamp(0.0, discount.max_discount_amount).toDouble()
        : rawAmount;
    return cappedAmount.clamp(0.0, calculateItemTotal).toDouble();
  }
}

