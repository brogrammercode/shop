// Auto-generated Model file for BOMItem

class BOMItemModel {
  final String id;
  final String bom_id;
  final String input_variant_id;
  final double quantity;
  final String created_at;
  final String updated_at;

  const BOMItemModel({
    required this.id,
    required this.bom_id,
    required this.input_variant_id,
    required this.quantity,
    required this.created_at,
    required this.updated_at,
  });

  factory BOMItemModel.fromJson(Map<String, dynamic> json) {
    return BOMItemModel(
      id: json['id'] ?? '',
      bom_id: json['bom_id'] ?? '',
      input_variant_id: json['input_variant_id'] ?? '',
      quantity: json['quantity'] ?? 0.0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bom_id': bom_id,
      'input_variant_id': input_variant_id,
      'quantity': quantity,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  BOMItemModel copyWith({
    String? id,
    String? bom_id,
    String? input_variant_id,
    double? quantity,
    String? created_at,
    String? updated_at,
  }) {
    return BOMItemModel(
      id: id ?? this.id,
      bom_id: bom_id ?? this.bom_id,
      input_variant_id: input_variant_id ?? this.input_variant_id,
      quantity: quantity ?? this.quantity,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
