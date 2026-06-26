// Auto-generated Model file for OrderItem

class OrderItemModel {
  final String id;
  final String branch_id;
  final String order_id;
  final String menu_item_id;
  final double qty;
  final double unit_price;
  final double total_price;
  final String notes;
  final String created_at;
  final String updated_at;

  const OrderItemModel({
    required this.id,
    required this.branch_id,
    required this.order_id,
    required this.menu_item_id,
    required this.qty,
    required this.unit_price,
    required this.total_price,
    required this.notes,
    required this.created_at,
    required this.updated_at,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      order_id: json['order_id'] ?? '',
      menu_item_id: json['menu_item_id'] ?? '',
      qty: json['qty'] ?? 0.0,
      unit_price: json['unit_price'] ?? 0.0,
      total_price: json['total_price'] ?? 0.0,
      notes: json['notes'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'order_id': order_id,
      'menu_item_id': menu_item_id,
      'qty': qty,
      'unit_price': unit_price,
      'total_price': total_price,
      'notes': notes,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  OrderItemModel copyWith({
    String? id,
    String? branch_id,
    String? order_id,
    String? menu_item_id,
    double? qty,
    double? unit_price,
    double? total_price,
    String? notes,
    String? created_at,
    String? updated_at,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      order_id: order_id ?? this.order_id,
      menu_item_id: menu_item_id ?? this.menu_item_id,
      qty: qty ?? this.qty,
      unit_price: unit_price ?? this.unit_price,
      total_price: total_price ?? this.total_price,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
