import 'package:mobile/features/pos_kds/models/order.model.dart';

class TableSideLabelResolver {
  const TableSideLabelResolver._();

  static String display(OrderModel order) {
    if (order.table_side_ids.isEmpty) {
      return '';
    }
    final labels = order.table?.side_labels ?? const [];
    final resolved = <String>[];
    final seen = <String>{};
    for (final value in order.table_side_ids) {
      final side = _resolve(value, order.table_id, labels);
      if (side.isNotEmpty && !seen.contains(side)) {
        seen.add(side);
        resolved.add(side);
      }
    }
    return resolved.join(', ');
  }

  static String _resolve(String value, String tableId, List<String> labels) {
    final side = value.trim();
    if (side.isEmpty) {
      return '';
    }
    if (labels.contains(side)) {
      return side;
    }
    final prefix = '$tableId-';
    if (tableId.isNotEmpty && side.startsWith(prefix)) {
      final index = int.tryParse(side.replaceFirst(prefix, ''));
      if (index != null && index > 0 && labels.length >= index) {
        return labels[index - 1];
      }
    }
    return side;
  }
}
