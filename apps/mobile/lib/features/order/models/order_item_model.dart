import 'package:mobile/features/product/models/product_model.dart';
import 'package:mobile/features/product/models/product_variant_model.dart';

class OrderItemModel {
  final String id;
  final String order_id;
  final String product_id;
  final int quantity;
  final double price;
  final List<ProductVariantModel> variants;
  final String notes;
  final String created_at;
  final String updated_at;
  final ProductModel product;

  const OrderItemModel({
    required this.id,
    required this.order_id,
    required this.product_id,
    required this.quantity,
    required this.price,
    required this.variants,
    required this.notes,
    required this.created_at,
    required this.updated_at,
    required this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id']?.toString() ?? '',
      order_id: json['order_id']?.toString() ?? '',
      product_id: json['product_id']?.toString() ?? '',
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map<ProductVariantModel>(
            (variant) => ProductVariantModel.fromJson(
              Map<String, dynamic>.from(variant),
            ),
          )
          .toList(),
      notes: json['notes']?.toString() ?? '',
      created_at: json['created_at']?.toString() ?? '',
      updated_at: json['updated_at']?.toString() ?? '',
      product: ProductModel.fromJson(
        Map<String, dynamic>.from(json['product'] ?? {}),
      ),
    );
  }

  double get total {
    return price * quantity;
  }
}
