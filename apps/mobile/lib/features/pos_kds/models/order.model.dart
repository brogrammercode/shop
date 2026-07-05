import 'package:mobile/features/pos_kds/models/order_item.model.dart';

class OrderModel {
  final String id;
  final String branch_id;
  final String table_id;
  final String uid;
  final String delivery_address_id;
  final String employee_id;
  final String partner_id;
  final String order_type;
  final String status;
  final double subtotal;
  final double tax_amount;
  final double discount_amount;
  final double price_addition_amount;
  final double price_reduction_amount;
  final double total_amount;
  final double final_paying_price;
  final String fulfillment_date;
  final String notes;
  final String created_at;
  final String updated_at;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.branch_id,
    required this.table_id,
    required this.uid,
    required this.delivery_address_id,
    required this.employee_id,
    required this.partner_id,
    required this.order_type,
    required this.status,
    required this.subtotal,
    required this.tax_amount,
    required this.discount_amount,
    required this.price_addition_amount,
    required this.price_reduction_amount,
    required this.total_amount,
    required this.final_paying_price,
    required this.fulfillment_date,
    required this.notes,
    required this.created_at,
    required this.updated_at,
    this.items = const [],
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      table_id: json['table_id'] ?? '',
      uid: json['uid'] ?? '',
      delivery_address_id: json['delivery_address_id'] ?? '',
      employee_id: json['employee_id'] ?? '',
      partner_id: json['partner_id'] ?? '',
      order_type: json['order_type'] ?? '',
      status: json['status'] ?? '',
      subtotal: (json['subtotal'] as num?)?.toDouble() ?? 0.0,
      tax_amount: (json['tax_amount'] as num?)?.toDouble() ?? 0.0,
      discount_amount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      price_addition_amount:
          (json['price_addition_amount'] as num?)?.toDouble() ?? 0.0,
      price_reduction_amount:
          (json['price_reduction_amount'] as num?)?.toDouble() ?? 0.0,
      total_amount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      final_paying_price:
          (json['final_paying_price'] as num?)?.toDouble() ?? 0.0,
      fulfillment_date: json['fulfillment_date'] ?? '',
      notes: json['notes'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      items:
          (json['items'] as List?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'table_id': table_id,
      'uid': uid,
      'delivery_address_id': delivery_address_id,
      'employee_id': employee_id,
      'partner_id': partner_id,
      'order_type': order_type,
      'status': status,
      'subtotal': subtotal,
      'tax_amount': tax_amount,
      'discount_amount': discount_amount,
      'price_addition_amount': price_addition_amount,
      'price_reduction_amount': price_reduction_amount,
      'total_amount': total_amount,
      'final_paying_price': final_paying_price,
      'fulfillment_date': fulfillment_date,
      'notes': notes,
      'created_at': created_at,
      'updated_at': updated_at,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  OrderModel copyWith({
    String? id,
    String? branch_id,
    String? table_id,
    String? uid,
    String? delivery_address_id,
    String? employee_id,
    String? partner_id,
    String? order_type,
    String? status,
    double? subtotal,
    double? tax_amount,
    double? discount_amount,
    double? price_addition_amount,
    double? price_reduction_amount,
    double? total_amount,
    double? final_paying_price,
    String? fulfillment_date,
    String? notes,
    String? created_at,
    String? updated_at,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      table_id: table_id ?? this.table_id,
      uid: uid ?? this.uid,
      delivery_address_id: delivery_address_id ?? this.delivery_address_id,
      employee_id: employee_id ?? this.employee_id,
      partner_id: partner_id ?? this.partner_id,
      order_type: order_type ?? this.order_type,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      tax_amount: tax_amount ?? this.tax_amount,
      discount_amount: discount_amount ?? this.discount_amount,
      price_addition_amount:
          price_addition_amount ?? this.price_addition_amount,
      price_reduction_amount:
          price_reduction_amount ?? this.price_reduction_amount,
      total_amount: total_amount ?? this.total_amount,
      final_paying_price: final_paying_price ?? this.final_paying_price,
      fulfillment_date: fulfillment_date ?? this.fulfillment_date,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      items: items ?? this.items,
    );
  }
}
