import 'package:mobile/features/product/constants/product.dart';

class ProductInputModel {
  final String branch_id;
  final String sku;
  final String barcode;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String unit;
  final int low_stock_alert;
  final bool is_available;

  const ProductInputModel({
    required this.branch_id,
    required this.sku,
    required this.barcode,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.unit,
    required this.low_stock_alert,
    required this.is_available,
  });

  Map<String, dynamic> toJson() {
    return {
      'branch_id': branch_id,
      'sku': sku,
      'barcode': barcode,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'unit': unit.isEmpty ? ProductConstants.defaultUnit : unit,
      'low_stock_alert': low_stock_alert,
      'images': <String>[],
      'is_veg': false,
      'preparation_time': 0,
      'variants': <Map<String, dynamic>>[],
      'is_available': is_available,
    };
  }
}
