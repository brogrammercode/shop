import 'package:mobile/features/catalog/models/menu_item.model.dart';

class OrderItemModel {
  final String id;
  final String branch_id;
  final String order_id;
  final String menu_item_id;
  final String sale_mode_id;
  final double qty;
  final double unit_price;
  final double total_price;
  final String sale_mode_label;
  final String quantity_uom_id;
  final String quantity_uom_code;
  final double base_quantity;
  final String base_uom_id;
  final String base_uom_code;
  final String notes;
  final String created_at;
  final String updated_at;
  final MenuItemModel? menu_item;

  const OrderItemModel({
    required this.id,
    required this.branch_id,
    required this.order_id,
    required this.menu_item_id,
    required this.sale_mode_id,
    required this.qty,
    required this.unit_price,
    required this.total_price,
    required this.sale_mode_label,
    required this.quantity_uom_id,
    required this.quantity_uom_code,
    required this.base_quantity,
    required this.base_uom_id,
    required this.base_uom_code,
    required this.notes,
    required this.created_at,
    required this.updated_at,
    this.menu_item,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      order_id: json['order_id'] ?? '',
      menu_item_id: json['menu_item_id'] ?? '',
      sale_mode_id: json['sale_mode_id'] ?? '',
      qty: (json['qty'] as num?)?.toDouble() ?? 0.0,
      unit_price: (json['unit_price'] as num?)?.toDouble() ?? 0.0,
      total_price: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      sale_mode_label: json['sale_mode_label'] ?? '',
      quantity_uom_id: json['quantity_uom_id'] ?? '',
      quantity_uom_code: json['quantity_uom_code'] ?? '',
      base_quantity: (json['base_quantity'] as num?)?.toDouble() ?? 0.0,
      base_uom_id: json['base_uom_id'] ?? '',
      base_uom_code: json['base_uom_code'] ?? '',
      notes: json['notes'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      menu_item: json['menu_item'] != null
          ? MenuItemModel.fromJson(json['menu_item'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'order_id': order_id,
      'menu_item_id': menu_item_id,
      'sale_mode_id': sale_mode_id,
      'qty': qty,
      'unit_price': unit_price,
      'total_price': total_price,
      'sale_mode_label': sale_mode_label,
      'quantity_uom_id': quantity_uom_id,
      'quantity_uom_code': quantity_uom_code,
      'base_quantity': base_quantity,
      'base_uom_id': base_uom_id,
      'base_uom_code': base_uom_code,
      'notes': notes,
      'created_at': created_at,
      'updated_at': updated_at,
      'menu_item': menu_item?.toJson(),
    };
  }

  OrderItemModel copyWith({
    String? id,
    String? branch_id,
    String? order_id,
    String? menu_item_id,
    String? sale_mode_id,
    double? qty,
    double? unit_price,
    double? total_price,
    String? sale_mode_label,
    String? quantity_uom_id,
    String? quantity_uom_code,
    double? base_quantity,
    String? base_uom_id,
    String? base_uom_code,
    String? notes,
    String? created_at,
    String? updated_at,
    MenuItemModel? menu_item,
  }) {
    return OrderItemModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      order_id: order_id ?? this.order_id,
      menu_item_id: menu_item_id ?? this.menu_item_id,
      sale_mode_id: sale_mode_id ?? this.sale_mode_id,
      qty: qty ?? this.qty,
      unit_price: unit_price ?? this.unit_price,
      total_price: total_price ?? this.total_price,
      sale_mode_label: sale_mode_label ?? this.sale_mode_label,
      quantity_uom_id: quantity_uom_id ?? this.quantity_uom_id,
      quantity_uom_code: quantity_uom_code ?? this.quantity_uom_code,
      base_quantity: base_quantity ?? this.base_quantity,
      base_uom_id: base_uom_id ?? this.base_uom_id,
      base_uom_code: base_uom_code ?? this.base_uom_code,
      notes: notes ?? this.notes,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      menu_item: menu_item ?? this.menu_item,
    );
  }
}
