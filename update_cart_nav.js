const fs = require('fs');

const cartPath = 'apps/mobile/lib/features/pos_kds/pos.cart.page.dart';
let cartCode = fs.readFileSync(cartPath, 'utf8');

cartCode = cartCode.replace(
  "import 'package:mobile/services/api_client.dart';",
  "import 'package:mobile/services/api_client.dart';\nimport 'package:mobile/features/pos_kds/pos.receipt.page.dart';"
);

cartCode = cartCode.replace(
  "Navigator.pop(context); // Go back to POS Terminal on success",
  "Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const PosReceiptPage()));"
);

// We need to fix the DropdownButton because tables might be empty.
// If tables is empty, we should handle it gracefully without crashing.
cartCode = cartCode.replace(
  "items: posState.tables.map((TableModel table) {",
  "items: posState.tables.isEmpty ? null : posState.tables.map((TableModel table) {"
);

fs.writeFileSync(cartPath, cartCode);

console.log('Cart page updated');
