import 'package:user/utils/error.dart';
import 'order.model.dart';

class OrderState {
  final List<CartItemModel> cartItems;
  final CartAddress? activeAddress;
  final PaymentMethod? selectedPaymentMethod;
  final bool jioSaavnAdded;
  final bool goldApplied;
  final OperationInfo placeOrderInfo;

  const OrderState({
    this.cartItems = const [],
    this.activeAddress,
    this.selectedPaymentMethod,
    this.jioSaavnAdded = false,
    this.goldApplied = false,
    this.placeOrderInfo = const OperationInfo(status: OperationStatus.initial),
  });

  OrderState copyWith({
    List<CartItemModel>? cartItems,
    CartAddress? activeAddress,
    PaymentMethod? selectedPaymentMethod,
    bool? jioSaavnAdded,
    bool? goldApplied,
    OperationInfo? placeOrderInfo,
  }) {
    return OrderState(
      cartItems: cartItems ?? this.cartItems,
      activeAddress: activeAddress ?? this.activeAddress,
      selectedPaymentMethod: selectedPaymentMethod ?? this.selectedPaymentMethod,
      jioSaavnAdded: jioSaavnAdded ?? this.jioSaavnAdded,
      goldApplied: goldApplied ?? this.goldApplied,
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
    return calculateItemTotal + deliveryCharge + taxesAndCharges;
  }
}

