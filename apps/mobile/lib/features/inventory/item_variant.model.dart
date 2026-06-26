// Auto-generated Model file for ItemVariant

class ItemVariantModel {
  final String id;
  final String branch_id;
  final String item_id;
  final String uom_id;
  final String sku;
  final String barcode;
  final double base_cost;
  final double min_stock_lvl;
  final String status;
  final String created_at;
  final String updated_at;
  final bool is_deleted;

  const ItemVariantModel({
    required this.id,
    required this.branch_id,
    required this.item_id,
    required this.uom_id,
    required this.sku,
    required this.barcode,
    required this.base_cost,
    required this.min_stock_lvl,
    required this.status,
    required this.created_at,
    required this.updated_at,
    required this.is_deleted,
  });

  factory ItemVariantModel.fromJson(Map<String, dynamic> json) {
    return ItemVariantModel(
      id: json['id'] ?? '',
      branch_id: json['branch_id'] ?? '',
      item_id: json['item_id'] ?? '',
      uom_id: json['uom_id'] ?? '',
      sku: json['sku'] ?? '',
      barcode: json['barcode'] ?? '',
      base_cost: json['base_cost'] ?? 0.0,
      min_stock_lvl: json['min_stock_lvl'] ?? 0.0,
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
      'item_id': item_id,
      'uom_id': uom_id,
      'sku': sku,
      'barcode': barcode,
      'base_cost': base_cost,
      'min_stock_lvl': min_stock_lvl,
      'status': status,
      'created_at': created_at,
      'updated_at': updated_at,
      'is_deleted': is_deleted,
    };
  }

  ItemVariantModel copyWith({
    String? id,
    String? branch_id,
    String? item_id,
    String? uom_id,
    String? sku,
    String? barcode,
    double? base_cost,
    double? min_stock_lvl,
    String? status,
    String? created_at,
    String? updated_at,
    bool? is_deleted,
  }) {
    return ItemVariantModel(
      id: id ?? this.id,
      branch_id: branch_id ?? this.branch_id,
      item_id: item_id ?? this.item_id,
      uom_id: uom_id ?? this.uom_id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      base_cost: base_cost ?? this.base_cost,
      min_stock_lvl: min_stock_lvl ?? this.min_stock_lvl,
      status: status ?? this.status,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
      is_deleted: is_deleted ?? this.is_deleted,
    );
  }
}
