// Auto-generated Model file for POItem

class POItemModel {
  final String id;
  final String po_id;
  final String variant_id;
  final double qty_ordered;
  final double unit_price;
  final double total_price;
  final String created_at;
  final String updated_at;

  const POItemModel({
    required this.id,
    required this.po_id,
    required this.variant_id,
    required this.qty_ordered,
    required this.unit_price,
    required this.total_price,
    required this.created_at,
    required this.updated_at,
  });

  factory POItemModel.fromJson(Map<String, dynamic> json) {
    return POItemModel(
      id: json['id'] ?? '',
      po_id: json['po_id'] ?? '',
      variant_id: json['variant_id'] ?? '',
      qty_ordered: json['qty_ordered'] ?? 0.0,
      unit_price: json['unit_price'] ?? 0.0,
      total_price: json['total_price'] ?? 0.0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'po_id': po_id,
      'variant_id': variant_id,
      'qty_ordered': qty_ordered,
      'unit_price': unit_price,
      'total_price': total_price,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  POItemModel copyWith({
    String? id,
    String? po_id,
    String? variant_id,
    double? qty_ordered,
    double? unit_price,
    double? total_price,
    String? created_at,
    String? updated_at,
  }) {
    return POItemModel(
      id: id ?? this.id,
      po_id: po_id ?? this.po_id,
      variant_id: variant_id ?? this.variant_id,
      qty_ordered: qty_ordered ?? this.qty_ordered,
      unit_price: unit_price ?? this.unit_price,
      total_price: total_price ?? this.total_price,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
