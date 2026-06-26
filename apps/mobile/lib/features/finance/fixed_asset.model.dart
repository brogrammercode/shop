// Auto-generated Model file for FixedAsset

class FixedAssetModel {
  final String id;
  final String branch_id;
  final String name;
  final double purchase_value;
  final double depreciation_pct;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const FixedAssetModel({
    required this.id,
    required this.branch_id,
    required this.name,
    required this.purchase_value,
    required this.depreciation_pct,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory FixedAssetModel.fromJson(Map<String, dynamic> json) {
    return FixedAssetModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      name: json['name'] ?? '',
      purchase_value: json['purchase_value'] ?? 0.0,
      depreciation_pct: json['depreciation_pct'] ?? 0.0,
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
      'purchase_value': purchase_value,
      'depreciation_pct': depreciation_pct,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  FixedAssetModel copyWith({
    String? id,
    String? branch_id,
    String? name,
    double? purchase_value,
    double? depreciation_pct,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return FixedAssetModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      name: name ?? this.name,
      purchase_value: purchase_value ?? this.purchase_value,
      depreciation_pct: depreciation_pct ?? this.depreciation_pct,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
