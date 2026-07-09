class MenuItemSaleModeModel {
  final String id;
  final String branch_id;
  final String menu_item_id;
  final String uom_id;
  final String uom_code;
  final String label;
  final double price_per_unit;
  final double min_qty;
  final double step_qty;
  final bool allow_decimal;
  final bool is_default;
  final int sort_order;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const MenuItemSaleModeModel({
    required this.id,
    required this.branch_id,
    required this.menu_item_id,
    required this.uom_id,
    required this.uom_code,
    required this.label,
    required this.price_per_unit,
    required this.min_qty,
    required this.step_qty,
    required this.allow_decimal,
    required this.is_default,
    required this.sort_order,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory MenuItemSaleModeModel.fromJson(Map<String, dynamic> json) {
    return MenuItemSaleModeModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      menu_item_id: json['menu_item_id'] ?? '',
      uom_id: json['uom_id'] ?? '',
      uom_code: json['uom']?['code'] ?? json['uom_code'] ?? '',
      label: json['label'] ?? '',
      price_per_unit: (json['price_per_unit'] as num?)?.toDouble() ?? 0.0,
      min_qty: (json['min_qty'] as num?)?.toDouble() ?? 1.0,
      step_qty: (json['step_qty'] as num?)?.toDouble() ?? 1.0,
      allow_decimal: json['allow_decimal'] ?? false,
      is_default: json['is_default'] ?? false,
      sort_order: (json['sort_order'] as num?)?.toInt() ?? 0,
      status: json['status'] ?? '',
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
      is_deleted: json['is_deleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'branch_id': branch_id,
      'menu_item_id': menu_item_id,
      'uom_id': uom_id,
      'uom_code': uom_code,
      'label': label,
      'price_per_unit': price_per_unit,
      'min_qty': min_qty,
      'step_qty': step_qty,
      'allow_decimal': allow_decimal,
      'is_default': is_default,
      'sort_order': sort_order,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  MenuItemSaleModeModel copyWith({
    String? id,
    String? branch_id,
    String? menu_item_id,
    String? uom_id,
    String? uom_code,
    String? label,
    double? price_per_unit,
    double? min_qty,
    double? step_qty,
    bool? allow_decimal,
    bool? is_default,
    int? sort_order,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return MenuItemSaleModeModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      menu_item_id: menu_item_id ?? this.menu_item_id,
      uom_id: uom_id ?? this.uom_id,
      uom_code: uom_code ?? this.uom_code,
      label: label ?? this.label,
      price_per_unit: price_per_unit ?? this.price_per_unit,
      min_qty: min_qty ?? this.min_qty,
      step_qty: step_qty ?? this.step_qty,
      allow_decimal: allow_decimal ?? this.allow_decimal,
      is_default: is_default ?? this.is_default,
      sort_order: sort_order ?? this.sort_order,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
