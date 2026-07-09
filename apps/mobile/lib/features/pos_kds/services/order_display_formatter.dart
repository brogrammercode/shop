import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:mobile/features/pos_kds/models/order.model.dart';
import 'package:mobile/features/pos_kds/models/order_item.model.dart';
import 'package:mobile/features/pos_kds/services/table_side_label_resolver.dart';

class OrderDisplayFormatter {
  const OrderDisplayFormatter._();

  static bool isDineIn(OrderModel order) {
    return order.order_type.toUpperCase() == PosConstant.ORDER_TYPE_DINE_IN;
  }

  static bool isDelivery(OrderModel order) {
    return order.order_type.toUpperCase() == PosConstant.ORDER_TYPE_DELIVERY;
  }

  static bool isTakeaway(OrderModel order) {
    return order.order_type.toUpperCase() == PosConstant.ORDER_TYPE_TAKEAWAY;
  }

  static String orderTypeLabel(String orderType) {
    switch (orderType.toUpperCase()) {
      case PosConstant.ORDER_TYPE_DINE_IN:
        return PosConstant.DINE_IN_LABEL;
      case PosConstant.ORDER_TYPE_DELIVERY:
        return PosConstant.DELIVERY_LABEL;
      case PosConstant.ORDER_TYPE_TAKEAWAY:
        return PosConstant.TAKEAWAY_LABEL;
      default:
        return orderType.replaceAll('_', ' ');
    }
  }

  static String tableDisplay(OrderModel order) {
    final tableName = order.table?.table_number.trim().isNotEmpty == true
        ? order.table!.table_number
        : '';
    final sideNames = TableSideLabelResolver.display(order);
    if (tableName.isNotEmpty && sideNames.isNotEmpty) {
      return 'Table $tableName ($sideNames)';
    }
    if (tableName.isNotEmpty) {
      return 'Table $tableName';
    }
    if (sideNames.isNotEmpty) {
      return 'Sides: $sideNames';
    }
    return '';
  }

  static String deliveryAddress(OrderModel order) {
    if (!isDelivery(order)) {
      return '';
    }
    final addresses = order.user?.addresses ?? const [];
    if (order.delivery_address_id.trim().isNotEmpty) {
      for (final address in addresses) {
        if (address.id == order.delivery_address_id) {
          return addressValue([
            address.area,
            address.locality,
            address.city,
            address.state,
            address.pin_code,
          ]);
        }
      }
    }
    if (addresses.length == 1) {
      final address = addresses.first;
      return addressValue([
        address.area,
        address.locality,
        address.city,
        address.state,
        address.pin_code,
      ]);
    }
    return '';
  }

  static String fulfillmentTitle(OrderModel order) {
    if (isDineIn(order)) {
      final table = tableDisplay(order);
      return table.isEmpty ? PosConstant.DINE_IN_LABEL : table;
    }
    if (isDelivery(order)) {
      return PosConstant.DELIVERY_LABEL;
    }
    if (isTakeaway(order)) {
      return PosConstant.TAKEAWAY_LABEL;
    }
    return PosConstant.FULFILLMENT_LABEL;
  }

  static String fulfillmentSubtitle(OrderModel order) {
    if (isDelivery(order)) {
      final address = deliveryAddress(order);
      return address.isEmpty ? '' : address;
    }
    if (isDineIn(order)) {
      return tableDisplay(order).isEmpty ? '' : PosConstant.DINE_IN_LABEL;
    }
    if (isTakeaway(order)) {
      return '';
    }
    return orderTypeLabel(order.order_type);
  }

  static String addressValue(List<String> parts) {
    return parts.where((part) => part.trim().isNotEmpty).join(', ');
  }

  static String quantityText(OrderItemModel item) {
    final unit = item.quantity_uom_code.trim().isNotEmpty
        ? item.quantity_uom_code.trim()
        : item.base_uom_code.trim();
    final qty = formatQty(item.qty);
    if (unit.isEmpty) {
      return qty;
    }
    return '$qty $unit';
  }

  static String quantityBadge(OrderItemModel item) {
    return quantityText(item);
  }

  static String formatQty(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }
    return value
        .toStringAsFixed(3)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }
}
