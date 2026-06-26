// Auto-generated Model file for AdvancePayment

class AdvancePaymentModel {
  final String id;
  final String branch_id;
  final String order_id;
  final double amount_paid;
  final String payment_method;
  final String transaction_ref;
  final String created_at;
  final String updated_at;
  final String processed_by;

  const AdvancePaymentModel({
    required this.id,
    required this.branch_id,
    required this.order_id,
    required this.amount_paid,
    required this.payment_method,
    required this.transaction_ref,
    required this.created_at,
    required this.updated_at,
    required this.processed_by,
  });

  factory AdvancePaymentModel.fromJson(Map<String, dynamic> json) {
    return AdvancePaymentModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      order_id: json['order_id'] ?? '',
      amount_paid: json['amount_paid'] ?? 0.0,
      payment_method: json['payment_method'] ?? '',
      transaction_ref: json['transaction_ref'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      processed_by: json['processed_by'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'order_id': order_id,
      'amount_paid': amount_paid,
      'payment_method': payment_method,
      'transaction_ref': transaction_ref,
      'created_at': created_at,
      'updated_at': updated_at,
      'processed_by': processed_by,
    };
  }

  AdvancePaymentModel copyWith({
    String? id,
    String? branch_id,
    String? order_id,
    double? amount_paid,
    String? payment_method,
    String? transaction_ref,
    String? created_at,
    String? updated_at,
    String? processed_by,
  }) {
    return AdvancePaymentModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      order_id: order_id ?? this.order_id,
      amount_paid: amount_paid ?? this.amount_paid,
      payment_method: payment_method ?? this.payment_method,
      transaction_ref: transaction_ref ?? this.transaction_ref,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      processed_by: processed_by ?? this.processed_by,
    );
  }
}
