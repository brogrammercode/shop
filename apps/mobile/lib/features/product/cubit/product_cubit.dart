import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/error.dart';
import '../repo/product_repo.dart';
import 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepo _productRepo;

  ProductCubit({required ProductRepo productRepo})
      : _productRepo = productRepo,
        super(const ProductState());

  Future<void> loadCategories(String branchId) async {
    emit(state.copyWith(loadCategoriesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.getCategories(branchId);
    result.fold(
      (failure) => emit(state.copyWith(
        loadCategoriesInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (categories) => emit(state.copyWith(
        categories: categories,
        loadCategoriesInfo: const OperationInfo(status: OperationStatus.success),
      )),
    );
  }

  Future<void> loadSubCategories(String categoryId) async {
    emit(state.copyWith(loadSubCategoriesInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.getSubCategories(categoryId);
    result.fold(
      (failure) => emit(state.copyWith(
        loadSubCategoriesInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (subCategories) => emit(state.copyWith(
        subCategories: subCategories,
        loadSubCategoriesInfo: const OperationInfo(status: OperationStatus.success),
      )),
    );
  }

  Future<void> loadProducts(String branchId) async {
    emit(state.copyWith(loadProductsInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.getProducts(branchId);
    result.fold(
      (failure) => emit(state.copyWith(
        loadProductsInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (products) => emit(state.copyWith(
        products: products,
        loadProductsInfo: const OperationInfo(status: OperationStatus.success),
      )),
    );
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    emit(state.copyWith(saveInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.createCategory(data);
    result.fold(
      (failure) => emit(state.copyWith(
        saveInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (category) {
        final newCategories = List.of(state.categories)..add(category);
        emit(state.copyWith(
          categories: newCategories,
          saveInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    emit(state.copyWith(saveInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.updateCategory(id, data);
    result.fold(
      (failure) => emit(state.copyWith(
        saveInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (category) {
        final newCategories = state.categories.map((c) => c.id == id ? category : c).toList();
        emit(state.copyWith(
          categories: newCategories,
          saveInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> deleteCategory(String id) async {
    emit(state.copyWith(deleteInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.deleteCategory(id);
    result.fold(
      (failure) => emit(state.copyWith(
        deleteInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (_) {
        final newCategories = state.categories.where((c) => c.id != id).toList();
        emit(state.copyWith(
          categories: newCategories,
          deleteInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createSubCategory(Map<String, dynamic> data) async {
    emit(state.copyWith(saveInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.createSubCategory(data);
    result.fold(
      (failure) => emit(state.copyWith(
        saveInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (subCategory) {
        final newSubCategories = List.of(state.subCategories)..add(subCategory);
        emit(state.copyWith(
          subCategories: newSubCategories,
          saveInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> updateSubCategory(String id, Map<String, dynamic> data) async {
    emit(state.copyWith(saveInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.updateSubCategory(id, data);
    result.fold(
      (failure) => emit(state.copyWith(
        saveInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (subCategory) {
        final newSubCategories = state.subCategories.map((c) => c.id == id ? subCategory : c).toList();
        emit(state.copyWith(
          subCategories: newSubCategories,
          saveInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> deleteSubCategory(String id) async {
    emit(state.copyWith(deleteInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.deleteSubCategory(id);
    result.fold(
      (failure) => emit(state.copyWith(
        deleteInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (_) {
        final newSubCategories = state.subCategories.where((c) => c.id != id).toList();
        emit(state.copyWith(
          subCategories: newSubCategories,
          deleteInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> createProduct(Map<String, dynamic> data) async {
    emit(state.copyWith(saveInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.createProduct(data);
    result.fold(
      (failure) => emit(state.copyWith(
        saveInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (product) {
        final newProducts = List.of(state.products)..add(product);
        emit(state.copyWith(
          products: newProducts,
          saveInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    emit(state.copyWith(saveInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.updateProduct(id, data);
    result.fold(
      (failure) => emit(state.copyWith(
        saveInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (product) {
        final newProducts = state.products.map((p) => p.id == id ? product : p).toList();
        emit(state.copyWith(
          products: newProducts,
          saveInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    emit(state.copyWith(deleteInfo: const OperationInfo(status: OperationStatus.loading)));
    final result = await _productRepo.deleteProduct(id);
    result.fold(
      (failure) => emit(state.copyWith(
        deleteInfo: OperationInfo(status: OperationStatus.error, error: failure),
      )),
      (_) {
        final newProducts = state.products.where((p) => p.id != id).toList();
        emit(state.copyWith(
          products: newProducts,
          deleteInfo: const OperationInfo(status: OperationStatus.success),
        ));
      },
    );
  }
}
