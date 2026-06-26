import '../../../utils/error.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/product_sub_category.dart';

class ProductState {
  final List<ProductModel> products;
  final List<ProductCategoryModel> categories;
  final List<ProductSubCategoryModel> subCategories;
  final List<SubProductModel> subProducts;
  
  final OperationInfo loadProductsInfo;
  final OperationInfo loadCategoriesInfo;
  final OperationInfo loadSubCategoriesInfo;
  final OperationInfo loadSubProductsInfo;
  final OperationInfo saveInfo;
  final OperationInfo deleteInfo;

  const ProductState({
    this.products = const [],
    this.categories = const [],
    this.subCategories = const [],
    this.subProducts = const [],
    this.loadProductsInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadCategoriesInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadSubCategoriesInfo = const OperationInfo(status: OperationStatus.initial),
    this.loadSubProductsInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveInfo = const OperationInfo(status: OperationStatus.initial),
    this.deleteInfo = const OperationInfo(status: OperationStatus.initial),
  });

  ProductState copyWith({
    List<ProductModel>? products,
    List<ProductCategoryModel>? categories,
    List<ProductSubCategoryModel>? subCategories,
    List<SubProductModel>? subProducts,
    OperationInfo? loadProductsInfo,
    OperationInfo? loadCategoriesInfo,
    OperationInfo? loadSubCategoriesInfo,
    OperationInfo? loadSubProductsInfo,
    OperationInfo? saveInfo,
    OperationInfo? deleteInfo,
  }) {
    return ProductState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      subCategories: subCategories ?? this.subCategories,
      subProducts: subProducts ?? this.subProducts,
      loadProductsInfo: loadProductsInfo ?? this.loadProductsInfo,
      loadCategoriesInfo: loadCategoriesInfo ?? this.loadCategoriesInfo,
      loadSubCategoriesInfo: loadSubCategoriesInfo ?? this.loadSubCategoriesInfo,
      loadSubProductsInfo: loadSubProductsInfo ?? this.loadSubProductsInfo,
      saveInfo: saveInfo ?? this.saveInfo,
      deleteInfo: deleteInfo ?? this.deleteInfo,
    );
  }
}
