// Auto-generated Model file for UnitOfMeasure

class UnitOfMeasureModel {
  final String id;
  final String branch_id;
  final String code;
  final String description;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const UnitOfMeasureModel({
    required this.id,
    required this.branch_id,
    required this.code,
    required this.description,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory UnitOfMeasureModel.fromJson(Map<String, dynamic> json) {
    return UnitOfMeasureModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      code: json['code'] ?? '',
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
      'code': code,
      'description': description,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  UnitOfMeasureModel copyWith({
    String? id,
    String? branch_id,
    String? code,
    String? description,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return UnitOfMeasureModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      code: code ?? this.code,
      description: description ?? this.description,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
