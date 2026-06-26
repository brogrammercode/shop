// Auto-generated Model file for Order

class OrderModel {
  final String id;
  final String branch_id;
  final String table_id;
  final String uid;
  final String employee_id;
  final String partner_id;
  final String order_type;
  final String status;
  final double subtotal;
  final double tax_amount;
  final double discount_amount;
  final double total_amount;
  final String fulfillment_date;
  final String notes;
  final String created_at;
  final String updated_at;

  const OrderModel({
    required this.id,
    required this.branch_id,
    required this.table_id,
    required this.uid,
    required this.employee_id,
    required this.partner_id,
    required this.order_type,
    required this.status,
    required this.subtotal,
    required this.tax_amount,
    required this.discount_amount,
    required this.total_amount,
    required this.fulfillment_date,
    required this.notes,
    required this.created_at,
    required this.updated_at,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      table_id: json['table_id'] ?? '',
      uid: json['uid'] ?? '',
      employee_id: json['employee_id'] ?? '',
      partner_id: json['partner_id'] ?? '',
      order_type: json['order_type'] ?? '',
      status: json['status'] ?? '',
      subtotal: json['subtotal'] ?? 0.0,
      tax_amount: json['tax_amount'] ?? 0.0,
      discount_amount: json['discount_amount'] ?? 0.0,
      total_amount: json['total_amount'] ?? 0.0,
      fulfillment_date: json['fulfillment_date'] ?? '',
      notes: json['notes'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'table_id': table_id,
      'uid': uid,
      'employee_id': employee_id,
      'partner_id': partner_id,
      'order_type': order_type,
      'status': status,
      'subtotal': subtotal,
      'tax_amount': tax_amount,
      'discount_amount': discount_amount,
      'total_amount': total_amount,
      'fulfillment_date': fulfillment_date,
      'notes': notes,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  OrderModel copyWith({
    String? id,
    String? branch_id,
    String? table_id,
    String? uid,
    String? employee_id,
    String? partner_id,
    String? order_type,
    String? status,
    double? subtotal,
    double? tax_amount,
    double? discount_amount,
    double? total_amount,
    String? fulfillment_date,
    String? notes,
    String? created_at,
    String? updated_at,
  }) {
    return OrderModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      table_id: table_id ?? this.table_id,
      uid: uid ?? this.uid,
      employee_id: employee_id ?? this.employee_id,
      partner_id: partner_id ?? this.partner_id,
      order_type: order_type ?? this.order_type,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      tax_amount: tax_amount ?? this.tax_amount,
      discount_amount: discount_amount ?? this.discount_amount,
      total_amount: total_amount ?? this.total_amount,
      fulfillment_date: fulfillment_date ?? this.fulfillment_date,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
