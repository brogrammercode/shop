import 'package:mobile/features/product/models/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  const CartItemModel({required this.product, required this.quantity});

  CartItemModel copyWith({ProductModel? product, int? quantity}) {
    return CartItemModel(
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
    );
  }

  double get total {
    return product.price * quantity;
  }

  Map<String, dynamic> toCounterJson() {
    return {
      'product_id': product.id,
      'quantity': quantity,
      'variants': <Map<String, dynamic>>[],
    };
  }
}
