// Auto-generated Model file for Modifier

class ModifierModel {
  final String id;
  final String branch_id;
  final String group_id;
  final String variant_id;
  final String name;
  final double extra_price;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const ModifierModel({
    required this.id,
    required this.branch_id,
    required this.group_id,
    required this.variant_id,
    required this.name,
    required this.extra_price,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory ModifierModel.fromJson(Map<String, dynamic> json) {
    return ModifierModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      group_id: json['group_id'] ?? '',
      variant_id: json['variant_id'] ?? '',
      name: json['name'] ?? '',
      extra_price: json['extra_price'] ?? 0.0,
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
      'group_id': group_id,
      'variant_id': variant_id,
      'name': name,
      'extra_price': extra_price,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  ModifierModel copyWith({
    String? id,
    String? branch_id,
    String? group_id,
    String? variant_id,
    String? name,
    double? extra_price,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return ModifierModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      group_id: group_id ?? this.group_id,
      variant_id: variant_id ?? this.variant_id,
      name: name ?? this.name,
      extra_price: extra_price ?? this.extra_price,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
