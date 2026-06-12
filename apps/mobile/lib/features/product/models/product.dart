import '../../business/models/branch.dart';
import 'product_category.dart';
import 'product_sub_category.dart';

class ProductVariantModel {
  final String name;
  final num price;

  const ProductVariantModel({
    required this.name,
    required this.price,
  });

  ProductVariantModel copyWith({
    String? name,
    num? price,
  }) {
    return ProductVariantModel(
      name: name ?? this.name,
      price: price ?? this.price,
    );
  }

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      name: json['name']?.toString() ?? '',
      price: json['price'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}

class ProductModel {
  final String id;
  final String branch_id;
  final String sku;
  final String barcode;
  final String name;
  final String description;
  final num price;
  final num stock;
  final String category_id;
  final String sub_category_id;
  final String unit;
  final num low_stock_alert;
  final List<String> images;
  final List<String> videos;
  final bool is_veg;
  final num preparation_time;
  final List<ProductVariantModel> variants;
  final bool is_available;
  final String created_at;
  final String updated_at;
  
  final BranchModel? branch;
  final ProductCategoryModel? category;
  final ProductSubCategoryModel? sub_category;

  const ProductModel({
    required this.id,
    required this.branch_id,
    required this.sku,
    required this.barcode,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category_id,
    required this.sub_category_id,
    required this.unit,
    required this.low_stock_alert,
    required this.images,
    required this.videos,
    required this.is_veg,
    required this.preparation_time,
    required this.variants,
    required this.is_available,
    required this.created_at,
    required this.updated_at,
    this.branch,
    this.category,
    this.sub_category,
  });

  ProductModel copyWith({
    String? id,
    String? branch_id,
    String? sku,
    String? barcode,
    String? name,
    String? description,
    num? price,
    num? stock,
    String? category_id,
    String? sub_category_id,
    String? unit,
    num? low_stock_alert,
    List<String>? images,
    List<String>? videos,
    bool? is_veg,
    num? preparation_time,
    List<ProductVariantModel>? variants,
    bool? is_available,
    String? created_at,
    String? updated_at,
    BranchModel? branch,
    ProductCategoryModel? category,
    ProductSubCategoryModel? sub_category,
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
      category_id: category_id ?? this.category_id,
      sub_category_id: sub_category_id ?? this.sub_category_id,
      unit: unit ?? this.unit,
      low_stock_alert: low_stock_alert ?? this.low_stock_alert,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      is_veg: is_veg ?? this.is_veg,
      preparation_time: preparation_time ?? this.preparation_time,
      variants: variants ?? this.variants,
      is_available: is_available ?? this.is_available,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      branch: branch ?? this.branch,
      category: category ?? this.category,
      sub_category: sub_category ?? this.sub_category,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id']?.toString() ?? '',
      branch_id: json['branch_id']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      barcode: json['barcode']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: json['price'] ?? 0,
      stock: json['stock'] ?? 0,
      category_id: json['category_id']?.toString() ?? '',
      sub_category_id: json['sub_category_id']?.toString() ?? '',
      unit: json['unit']?.toString() ?? 'pcs',
      low_stock_alert: json['low_stock_alert'] ?? 0,
      images: json['images'] != null ? List<String>.from(json['images']) : const [],
      videos: json['videos'] != null ? List<String>.from(json['videos']) : const [],
      is_veg: json['is_veg'] ?? false,
      preparation_time: json['preparation_time'] ?? 0,
      variants: json['variants'] != null
          ? (json['variants'] as List).map((v) => ProductVariantModel.fromJson(v)).toList()
          : const [],
      is_available: json['is_available'] ?? true,
      created_at: json['created_at']?.toString() ?? '',
      updated_at: json['updated_at']?.toString() ?? '',
      branch: json['branch'] != null ? BranchModel.fromJson(json['branch']) : null,
      category: json['category'] != null ? ProductCategoryModel.fromJson(json['category']) : null,
      sub_category: json['sub_category'] != null ? ProductSubCategoryModel.fromJson(json['sub_category']) : null,
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
      'category_id': category_id,
      'sub_category_id': sub_category_id,
      'unit': unit,
      'low_stock_alert': low_stock_alert,
      'images': images,
      'videos': videos,
      'is_veg': is_veg,
      'preparation_time': preparation_time,
      'variants': variants.map((v) => v.toJson()).toList(),
      'is_available': is_available,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
