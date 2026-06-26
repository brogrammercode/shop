// Auto-generated Model file for StockLedger

class StockLedgerModel {
  final String id;
  final String branch_id;
  final String variant_id;
  final String transaction_type;
  final double quantity_change;
  final double running_balance;
  final String reference_id;
  final String created_at;
  final String updated_at;
  final String created_by;

  const StockLedgerModel({
    required this.id,
    required this.branch_id,
    required this.variant_id,
    required this.transaction_type,
    required this.quantity_change,
    required this.running_balance,
    required this.reference_id,
    required this.created_at,
    required this.updated_at,
    required this.created_by,
  });

  factory StockLedgerModel.fromJson(Map<String, dynamic> json) {
    return StockLedgerModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      variant_id: json['variant_id'] ?? '',
      transaction_type: json['transaction_type'] ?? '',
      quantity_change: json['quantity_change'] ?? 0.0,
      running_balance: json['running_balance'] ?? 0.0,
      reference_id: json['reference_id'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      created_by: json['created_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'variant_id': variant_id,
      'transaction_type': transaction_type,
      'quantity_change': quantity_change,
      'running_balance': running_balance,
      'reference_id': reference_id,
      'created_at': created_at,
      'updated_at': updated_at,
      'created_by': created_by,
    };
  }

  StockLedgerModel copyWith({
    String? id,
    String? branch_id,
    String? variant_id,
    String? transaction_type,
    double? quantity_change,
    double? running_balance,
    String? reference_id,
    String? created_at,
    String? updated_at,
    String? created_by,
  }) {
    return StockLedgerModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      variant_id: variant_id ?? this.variant_id,
      transaction_type: transaction_type ?? this.transaction_type,
      quantity_change: quantity_change ?? this.quantity_change,
      running_balance: running_balance ?? this.running_balance,
      reference_id: reference_id ?? this.reference_id,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      created_by: created_by ?? this.created_by,
    );
  }
}
