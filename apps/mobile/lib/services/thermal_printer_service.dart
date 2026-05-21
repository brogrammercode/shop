import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:mobile/features/order/constants/order.dart';
import 'package:mobile/features/order/models/receipt_model.dart';
import 'package:mobile/features/order/models/thermal_printer_model.dart';
import 'package:mobile/utils/error.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';

class ThermalPrinterService {
  Future<List<ThermalPrinterModel>> getPairedPrinters() async {
    await _ensurePermissions();
    final enabled = await PrintBluetoothThermal.bluetoothEnabled;
    if (!enabled) {
      throw const NetworkException(OrderConstants.bluetoothDisabled);
    }

    final devices = await PrintBluetoothThermal.pairedBluetooths;
    return devices
        .map(
          (device) =>
              ThermalPrinterModel(name: device.name, address: device.macAdress),
        )
        .toList();
  }

  Future<void> printDualReceipt({
    required ThermalPrinterModel printer,
    required ReceiptModel receipt,
  }) async {
    await _ensurePermissions();
    final enabled = await PrintBluetoothThermal.bluetoothEnabled;
    if (!enabled) {
      throw const NetworkException(OrderConstants.bluetoothDisabled);
    }

    final connected = await PrintBluetoothThermal.connect(
      macPrinterAddress: printer.address,
    );
    if (!connected) {
      throw const ServerException(OrderConstants.printerConnectionFailed);
    }

    final bytes = await _buildReceiptBytes(receipt);
    final printed = await PrintBluetoothThermal.writeBytes(bytes);
    if (!printed) {
      throw const ServerException(OrderConstants.printerWriteFailed);
    }
  }

  Future<void> _ensurePermissions() async {
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse,
    ].request();

    final allowed = statuses.values.every((status) {
      return status.isGranted || status.isLimited;
    });

    if (!allowed) {
      throw const AuthException(OrderConstants.permissionRequired);
    }
  }

  Future<List<int>> _buildReceiptBytes(ReceiptModel receipt) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    final bytes = <int>[];
    bytes.addAll(
      _buildSingleReceipt(generator, receipt, OrderConstants.packingCopy),
    );
    bytes.addAll(generator.feed(2));
    bytes.addAll(
      _buildSingleReceipt(generator, receipt, OrderConstants.customerCopy),
    );
    bytes.addAll(generator.cut());
    return bytes;
  }

  List<int> _buildSingleReceipt(
    Generator generator,
    ReceiptModel receipt,
    String copyLabel,
  ) {
    final bill = receipt.bill;
    final bytes = <int>[];
    bytes.addAll(
      generator.text(
        receipt.business.name,
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ),
      ),
    );
    bytes.addAll(
      generator.text(
        receipt.branch.name,
        styles: const PosStyles(align: PosAlign.center),
      ),
    );
    bytes.addAll(
      generator.text(
        copyLabel,
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(generator.text('Bill: ${bill?.bill_number ?? receipt.id}'));
    bytes.addAll(generator.text('Date: ${_formatDate(receipt.created_at)}'));
    bytes.addAll(generator.hr());

    for (final item in receipt.items) {
      bytes.addAll(generator.text(item.product.name));
      bytes.addAll(
        generator.row([
          PosColumn(text: '${item.quantity} x ${_money(item.price)}', width: 6),
          PosColumn(
            text: _money(item.total),
            width: 6,
            styles: const PosStyles(align: PosAlign.right),
          ),
        ]),
      );
    }

    bytes.addAll(generator.hr());
    bytes.addAll(
      _amountRow(generator, OrderConstants.subtotalLabel, bill?.sub_total ?? 0),
    );
    bytes.addAll(
      _amountRow(generator, OrderConstants.discountLabel, bill?.discount ?? 0),
    );
    bytes.addAll(
      _amountRow(generator, OrderConstants.taxLabel, bill?.tax ?? 0),
    );
    bytes.addAll(
      generator.row([
        PosColumn(
          text: OrderConstants.totalLabel,
          width: 6,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: _money(bill?.total_amount ?? receipt.total_amount),
          width: 6,
          styles: const PosStyles(align: PosAlign.right, bold: true),
        ),
      ]),
    );
    bytes.addAll(generator.hr());
    bytes.addAll(
      generator.text(
        'Paid: ${bill?.payment_method ?? OrderConstants.paymentMethod}',
      ),
    );
    bytes.addAll(generator.feed(1));
    return bytes;
  }

  List<int> _amountRow(Generator generator, String label, double amount) {
    return generator.row([
      PosColumn(text: label, width: 6),
      PosColumn(
        text: _money(amount),
        width: 6,
        styles: const PosStyles(align: PosAlign.right),
      ),
    ]);
  }

  String _money(double value) {
    return '${OrderConstants.currencySymbol} ${value.toStringAsFixed(2)}';
  }

  String _formatDate(String value) {
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return value;
    }

    return '${parsed.day.toString().padLeft(2, '0')}/${parsed.month.toString().padLeft(2, '0')}/${parsed.year} ${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
  }
}
