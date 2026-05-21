import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/product/cubit/product_state.dart';
import 'package:mobile/features/product/models/product_input_model.dart';
import 'package:mobile/features/product/models/product_model.dart';
import 'package:mobile/features/product/repo/product_repo.dart';
import 'package:mobile/utils/error.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo _productRepo;

  ProductCubit({required ProductRepo productRepo})
    : _productRepo = productRepo,
      super(const ProductState());

  Future<void> getList(String branch_id, {String search = ''}) async {
    emit(
      state.copyWith(
        search: search,
        listInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _productRepo.getList(
      branch_id: branch_id,
      search: search,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          listInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (products) => emit(
        state.copyWith(
          products: products,
          listInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }

  void selectProduct(ProductModel? product) {
    emit(
      state.copyWith(
        selectedProduct: product,
        clearSelectedProduct: product == null,
      ),
    );
  }

  Future<void> save(ProductInputModel input, {String? id}) async {
    emit(
      state.copyWith(
        saveInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = id == null || id.isEmpty
        ? await _productRepo.create(input)
        : await _productRepo.update(id, input);

    result.fold(
      (failure) => emit(
        state.copyWith(
          saveInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (product) {
        final products = [
          product,
          ...state.products.where((item) => item.id != product.id),
        ]..sort((first, second) => first.name.compareTo(second.name));
        emit(
          state.copyWith(
            products: products,
            selectedProduct: product,
            saveInfo: const OperationInfo(status: OperationStatus.success),
          ),
        );
      },
    );
  }

  Future<void> delete(String id) async {
    emit(
      state.copyWith(
        deleteInfo: const OperationInfo(status: OperationStatus.loading),
      ),
    );

    final result = await _productRepo.delete(id);

    result.fold(
      (failure) => emit(
        state.copyWith(
          deleteInfo: OperationInfo(
            status: OperationStatus.error,
            error: failure,
          ),
        ),
      ),
      (_) => emit(
        state.copyWith(
          products: state.products
              .where((product) => product.id != id)
              .toList(),
          clearSelectedProduct: true,
          deleteInfo: const OperationInfo(status: OperationStatus.success),
        ),
      ),
    );
  }
}
