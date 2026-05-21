import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/order/cubit/counter_sale_state.dart';
import 'package:mobile/features/order/models/cart_item_model.dart';
import 'package:mobile/features/order/models/thermal_printer_model.dart';
import 'package:mobile/features/order/repo/order_repo.dart';
import 'package:mobile/features/product/models/product_model.dart';
import 'package:mobile/features/product/repo/product_repo.dart';
import 'package:mobile/services/thermal_printer_service.dart';
import 'package:mobile/utils/error.dart';

class CounterSaleCubit extends Cubit<CounterSaleState> {
  final ProductRepo _productRepo;
  final OrderRepo _orderRepo;
  final ThermalPrinterService _thermalPrinterService;

  CounterSaleCubit({
    required ProductRepo productRepo,
    required OrderRepo orderRepo,
    required ThermalPrinterService thermalPrinterService,
  }) : _productRepo = productRepo,
       _orderRepo = orderRepo,
       _thermalPrinterService = thermalPrinterService,
       super(const CounterSaleState());

  Future<void> loadProducts(String branch_id, {String search = ''}) async {
    emit(
      state.copyWith(
        search: search,
        productInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _productRepo.getList(
      branch_id: branch_id,
      search: search,
      available: true,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          productInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (products) => emit(
        state.copyWith(
          products: products,
          productInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  void addProduct(ProductModel product) {
    final existing = state.cartItems.where(
      (item) => item.product.id == product.id,
    );
    if (existing.isNotEmpty) {
      updateQuantity(product.id, existing.first.quantity + 1);
      return;
    }

    emit(
      state.copyWith(
        cartItems: [
          ...state.cartItems,
          CartItemModel(product: product, quantity: 1),
        ],
        clearReceipt: true,
      ),
    );
  }

  void updateQuantity(String product_id, int quantity) {
    if (quantity <= 0) {
      removeProduct(product_id);
      return;
    }

    final cartItems = state.cartItems.map((item) {
      if (item.product.id != product_id) {
        return item;
      }

      final safeQuantity = quantity > item.product.stock
          ? item.product.stock
          : quantity;
      return item.copyWith(quantity: safeQuantity);
    }).toList();

    emit(state.copyWith(cartItems: cartItems, clearReceipt: true));
  }

  void removeProduct(String product_id) {
    emit(
      state.copyWith(
        cartItems: state.cartItems
            .where((item) => item.product.id != product_id)
            .toList(),
        clearReceipt: true,
      ),
    );
  }

  Future<void> createBill(String branch_id) async {
    emit(
      state.copyWith(
        billInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _orderRepo.createCounterOrder(
      branch_id: branch_id,
      items: state.cartItems,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          billInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (receipt) => emit(
        state.copyWith(
          receipt: receipt,
          cartItems: const [],
          billInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  Future<void> loadPrinters() async {
    emit(
      state.copyWith(
        printerInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    try {
      final printers = await _thermalPrinterService.getPairedPrinters();
      emit(
        state.copyWith(
          printers: printers,
          selectedPrinter: printers.isEmpty ? null : printers.first,
          clearSelectedPrinter: printers.isEmpty,
          printerInfo: const OperationInfo(status: OperationStatus.success),
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          printerInfo: OperationInfo(
            status: OperationStatus.error,
            error: ServerFailure(error.message, statusCode: error.statusCode),
          ),
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          printerInfo: OperationInfo(
            status: OperationStatus.error,
            error: AuthFailure(error.message, statusCode: error.statusCode),
          ),
        ),
      );
    } on NetworkException catch (error) {
      emit(
        state.copyWith(
          printerInfo: OperationInfo(
            status: OperationStatus.error,
            error: NetworkFailure(error.message),
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          printerInfo: OperationInfo(
            status: OperationStatus.error,
            error: ServerFailure(error.toString()),
          ),
        ),
      );
    }
  }

  void selectPrinter(ThermalPrinterModel printer) {
    emit(state.copyWith(selectedPrinter: printer));
  }

  Future<void> printReceipt() async {
    final printer = state.selectedPrinter;
    final receipt = state.receipt;
    if (printer == null || receipt == null) {
      return;
    }

    emit(
      state.copyWith(
        printInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    try {
      await _thermalPrinterService.printDualReceipt(
        printer: printer,
        receipt: receipt,
      );
      emit(
        state.copyWith(
          printInfo: const OperationInfo(status: OperationStatus.success),
        ),
      );
    } on ServerException catch (error) {
      emit(
        state.copyWith(
          printInfo: OperationInfo(
            status: OperationStatus.error,
            error: ServerFailure(error.message, statusCode: error.statusCode),
          ),
        ),
      );
    } on AuthException catch (error) {
      emit(
        state.copyWith(
          printInfo: OperationInfo(
            status: OperationStatus.error,
            error: AuthFailure(error.message, statusCode: error.statusCode),
          ),
        ),
      );
    } on NetworkException catch (error) {
      emit(
        state.copyWith(
          printInfo: OperationInfo(
            status: OperationStatus.error,
            error: NetworkFailure(error.message),
          ),
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          printInfo: OperationInfo(
            status: OperationStatus.error,
            error: ServerFailure(error.toString()),
          ),
        ),
      );
    }
  }
}
