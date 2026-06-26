// Auto-generated Model file for ComboMeal

class ComboMealModel {
  final String id;
  final String branch_id;
  final String name;
  final double fixed_price;
  final String image_url;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const ComboMealModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.fixed_price,
    required this.image_url,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory ComboMealModel.fromJson(Map<String, dynamic> json) {
    return ComboMealModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      fixed_price: json['fixed_price'] ?? 0.0,
      image_url: json['image_url'] ?? '',
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
      'fixed_price': fixed_price,
      'image_url': image_url,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  ComboMealModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    double? fixed_price,
    String? image_url,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return ComboMealModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      fixed_price: fixed_price ?? this.fixed_price,
      image_url: image_url ?? this.image_url,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
