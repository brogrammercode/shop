// Auto-generated Model file for ItemCategory

class ItemCategoryModel {
  final String id;
  final String branch_id;
  final String name;
  final String? description;
  final List<String> images;
  final DateTime created_at;
  final DateTime updated_at;
  final bool is_deleted;

  const ItemCategoryModel({
    required this.id,
    required this.branch_id,
    required this.name,
    this.description,
    required this.images,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory ItemCategoryModel.fromJson(Map<String, dynamic> json) {
    return ItemCategoryModel(
      id: json['id'],
      branch_id: json['branch_id'],
      name: json['name'],
      description: json['description'],
      images: json['images'] != null ? List<String>.from(json['images']) : [],
      created_at: DateTime.parse(json['created_at'].toString()),
      updated_at: DateTime.parse(json['updated_at'].toString()),
      is_deleted: json['is_deleted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'name': name,
      'description': description,
      'images': images,
      'created_at': created_at.toIso8601String(),
      'updated_at': updated_at.toIso8601String(),
      'is_deleted': is_deleted,
    };
  }

  ItemCategoryModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    String? description,
    List<String>? images,
    DateTime? created_at,
    DateTime? updated_at,
    bool? is_deleted,
  }) {
    return ItemCategoryModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
