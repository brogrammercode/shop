import '../../../utils/error.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/product_sub_category.dart';

class ProductState {
  final List<ProductModel> products;
  final List<ProductCategoryModel> categories;
  final List<ProductSubCategoryModel> subCategories;
  
  final OperationInfo loadProductsInfo;
  final OperationInfo loadCategoriesInfo;
  final OperationInfo loadSubCategoriesInfo;
  final OperationInfo saveInfo;
  final OperationInfo deleteInfo;

  const ProductState({
    this.products = const [],
    this.categories = const [],
    this.subCategories = const [],
    this.loadProductsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadCategoriesInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadSubCategoriesInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveInfo = const OperationInfo(status: OperationStatus.initial),
    this.deleteInfo = const OperationInfo(status: OperationStatus.initial),
  });

  ProductState copyWith({
    List<ProductModel>? products,
    List<ProductCategoryModel>? categories,
    List<ProductSubCategoryModel>? subCategories,
    OperationInfo? loadProductsInfo,
    OperationInfo? loadCategoriesInfo,
    OperationInfo? loadSubCategoriesInfo,
    OperationInfo? saveInfo,
    OperationInfo? deleteInfo,
  }) {
    return ProductState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      loadProductsInfo: loadProductsInfo ?? this.loadProductsInfo,
      loadCategoriesInfo: loadCategoriesInfo ?? this.loadCategoriesInfo,
      loadSubCategoriesInfo: loadSubCategoriesInfo ?? this.loadSubCategoriesInfo,
      saveInfo: saveInfo ?? this.saveInfo,
      deleteInfo: deleteInfo ?? this.deleteInfo,
    );
  }
}
