// Auto-generated Model file for MenuCategory

class MenuCategoryModel {
  final String id;
  final String branch_id;
  final String name;
  final String description;
  final int display_order;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const MenuCategoryModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.description,
    required this.display_order,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      display_order: json['display_order'] ?? 0,
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'name': name,
      'description': description,
      'display_order': display_order,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  MenuCategoryModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    String? description,
    int? display_order,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return MenuCategoryModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      description: description ?? this.description,
      display_order: display_order ?? this.display_order,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
