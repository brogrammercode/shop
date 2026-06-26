// Auto-generated Model file for UOMConversion

class UOMConversionModel {
  final String id;
  final String branch_id;
  final String from_uom_id;
  final String to_uom_id;
  final double factor;
  final String created_at;
  final String updated_at;

  const UOMConversionModel({
    required this.id,
    required this.branch_id,
    required this.from_uom_id,
    required this.to_uom_id,
    required this.factor,
    required this.created_at,
    required this.updated_at,
  });

  factory UOMConversionModel.fromJson(Map<String, dynamic> json) {
    return UOMConversionModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      from_uom_id: json['from_uom_id'] ?? '',
      to_uom_id: json['to_uom_id'] ?? '',
      factor: json['factor'] ?? 0.0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'from_uom_id': from_uom_id,
      'to_uom_id': to_uom_id,
      'factor': factor,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  UOMConversionModel copyWith({
    String? id,
    String? branch_id,
    String? from_uom_id,
    String? to_uom_id,
    double? factor,
    String? created_at,
    String? updated_at,
  }) {
    return UOMConversionModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      from_uom_id: from_uom_id ?? this.from_uom_id,
      to_uom_id: to_uom_id ?? this.to_uom_id,
      factor: factor ?? this.factor,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
