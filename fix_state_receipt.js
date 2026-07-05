const fs = require('fs');

const statePath = 'apps/mobile/lib/features/pos_kds/controllers/pos_kds.state.dart';
let stateCode = fs.readFileSync(statePath, 'utf8');

stateCode = stateCode.replace(
  'final OperationInfo loadPaymentsInfo;',
  'final OperationInfo loadPaymentsInfo;\n  final OrderModel? lastPlacedOrder;'
);

stateCode = stateCode.replace(
  '    this.loadPaymentsInfo = const OperationInfo(\n      status: OperationStatus.initial,\n    ),\n  });',
  '    this.loadPaymentsInfo = const OperationInfo(\n      status: OperationStatus.initial,\n    ),\n    this.lastPlacedOrder,\n  });'
);

stateCode = stateCode.replace(
  '    OperationInfo? loadPaymentsInfo,\n  }) {',
  '    OperationInfo? loadPaymentsInfo,\n    OrderModel? lastPlacedOrder,\n  }) {'
);

stateCode = stateCode.replace(
  '      loadPaymentsInfo: loadPaymentsInfo ?? this.loadPaymentsInfo,\n    );\n  }',
  '      loadPaymentsInfo: loadPaymentsInfo ?? this.loadPaymentsInfo,\n      lastPlacedOrder: lastPlacedOrder ?? this.lastPlacedOrder,\n    );\n  }'
);

fs.writeFileSync(statePath, stateCode);

const receiptPath = 'apps/mobile/lib/features/pos_kds/pos.receipt.page.dart';
let receiptCode = fs.readFileSync(receiptPath, 'utf8');

// Replace intl import with simple string processing
receiptCode = receiptCode.replace("import 'package:intl/intl.dart';", "");

// Fix DateFormat syntax error and use plain Dart string manipulation
const dateRegex = /'DATE: \\\$\\{DateFormat\('yyyy-MM-dd HH:mm'\)\.format\(DateTime\.parse\(order\.created_at\)\)\}'/g;
receiptCode = receiptCode.replace(dateRegex, "'DATE: \\${DateTime.parse(order.created_at).toLocal().toString().substring(0, 16)}'");

fs.writeFileSync(receiptPath, receiptCode);

console.log('Fixed state and receipt');
