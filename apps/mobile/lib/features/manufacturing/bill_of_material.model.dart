// Auto-generated Model file for BillOfMaterial

class BillOfMaterialModel {
  final String id;
  final String branch_id;
  final String output_variant_id;
  final double yield_quantity;
  final String instructions;
  final String status;
  final String created_at;
  final String updated_at;
  final String created_by;
  final bool is_deleted;

  const BillOfMaterialModel({
    required this.id,
    required this.branch_id,
    required this.output_variant_id,
    required this.yield_quantity,
    required this.instructions,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.created_by,
    required this.is_deleted,
  });

  factory BillOfMaterialModel.fromJson(Map<String, dynamic> json) {
    return BillOfMaterialModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      output_variant_id: json['output_variant_id'] ?? '',
      yield_quantity: json['yield_quantity'] ?? 0.0,
      instructions: json['instructions'] ?? '',
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
      'output_variant_id': output_variant_id,
      'yield_quantity': yield_quantity,
      'instructions': instructions,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'created_by': created_by,
      'is_deleted': is_deleted,
    };
  }

  BillOfMaterialModel copyWith({
    String? id,
    String? branch_id,
    String? output_variant_id,
    double? yield_quantity,
    String? instructions,
    String? status,
    String? created_at,
    String? updated_at,
    String? created_by,
    bool? is_deleted,
  }) {
    return BillOfMaterialModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      output_variant_id: output_variant_id ?? this.output_variant_id,
      yield_quantity: yield_quantity ?? this.yield_quantity,
      instructions: instructions ?? this.instructions,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      created_by: created_by ?? this.created_by,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
