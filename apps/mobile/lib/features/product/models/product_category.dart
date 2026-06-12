class ProductCategoryModel {
  final String id;
  final String branch_id;
  final String name;
  final String description;
  final List<String> images;
  final List<String> videos;
  final String created_at;
  final String updated_at;

  const ProductCategoryModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.description,
    required this.images,
    required this.videos,
    required this.created_at,
    required this.updated_at,
  });

  ProductCategoryModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    String? description,
    List<String>? images,
    List<String>? videos,
    String? created_at,
    String? updated_at,
  }) {
    return ProductCategoryModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      description: description ?? this.description,
      images: images ?? this.images,
      videos: videos ?? this.videos,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id']?.toString() ?? '',
      branch_id: json['branch_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : const [],
      videos: json['videos'] != null ? List<String>.from(json['videos']) : const [],
      created_at: json['created_at']?.toString() ?? '',
      updated_at: json['updated_at']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'name': name,
      'description': description,
      'images': images,
      'videos': videos,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }
}
