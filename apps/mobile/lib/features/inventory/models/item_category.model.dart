// Auto-generated Model file for ItemCategory

class ItemCategoryModel {
  final String id;
  final String branch_id;
  final String name;
  final String description;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const ItemCategoryModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.description,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory ItemCategoryModel.fromJson(Map<String, dynamic> json) {
    return ItemCategoryModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
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
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  ItemCategoryModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    String? description,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return ItemCategoryModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      description: description ?? this.description,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
