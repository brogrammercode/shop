// Auto-generated Model file for ComboItem

class ComboItemModel {
  final String id;
  final String combo_id;
  final String menu_item_id;
  final double qty_included;
  final String created_at;
  final String updated_at;

  const ComboItemModel({
    required this.id,
    required this.combo_id,
    required this.menu_item_id,
    required this.qty_included,
    required this.created_at,
    required this.updated_at,
  });

  factory ComboItemModel.fromJson(Map<String, dynamic> json) {
    return ComboItemModel(
      id: json['id'] ?? '',
      combo_id: json['combo_id'] ?? '',
      menu_item_id: json['menu_item_id'] ?? '',
      qty_included: json['qty_included'] ?? 0.0,
      created_at: json['created_at'] ?? '',
      updated_at: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'combo_id': combo_id,
      'menu_item_id': menu_item_id,
      'qty_included': qty_included,
      'created_at': created_at,
      'updated_at': updated_at,
    };
  }

  ComboItemModel copyWith({
    String? id,
    String? combo_id,
    String? menu_item_id,
    double? qty_included,
    String? created_at,
    String? updated_at,
  }) {
    return ComboItemModel(
      id: id ?? this.id,
      combo_id: combo_id ?? this.combo_id,
      menu_item_id: menu_item_id ?? this.menu_item_id,
      qty_included: qty_included ?? this.qty_included,
      created_at: created_at ?? this.created_at,
      updated_at: updated_at ?? this.updated_at,
    );
  }
}
