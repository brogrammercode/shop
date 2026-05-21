import 'package:mobile/features/product/models/product_variant_model.dart';

class ProductModel {
  final String id;
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
  final List<String> images;
  final bool is_veg;
  final int preparation_time;
  final List<ProductVariantModel> variants;
  final bool is_available;
  final String created_at;
  final String updated_at;

  const ProductModel({
    required this.id,
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
    required this.images,
    required this.is_veg,
    required this.preparation_time,
    required this.variants,
    required this.is_available,
    required this.created_at,
    required this.updated_at,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      branch_id: json['branch_id']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      barcode: json['barcode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '') ?? 0,
      stock: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
      category: json['category']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      low_stock_alert:
          int.tryParse(json['low_stock_alert']?.toString() ?? '') ?? 0,
      images: (json['images'] as List<dynamic>? ?? [])
          .map<String>((image) => image.toString())
          .toList(),
      is_veg: json['is_veg'] == true,
      preparation_time:
          int.tryParse(json['preparation_time']?.toString() ?? '') ?? 0,
      variants: (json['variants'] as List<dynamic>? ?? [])
          .map<ProductVariantModel>(
            (variant) => ProductVariantModel.fromJson(
              Map<String, dynamic>.from(variant),
            ),
          )
          .toList(),
      is_available: json['is_available'] != false,
      created_at: json['created_at']?.toString() ?? '',
      updated_at: json['updated_at']?.toString() ?? '',
    );
  }

  ProductModel copyWith({
    String? id,
    String? branch_id,
    String? sku,
    String? barcode,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? unit,
    int? low_stock_alert,
    List<String>? images,
    bool? is_veg,
    int? preparation_time,
    List<ProductVariantModel>? variants,
    bool? is_available,
    String? created_at,
    String? updated_at,
  }) {
    return ProductModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      unit: unit ?? this.unit,
      low_stock_alert: low_stock_alert ?? this.low_stock_alert,
      images: images ?? this.images,
      is_veg: is_veg ?? this.is_veg,
      preparation_time: preparation_time ?? this.preparation_time,
      variants: variants ?? this.variants,
      is_available: is_available ?? this.is_available,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'sku': sku,
      'barcode': barcode,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'unit': unit,
      'low_stock_alert': low_stock_alert,
      'images': images,
      'is_veg': is_veg,
      'preparation_time': preparation_time,
      'variants': variants.map((variant) => variant.toJson()).toList(),
      'is_available': is_available,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
