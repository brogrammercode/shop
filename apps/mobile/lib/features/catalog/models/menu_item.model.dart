import 'package:mobile/features/catalog/models/menu_item_sale_mode.model.dart';

class MenuItemModel {
  final String id;
  final String branch_id;
  final String category_id;
  final String variant_id;
  final String? item_id;
  final String display_name;
  final String description;
  final double selling_price;
  final List<String> videos;
  final String status;
  final List<String> images;
  final List<MenuItemSaleModeModel> sale_modes;
  final String created_at;
  final String updated_at;
  final String created_by;
  final bool is_deleted;

  const MenuItemModel({
    required this.id,
    required this.branch_id,
    required this.category_id,
    required this.variant_id,
    this.item_id,
    required this.display_name,
    required this.description,
    required this.selling_price,
    this.videos = const [],
    this.images = const [],
    this.sale_modes = const [],
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.created_by,
    required this.is_deleted,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      category_id: json['category_id'] ?? '',
      variant_id: json['variant_id'] ?? '',
      item_id: json['variant']?['item_id'],
      display_name: json['display_name'] ?? '',
      description: json['description'] ?? '',
      images: (json['images'] as List?)?.map((e) => e as String).toList() ?? const [],
      sale_modes:
          (json['sale_modes'] as List?)
              ?.map((e) => MenuItemSaleModeModel.fromJson(e))
              .toList() ??
          const [],
      selling_price: (json['selling_price'] as num?)?.toDouble() ?? 0.0,
      videos: (json['videos'] as List?)?.map((e) => e as String).toList() ?? const [],
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      created_by: json['created_by'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'category_id': category_id,
      'variant_id': variant_id,
      'item_id': item_id,
      'display_name': display_name,
      'description': description,
      'selling_price': selling_price,
      'videos': videos,
      'images': images,
      'sale_modes': sale_modes.map((e) => e.toJson()).toList(),
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'created_by': created_by,
      'is_deleted': is_deleted,
    };
  }

  MenuItemModel copyWith({
    String? id,
    String? branch_id,
    String? category_id,
    String? variant_id,
    String? item_id,
    String? display_name,
    String? description,
    double? selling_price,
    List<String>? videos,
    String? status,
    List<String>? images,
    List<MenuItemSaleModeModel>? sale_modes,
    String? created_at,
    String? updated_at,
    String? created_by,
    bool? is_deleted,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      category_id: category_id ?? this.category_id,
      variant_id: variant_id ?? this.variant_id,
      item_id: item_id ?? this.item_id,
      display_name: display_name ?? this.display_name,
      description: description ?? this.description,
      selling_price: selling_price ?? this.selling_price,
      videos: videos ?? this.videos,
      images: images ?? this.images,
      sale_modes: sale_modes ?? this.sale_modes,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      created_by: created_by ?? this.created_by,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
