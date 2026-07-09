import 'package:mobile/features/catalog/models/menu_item.model.dart';
import 'package:mobile/features/catalog/models/menu_item_sale_mode.model.dart';

class PosCartLineModel {
  final String id;
  final String menu_item_id;
  final String sale_mode_id;
  final String sale_mode_label;
  final String quantity_uom_id;
  final String quantity_uom_code;
  final double quantity;
  final double unit_price;
  final double min_qty;
  final double step_qty;
  final bool allow_decimal;
  final MenuItemModel item;

  const PosCartLineModel({
    required this.id,
    required this.menu_item_id,
    required this.sale_mode_id,
    required this.sale_mode_label,
    required this.quantity_uom_id,
    required this.quantity_uom_code,
    required this.quantity,
    required this.unit_price,
    required this.min_qty,
    required this.step_qty,
    required this.allow_decimal,
    required this.item,
  });

  factory PosCartLineModel.fromItem({
    required MenuItemModel item,
    required MenuItemSaleModeModel saleMode,
  }) {
    final lineId = '${item.id}:${saleMode.id}';
    return PosCartLineModel(
      id: lineId,
      menu_item_id: item.id,
      sale_mode_id: saleMode.id,
      sale_mode_label: saleMode.label,
      quantity_uom_id: saleMode.uom_id,
      quantity_uom_code: saleMode.uom_code,
      quantity: saleMode.min_qty,
      unit_price: saleMode.price_per_unit,
      min_qty: saleMode.min_qty,
      step_qty: saleMode.step_qty,
      allow_decimal: saleMode.allow_decimal,
      item: item,
    );
  }

  double get total => quantity * unit_price;

  PosCartLineModel copyWith({
    double? quantity,
    MenuItemModel? item,
  }) {
    return PosCartLineModel(
      id: id,
      menu_item_id: menu_item_id,
      sale_mode_id: sale_mode_id,
      sale_mode_label: sale_mode_label,
      quantity_uom_id: quantity_uom_id,
      quantity_uom_code: quantity_uom_code,
      quantity: quantity ?? this.quantity,
      unit_price: unit_price,
      min_qty: min_qty,
      step_qty: step_qty,
      allow_decimal: allow_decimal,
      item: item ?? this.item,
    );
  }
}
