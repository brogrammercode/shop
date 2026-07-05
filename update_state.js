const fs = require('fs');

const statePath = 'apps/mobile/lib/features/pos_kds/controllers/pos_kds.state.dart';
let stateCode = fs.readFileSync(statePath, 'utf8');

// Add lastPlacedOrder to PosKdsState
stateCode = stateCode.replace(
  'final OperationInfo savePaymentsInfo;',
  'final OperationInfo savePaymentsInfo;\n  final OrderModel? lastPlacedOrder;'
);

stateCode = stateCode.replace(
  'this.savePaymentsInfo = const OperationInfo(),',
  'this.savePaymentsInfo = const OperationInfo(),\n    this.lastPlacedOrder,'
);

stateCode = stateCode.replace(
  'OperationInfo? savePaymentsInfo,',
  'OperationInfo? savePaymentsInfo,\n    OrderModel? lastPlacedOrder,'
);

stateCode = stateCode.replace(
  'savePaymentsInfo: savePaymentsInfo ?? this.savePaymentsInfo,',
  'savePaymentsInfo: savePaymentsInfo ?? this.savePaymentsInfo,\n      lastPlacedOrder: lastPlacedOrder ?? this.lastPlacedOrder,'
);

stateCode = stateCode.replace(
  'savePaymentsInfo,',
  'savePaymentsInfo,\n        lastPlacedOrder,'
);

fs.writeFileSync(statePath, stateCode);

const cubitPath = 'apps/mobile/lib/features/pos_kds/controllers/pos_kds.cubit.dart';
let cubitCode = fs.readFileSync(cubitPath, 'utf8');

// Update createOrder in cubit to save lastPlacedOrder
cubitCode = cubitCode.replace(
  /        \(\_\) \{\s*Fluttertoast\.showToast\(msg: 'Order created'\);\s*emit\(\s*state\.copyWith\(\s*saveOrdersInfo: const OperationInfo\(\s*status: OperationStatus\.success,\s*\),\s*\),\s*\);\s*\}/,
  `        (order) {
          Fluttertoast.showToast(msg: 'Order created');
          emit(
            state.copyWith(
              saveOrdersInfo: const OperationInfo(
                status: OperationStatus.success,
              ),
              lastPlacedOrder: order,
            ),
          );
        }`
);

fs.writeFileSync(cubitPath, cubitCode);

console.log('Added lastPlacedOrder');
