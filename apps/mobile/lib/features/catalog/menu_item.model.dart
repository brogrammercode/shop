// Auto-generated Model file for MenuItem

class MenuItemModel {
  final String id;
  final String branch_id;
  final String category_id;
  final String variant_id;
  final String display_name;
  final String description;
  final double selling_price;
  final String image_url;
  final String status;
  final String created_at;
  final String updated_at;
  final String created_by;
  final bool is_deleted;

  const MenuItemModel({
    required this.id,
    required this.branch_id,
    required this.category_id,
    required this.variant_id,
    required this.display_name,
    required this.description,
    required this.selling_price,
    required this.image_url,
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
      display_name: json['display_name'] ?? '',
      description: json['description'] ?? '',
      selling_price: json['selling_price'] ?? 0.0,
      image_url: json['image_url'] ?? '',
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
      'display_name': display_name,
      'description': description,
      'selling_price': selling_price,
      'image_url': image_url,
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
    String? display_name,
    String? description,
    double? selling_price,
    String? image_url,
    String? status,
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
      display_name: display_name ?? this.display_name,
      description: description ?? this.description,
      selling_price: selling_price ?? this.selling_price,
      image_url: image_url ?? this.image_url,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      created_by: created_by ?? this.created_by,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
