// Auto-generated Model file for TransferItem

class TransferItemModel {
  final String id;
  final String transfer_id;
  final String variant_id;
  final double quantity;
  final String created_at;
  final String updated_at;

  const TransferItemModel({
    required this.id,
    required this.transfer_id,
    required this.variant_id,
    required this.quantity,
    required this.created_at,
    required this.updated_at,
  });

  factory TransferItemModel.fromJson(Map<String, dynamic> json) {
    return TransferItemModel(
      id: json['id'] ?? '',
      transfer_id: json['transfer_id'] ?? '',
      variant_id: json['variant_id'] ?? '',
      quantity: json['quantity'] ?? 0.0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transfer_id': transfer_id,
      'variant_id': variant_id,
      'quantity': quantity,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  TransferItemModel copyWith({
    String? id,
    String? transfer_id,
    String? variant_id,
    double? quantity,
    String? created_at,
    String? updated_at,
  }) {
    return TransferItemModel(
      id: id ?? this.id,
      transfer_id: transfer_id ?? this.transfer_id,
      variant_id: variant_id ?? this.variant_id,
      quantity: quantity ?? this.quantity,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
