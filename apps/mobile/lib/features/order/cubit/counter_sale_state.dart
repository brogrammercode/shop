import 'package:mobile/features/order/models/cart_item_model.dart';
import 'package:mobile/features/order/models/receipt_model.dart';
import 'package:mobile/features/order/models/thermal_printer_model.dart';
import 'package:mobile/features/product/models/product_model.dart';
import 'package:mobile/utils/error.dart';

class CounterSaleState {
  final List<ProductModel> products;
  final List<CartItemModel> cartItems;
  final ReceiptModel? receipt;
  final List<ThermalPrinterModel> printers;
  final ThermalPrinterModel? selectedPrinter;
  final String search;
  final OperationInfo productInfo;
  final OperationInfo billInfo;
  final OperationInfo printerInfo;
  final OperationInfo printInfo;

  const CounterSaleState({
    this.products = const [],
    this.cartItems = const [],
    this.receipt,
    this.printers = const [],
    this.selectedPrinter,
    this.search = '',
    this.productInfo = const OperationInfo(status: OperationStatus.initial),
    this.billInfo = const OperationInfo(status: OperationStatus.initial),
    this.printerInfo = const OperationInfo(status: OperationStatus.initial),
    this.printInfo = const OperationInfo(status: OperationStatus.initial),
  });

  double get subtotal {
    return cartItems.fold(0, (total, item) => total + item.total);
  }

  CounterSaleState copyWith({
    List<ProductModel>? products,
    List<CartItemModel>? cartItems,
    ReceiptModel? receipt,
    bool clearReceipt = false,
    List<ThermalPrinterModel>? printers,
    ThermalPrinterModel? selectedPrinter,
    bool clearSelectedPrinter = false,
    String? search,
    OperationInfo? productInfo,
    OperationInfo? billInfo,
    OperationInfo? printerInfo,
    OperationInfo? printInfo,
  }) {
    return CounterSaleState(
      products: products ?? this.products,
      cartItems: cartItems ?? this.cartItems,
      receipt: clearReceipt ? null : receipt ?? this.receipt,
      printers: printers ?? this.printers,
      selectedPrinter: clearSelectedPrinter
          ? null
          : selectedPrinter ?? this.selectedPrinter,
      search: search ?? this.search,
      productInfo: productInfo ?? this.productInfo,
      billInfo: billInfo ?? this.billInfo,
      printerInfo: printerInfo ?? this.printerInfo,
      printInfo: printInfo ?? this.printInfo,
    );
  }
}
