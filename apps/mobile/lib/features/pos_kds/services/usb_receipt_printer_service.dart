import 'package:flutter/services.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:mobile/features/pos_kds/models/order.model.dart';
import 'package:mobile/features/pos_kds/services/receipt_print_formatter.dart';
import 'package:mobile/features/pos_kds/services/receipt_printer_exception.dart';

typedef ReceiptPrinterLogSink = void Function(String message);

class UsbPrinterDevice {
  final int vendorId;
  final int productId;
  final String deviceName;
  final String manufacturerName;
  final String productName;
  final bool hasPermission;
  final bool isEpson;
  final bool isPrinterCandidate;

  const UsbPrinterDevice({
    required this.vendorId,
    required this.productId,
    required this.deviceName,
    required this.manufacturerName,
    required this.productName,
    required this.hasPermission,
    required this.isEpson,
    required this.isPrinterCandidate,
  });

  factory UsbPrinterDevice.fromMap(Map<dynamic, dynamic> value) {
    return UsbPrinterDevice(
      vendorId: value[PosConstant.USB_VENDOR_ID_KEY] as int? ?? 0,
      productId: value[PosConstant.USB_PRODUCT_ID_KEY] as int? ?? 0,
      deviceName: value[PosConstant.USB_DEVICE_NAME_KEY]?.toString() ?? '',
      manufacturerName:
          value[PosConstant.USB_MANUFACTURER_NAME_KEY]?.toString() ?? '',
      productName: value[PosConstant.USB_PRODUCT_NAME_KEY]?.toString() ?? '',
      hasPermission:
          value[PosConstant.USB_HAS_PERMISSION_KEY] as bool? ?? false,
      isEpson: value[PosConstant.USB_IS_EPSON_KEY] as bool? ?? false,
      isPrinterCandidate:
          value[PosConstant.USB_IS_PRINTER_CANDIDATE_KEY] as bool? ?? false,
    );
  }

  String get debugLabel {
    return '${PosConstant.USB_VENDOR_ID_KEY}=$vendorId, ${PosConstant.USB_PRODUCT_ID_KEY}=$productId, ${PosConstant.USB_DEVICE_NAME_KEY}=$deviceName, ${PosConstant.USB_MANUFACTURER_NAME_KEY}=$manufacturerName, ${PosConstant.USB_PRODUCT_NAME_KEY}=$productName, ${PosConstant.USB_HAS_PERMISSION_KEY}=$hasPermission, ${PosConstant.USB_IS_EPSON_KEY}=$isEpson, ${PosConstant.USB_IS_PRINTER_CANDIDATE_KEY}=$isPrinterCandidate';
  }
}

class UsbReceiptPrinterService {
  final MethodChannel _channel;
  final ReceiptPrintFormatter _formatter;

  const UsbReceiptPrinterService({
    MethodChannel channel = const MethodChannel(
      PosConstant.USB_PRINTER_CHANNEL,
    ),
    ReceiptPrintFormatter formatter = const ReceiptPrintFormatter(),
  }) : _channel = channel,
       _formatter = formatter;

  Future<List<UsbPrinterDevice>> listUsbPrinters({
    ReceiptPrinterLogSink? onLog,
  }) async {
    final devices = await _listUsbDevices(onLog: onLog);
    final printers = devices
        .where((device) => device.isPrinterCandidate)
        .toList();
    onLog?.call(
      '${PosConstant.PRINT_LOG_USB_PRINTER_COUNT}: ${printers.length}',
    );
    if (printers.isEmpty) {
      onLog?.call(PosConstant.PRINT_LOG_NO_USB_PRINTERS);
    }
    return printers;
  }

  Future<List<UsbPrinterDevice>> _listUsbDevices({
    ReceiptPrinterLogSink? onLog,
  }) async {
    try {
      onLog?.call(PosConstant.PRINT_LOG_CHECKING_USB_DEVICES);
      final result = await _channel.invokeMethod<List<dynamic>>(
        PosConstant.USB_LIST_DEVICES_METHOD,
      );
      final devices = (result ?? const [])
          .map(
            (value) => UsbPrinterDevice.fromMap(value as Map<dynamic, dynamic>),
          )
          .toList();
      onLog?.call(
        '${PosConstant.PRINT_LOG_USB_DEVICE_COUNT}: ${devices.length}',
      );
      for (var index = 0; index < devices.length; index += 1) {
        onLog?.call(
          '${PosConstant.PRINT_LOG_USB_DEVICE} ${index + 1}: ${devices[index].debugLabel}',
        );
      }
      if (devices.isEmpty) {
        onLog?.call(PosConstant.PRINT_LOG_NO_USB_PRINTERS);
      }
      return devices;
    } on PlatformException catch (error) {
      onLog?.call(
        '${PosConstant.PRINT_LOG_METHOD_CHANNEL_ERROR}: ${error.code}',
      );
      throw ReceiptPrinterException(_mapError(error));
    }
  }

  Future<bool> requestUsbPermission({ReceiptPrinterLogSink? onLog}) async {
    try {
      onLog?.call(PosConstant.PRINT_LOG_REQUESTING_USB_PERMISSION);
      final result = await _channel.invokeMethod<bool>(
        PosConstant.USB_REQUEST_PERMISSION_METHOD,
      );
      final granted = result ?? false;
      onLog?.call(
        granted
            ? PosConstant.PRINT_LOG_USB_PERMISSION_GRANTED
            : PosConstant.PRINT_LOG_USB_PERMISSION_DENIED,
      );
      return granted;
    } on PlatformException catch (error) {
      onLog?.call(
        '${PosConstant.PRINT_LOG_METHOD_CHANNEL_ERROR}: ${error.code}',
      );
      throw ReceiptPrinterException(_mapError(error));
    }
  }

  Future<void> printReceiptBytes(
    List<int> bytes, {
    ReceiptPrinterLogSink? onLog,
  }) async {
    try {
      onLog?.call('${PosConstant.PRINT_LOG_SENDING_BYTES}: ${bytes.length}');
      await _channel.invokeMethod<void>(PosConstant.USB_PRINT_BYTES_METHOD, {
        PosConstant.USB_BYTES_ARG: bytes,
      });
      onLog?.call(PosConstant.PRINT_LOG_NATIVE_WRITE_COMPLETE);
    } on PlatformException catch (error) {
      onLog?.call(
        '${PosConstant.PRINT_LOG_METHOD_CHANNEL_ERROR}: ${error.code}',
      );
      throw ReceiptPrinterException(_mapError(error));
    }
  }

  Future<void> printTestReceipt({ReceiptPrinterLogSink? onLog}) async {
    await _preparePrinter(onLog: onLog);
    onLog?.call(PosConstant.PRINT_LOG_FORMATTING_TEST);
    final bytes = _formatter.formatTestReceipt(DateTime.now());
    onLog?.call('${PosConstant.PRINT_LOG_RECEIPT_BYTES}: ${bytes.length}');
    await printReceiptBytes(bytes, onLog: onLog);
  }

  Future<void> printOrderReceipt(
    OrderModel order, {
    ReceiptPrinterLogSink? onLog,
    int copies = PosConstant.PRINT_BILL_SINGLE_COPIES,
  }) async {
    await _preparePrinter(onLog: onLog);
    onLog?.call(PosConstant.PRINT_LOG_FORMATTING_ORDER);
    final bytes = await _formatter.formatOrderReceiptCopies(
      order,
      copies: copies,
    );
    onLog?.call('${PosConstant.PRINT_LOG_RECEIPT_BYTES}: ${bytes.length}');
    await printReceiptBytes(bytes, onLog: onLog);
  }

  Future<void> _preparePrinter({ReceiptPrinterLogSink? onLog}) async {
    final printers = await listUsbPrinters(onLog: onLog);
    if (printers.isEmpty) {
      throw const ReceiptPrinterException(
        PosConstant.PRINTER_NOT_CONNECTED_MESSAGE,
      );
    }
    final permissionGranted = await requestUsbPermission(onLog: onLog);
    if (!permissionGranted) {
      throw const ReceiptPrinterException(
        PosConstant.USB_PERMISSION_DENIED_MESSAGE,
      );
    }
  }

  String _mapError(PlatformException error) {
    switch (error.code) {
      case PosConstant.USB_ERROR_PERMISSION_DENIED:
        return PosConstant.USB_PERMISSION_DENIED_MESSAGE;
      case PosConstant.USB_ERROR_PRINTER_NOT_CONNECTED:
        return PosConstant.PRINTER_NOT_CONNECTED_MESSAGE;
      case PosConstant.USB_ERROR_EPSON_NOT_DETECTED:
        return PosConstant.UNABLE_TO_DETECT_EPSON_MESSAGE;
      default:
        return PosConstant.PRINTING_FAILED_MESSAGE;
    }
  }
}
