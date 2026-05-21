import 'package:mobile/features/product/models/product_model.dart';
import 'package:mobile/utils/error.dart';

class ProductState {
  final List<ProductModel> products;
  final ProductModel? selectedProduct;
  final String search;
  final OperationInfo listInfo;
  final OperationInfo saveInfo;
  final OperationInfo deleteInfo;

  const ProductState({
    this.products = const [],
    this.selectedProduct,
    this.search = '',
    this.listInfo = const OperationInfo(status: OperationStatus.initial),
    this.saveInfo = const OperationInfo(status: OperationStatus.initial),
    this.deleteInfo = const OperationInfo(status: OperationStatus.initial),
  });

  ProductState copyWith({
    List<ProductModel>? products,
    ProductModel? selectedProduct,
    bool clearSelectedProduct = false,
    String? search,
    OperationInfo? listInfo,
    OperationInfo? saveInfo,
    OperationInfo? deleteInfo,
  }) {
    return ProductState(
      products: products ?? this.products,
      selectedProduct: clearSelectedProduct
          ? null
          : selectedProduct ?? this.selectedProduct,
      search: search ?? this.search,
      listInfo: listInfo ?? this.listInfo,
      saveInfo: saveInfo ?? this.saveInfo,
      deleteInfo: deleteInfo ?? this.deleteInfo,
    );
  }
}
