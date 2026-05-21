class BillModel {
  final String id;
  final String order_id;
  final String bill_number;
  final double sub_total;
  final double tax;
  final double discount;
  final double order_amount;
  final double delivery_amount;
  final double total_amount;
  final String payment_status;
  final String payment_method;
  final String created_at;
  final String updated_at;

  const BillModel({
    required this.id,
    required this.order_id,
    required this.bill_number,
    required this.sub_total,
    required this.tax,
    required this.discount,
    required this.order_amount,
    required this.delivery_amount,
    required this.total_amount,
    required this.payment_status,
    required this.payment_method,
    required this.created_at,
    required this.updated_at,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id']?.toString() ?? '',
      order_id: json['order_id']?.toString() ?? '',
      bill_number: json['bill_number']?.toString() ?? '',
      sub_total: double.tryParse(json['sub_total']?.toString() ?? '') ?? 0,
      tax: double.tryParse(json['tax']?.toString() ?? '') ?? 0,
      discount: double.tryParse(json['discount']?.toString() ?? '') ?? 0,
      order_amount:
          double.tryParse(json['order_amount']?.toString() ?? '') ?? 0,
      delivery_amount:
          double.tryParse(json['delivery_amount']?.toString() ?? '') ?? 0,
      total_amount:
          double.tryParse(json['total_amount']?.toString() ?? '') ?? 0,
      payment_status: json['payment_status']?.toString() ?? '',
      payment_method: json['payment_method']?.toString() ?? '',
      created_at: json['created_at']?.toString() ?? '',
      updated_at: json['updated_at']?.toString() ?? '',
    );
  }
}
