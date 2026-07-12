import 'dart:convert';
import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:mobile/constants/api.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';
import 'package:mobile/features/pos_kds/models/order.model.dart';
import 'package:mobile/features/pos_kds/services/order_display_formatter.dart';

class ReceiptPrintFormatter {
  const ReceiptPrintFormatter();

  List<int> formatTestReceipt(DateTime dateTime) {
    final bytes = <int>[];
    _initialize(bytes);
    _fontA(bytes);
    _center(bytes);
    _bold(bytes, true);
    _doubleSize(bytes, true);
    _line(bytes, PosConstant.RECEIPT_DISPLAY_NAME);
    _doubleSize(bytes, false);
    _line(bytes, PosConstant.USB_PRINT_TEST_TITLE);
    _bold(bytes, false);
    _line(bytes, _formatDateTime(dateTime.toLocal()));
    _feed(bytes, PosConstant.RECEIPT_END_FEED_LINES);
    _cut(bytes);
    return bytes;
  }

  Future<List<int>> formatOrderReceipt(OrderModel order) async {
    final bytes = <int>[];
    _initialize(bytes);
    _fontA(bytes);
    _center(bytes);
    await _logo(bytes);
    _bold(bytes, true);
    _doubleSize(bytes, true);
    _line(bytes, 'ORDER #${order.order_no}');
    _doubleSize(bytes, false);
    _blank(bytes);
    _line(bytes, PosConstant.RECEIPT_DISPLAY_NAME);
    _bold(bytes, false);
    _line(bytes, PosConstant.RECEIPT_SUBTITLE);
    _wrapCenter(bytes, PosConstant.RECEIPT_ADDRESS);
    _blank(bytes);
    _wrapCenter(
      bytes,
      '${PosConstant.RECEIPT_ORDER_ID_LABEL}: ${order.id.toUpperCase()}',
    );
    _line(
      bytes,
      '${PosConstant.RECEIPT_DATE_LABEL.toUpperCase()}: ${_formatOrderDate(order.created_at)}',
    );
    _separator(bytes);
    if (order.status.toUpperCase() == 'PAID') {
      await _paidStamp(bytes);
      _reverseFeedDots(bytes, PosConstant.RECEIPT_PAID_STAMP_HEIGHT);
    }
    _left(bytes);
    _field(
      bytes,
      'TYPE',
      OrderDisplayFormatter.orderTypeLabel(order.order_type),
    );
    _table(bytes, order);
    if (order.user != null) {
      _field(
        bytes,
        PosConstant.RECEIPT_CUSTOMER_LABEL.toUpperCase(),
        order.user!.name,
      );
      _field(
        bytes,
        PosConstant.RECEIPT_CUSTOMER_PHONE_LABEL.toUpperCase(),
        order.user!.phone,
      );
      _field(
        bytes,
        PosConstant.RECEIPT_CUSTOMER_EMAIL_LABEL.toUpperCase(),
        order.user!.email,
      );
    }
    _field(
      bytes,
      PosConstant.RECEIPT_DELIVERY_ADDRESS_LABEL.toUpperCase(),
      _deliveryAddress(order),
    );
    _separator(bytes);
    _bold(bytes, true);
    _line(bytes, _itemHeader());
    _bold(bytes, false);
    _separator(bytes);
    for (final item in order.items) {
      final name =
          item.menu_item?.display_name ??
          '${PosConstant.RECEIPT_ITEM_FALLBACK} ${item.menu_item_id}';
      _item(
        bytes,
        name,
        OrderDisplayFormatter.quantityText(item),
        _formatAmount(item.total_price),
      );
    }
    _separator(bytes);
    _amount(
      bytes,
      PosConstant.RECEIPT_TOTAL_AMOUNT_LABEL.toUpperCase(),
      order.total_amount,
    );
    if (order.subtotal > 0 && order.subtotal != order.total_amount) {
      _amount(
        bytes,
        PosConstant.RECEIPT_SUBTOTAL_LABEL.toUpperCase(),
        order.subtotal,
      );
    }
    if (order.discount_amount > 0) {
      _amount(
        bytes,
        PosConstant.RECEIPT_DISCOUNT_LABEL.toUpperCase(),
        -order.discount_amount,
      );
    }
    if (order.tax_amount > 0) {
      _amount(
        bytes,
        PosConstant.RECEIPT_TAX_LABEL.toUpperCase(),
        order.tax_amount,
      );
    }
    _bold(bytes, true);
    _amount(
      bytes,
      PosConstant.RECEIPT_FINAL_PAYING_LABEL.toUpperCase(),
      _payableAmount(order),
    );
    _bold(bytes, false);
    _separator(bytes);
    _qr(bytes, '${ApiConstants.BASE_URL}/pos-kds/orders/${order.id}');
    _blank(bytes);
    _center(bytes);
    _bold(bytes, true);
    _line(bytes, PosConstant.RECEIPT_THANK_YOU);
    _bold(bytes, false);
    _line(bytes, PosConstant.RECEIPT_FOOTER);
    _feed(bytes, PosConstant.RECEIPT_END_FEED_LINES);
    _cut(bytes);
    return bytes;
  }

  Future<List<int>> formatOrderReceiptCopies(
    OrderModel order, {
    required int copies,
  }) async {
    final bytes = <int>[];
    for (var index = 0; index < copies; index += 1) {
      bytes.addAll(await formatOrderReceipt(order));
    }
    return bytes;
  }

  Future<void> _logo(List<int> bytes) async {
    final image = await _loadAssetImage(
      PosConstant.RECEIPT_LOGO_ASSET,
      targetWidth: PosConstant.RECEIPT_LOGO_WIDTH,
      maxHeight: PosConstant.RECEIPT_LOGO_MAX_HEIGHT,
    );
    if (image == null) {
      return;
    }
    try {
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      final rgbaBytes = byteData?.buffer.asUint8List();
      if (rgbaBytes == null) {
        return;
      }
      _raster(bytes, rgbaBytes, image.width, image.height);
      _blank(bytes);
    } finally {
      image.dispose();
    }
  }

  Future<void> _paidStamp(List<int> bytes) async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final width = PosConstant.RECEIPT_PAID_STAMP_WIDTH.toDouble();
    final height = PosConstant.RECEIPT_PAID_STAMP_HEIGHT.toDouble();
    final strokePaint = ui.Paint()
      ..color = const ui.Color(0xFF000000)
      ..style = ui.PaintingStyle.stroke
      ..strokeWidth = 5;
    canvas.translate(width / 2, height / 2);
    canvas.rotate(-0.42);
    final rect = ui.Rect.fromCenter(
      center: ui.Offset.zero,
      width: width * 0.72,
      height: height * 0.48,
    );
    canvas.drawRRect(
      ui.RRect.fromRectAndRadius(rect, const ui.Radius.circular(12)),
      strokePaint,
    );
    final paragraphBuilder =
        ui.ParagraphBuilder(ui.ParagraphStyle(textAlign: ui.TextAlign.center))
          ..pushStyle(
            ui.TextStyle(
              color: const ui.Color(0xFF000000),
              fontSize: 68,
              fontWeight: ui.FontWeight.w900,
              letterSpacing: 8,
            ),
          )
          ..addText('PAID');
    final paragraph = paragraphBuilder.build()
      ..layout(ui.ParagraphConstraints(width: rect.width));
    canvas.drawParagraph(
      paragraph,
      ui.Offset(-rect.width / 2, -paragraph.height / 2),
    );
    final image = await recorder.endRecording().toImage(
      width.toInt(),
      height.toInt(),
    );
    try {
      final byteData = await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      final rgbaBytes = byteData?.buffer.asUint8List();
      if (rgbaBytes == null) {
        return;
      }
      _center(bytes);
      _raster(bytes, rgbaBytes, image.width, image.height);
      _left(bytes);
    } finally {
      image.dispose();
    }
  }

  Future<ui.Image?> _loadAssetImage(
    String path, {
    required int targetWidth,
    required int maxHeight,
  }) async {
    try {
      final data = await rootBundle.load(path);
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      final sourceImage = frame.image;
      try {
        final byteData = await sourceImage.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        );
        final rgbaBytes = byteData?.buffer.asUint8List();
        if (rgbaBytes == null) {
          return sourceImage;
        }
        final crop = _opaqueBounds(
          rgbaBytes,
          sourceImage.width,
          sourceImage.height,
        );
        final cropWidth = crop.width;
        final cropHeight = crop.height;
        var outputWidth = targetWidth;
        var outputHeight = (cropHeight * outputWidth / cropWidth).round();
        if (outputHeight > maxHeight) {
          outputHeight = maxHeight;
          outputWidth = (cropWidth * outputHeight / cropHeight).round();
        }
        final recorder = ui.PictureRecorder();
        final canvas = ui.Canvas(recorder);
        final sourceRect = ui.Rect.fromLTWH(
          crop.left.toDouble(),
          crop.top.toDouble(),
          crop.width.toDouble(),
          crop.height.toDouble(),
        );
        final targetRect = ui.Rect.fromLTWH(
          0,
          0,
          outputWidth.toDouble(),
          outputHeight.toDouble(),
        );
        canvas.drawImageRect(sourceImage, sourceRect, targetRect, ui.Paint());
        return recorder.endRecording().toImage(outputWidth, outputHeight);
      } finally {
        sourceImage.dispose();
      }
    } catch (_) {
      return null;
    }
  }

  _ImageCrop _opaqueBounds(Uint8List rgbaBytes, int width, int height) {
    var minX = width;
    var minY = height;
    var maxX = -1;
    var maxY = -1;
    for (var y = 0; y < height; y += 1) {
      for (var x = 0; x < width; x += 1) {
        final alpha = rgbaBytes[(y * width + x) * 4 + 3];
        if (alpha <= PosConstant.RECEIPT_LOGO_ALPHA_THRESHOLD) {
          continue;
        }
        minX = min(minX, x);
        minY = min(minY, y);
        maxX = max(maxX, x);
        maxY = max(maxY, y);
      }
    }
    if (maxX < minX || maxY < minY) {
      return _ImageCrop(left: 0, top: 0, width: width, height: height);
    }
    final padding = PosConstant.RECEIPT_LOGO_CROP_PADDING;
    final left = max(0, minX - padding);
    final top = max(0, minY - padding);
    final right = min(width - 1, maxX + padding);
    final bottom = min(height - 1, maxY + padding);
    return _ImageCrop(
      left: left,
      top: top,
      width: right - left + 1,
      height: bottom - top + 1,
    );
  }

  void _table(List<int> bytes, OrderModel order) {
    if (!OrderDisplayFormatter.isDineIn(order)) {
      return;
    }
    final table = OrderDisplayFormatter.tableDisplay(order);
    if (table.isEmpty) {
      return;
    }
    _field(bytes, PosConstant.RECEIPT_TABLE_LABEL.toUpperCase(), table);
  }

  String _deliveryAddress(OrderModel order) {
    return OrderDisplayFormatter.deliveryAddress(order);
  }

  void _field(List<int> bytes, String label, String value) {
    final safeValue = _safeText(value).trim();
    if (safeValue.isEmpty) {
      return;
    }
    final prefix = '${_safeText(label)}: ';
    final available = PosConstant.RECEIPT_PAPER_COLUMNS - prefix.length;
    final lines = _wrap(safeValue, available < 12 ? 12 : available);
    for (var index = 0; index < lines.length; index += 1) {
      if (index == 0) {
        _line(bytes, '$prefix${lines[index]}');
      } else {
        _line(bytes, '${''.padLeft(prefix.length)}${lines[index]}');
      }
    }
  }

  void _item(List<int> bytes, String name, String qty, String total) {
    final nameWidth = PosConstant.RECEIPT_NAME_WIDTH;
    final qtyWidth = PosConstant.RECEIPT_QTY_WIDTH;
    final totalWidth = PosConstant.RECEIPT_TOTAL_WIDTH;
    final names = _wrap(name, nameWidth);
    for (var index = 0; index < names.length; index += 1) {
      if (index == 0) {
        _line(
          bytes,
          '${_fit(names[index], nameWidth)} ${_leftPad(qty, qtyWidth)} ${_leftPad(total, totalWidth)}',
        );
      } else {
        _line(bytes, _fit(names[index], nameWidth));
      }
    }
  }

  String _itemHeader() {
    return '${_fit(PosConstant.RECEIPT_ITEM_HEADER, PosConstant.RECEIPT_NAME_WIDTH)} ${_leftPad(PosConstant.RECEIPT_QTY_HEADER, PosConstant.RECEIPT_QTY_WIDTH)} ${_leftPad(PosConstant.RECEIPT_TOTAL_HEADER, PosConstant.RECEIPT_TOTAL_WIDTH)}';
  }

  void _amount(List<int> bytes, String label, double amount) {
    final value = _formatAmount(amount);
    final labelWidth = PosConstant.RECEIPT_PAPER_COLUMNS - value.length;
    _line(bytes, '${_fit(label, labelWidth)}$value');
  }

  double _payableAmount(OrderModel order) {
    if (order.final_paying_price > 0) {
      return order.final_paying_price;
    }
    return order.total_amount;
  }

  String _formatOrderDate(String value) {
    if (value.trim().isEmpty) {
      return _formatDateTime(DateTime.now());
    }
    try {
      return _formatDateTime(DateTime.parse(value).toLocal());
    } catch (_) {
      return value;
    }
  }

  String _formatDateTime(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    final year = value.year.toString();
    final hour = value.hour > 12
        ? value.hour - 12
        : (value.hour == 0 ? 12 : value.hour);
    final minute = value.minute.toString().padLeft(2, '0');
    final marker = value.hour >= 12
        ? PosConstant.RECEIPT_PM
        : PosConstant.RECEIPT_AM;
    return '$day-$month-$year ${hour.toString().padLeft(2, '0')}:$minute $marker';
  }

  String _formatAmount(double value) {
    final prefix = PosConstant.RECEIPT_USE_RUPEE_SYMBOL
        ? PosConstant.RECEIPT_RUPEE_SYMBOL
        : PosConstant.RECEIPT_RUPEE_FALLBACK;
    return '$prefix ${value.toStringAsFixed(2)}';
  }

  List<String> _wrap(String value, int width) {
    final safe = _safeText(value).trim();
    if (safe.isEmpty) {
      return [''];
    }
    final lines = <String>[];
    for (final rawWord in safe.split(RegExp(r'\s+'))) {
      var word = rawWord;
      while (word.length > width) {
        lines.add(word.substring(0, width));
        word = word.substring(width);
      }
      if (word.isEmpty) {
        continue;
      }
      if (lines.isEmpty || lines.last.length + word.length + 1 > width) {
        lines.add(word);
      } else {
        lines[lines.length - 1] = '${lines.last} $word';
      }
    }
    return lines;
  }

  String _fit(String value, int width) {
    final safe = _safeText(value);
    if (safe.length == width) {
      return safe;
    }
    if (safe.length > width) {
      return safe.substring(0, width);
    }
    return safe.padRight(width);
  }

  String _leftPad(String value, int width) {
    final safe = _safeText(value);
    if (safe.length == width) {
      return safe;
    }
    if (safe.length > width) {
      return safe.substring(0, width);
    }
    return safe.padLeft(width);
  }

  String _safeText(String value) {
    return value
        .replaceAll('₹', PosConstant.RECEIPT_RUPEE_FALLBACK)
        .replaceAll('â‚¹', PosConstant.RECEIPT_RUPEE_FALLBACK)
        .replaceAll('•', '-')
        .replaceAll('â€¢', '-')
        .replaceAll('“', '"')
        .replaceAll('”', '"')
        .replaceAll('â€œ', '"')
        .replaceAll('â€', '"')
        .replaceAll('‘', "'")
        .replaceAll('’', "'")
        .replaceAll('â€˜', "'")
        .replaceAll('â€™', "'")
        .split('')
        .map((char) => char.codeUnitAt(0) <= 127 ? char : '?')
        .join();
  }

  void _initialize(List<int> bytes) {
    bytes.addAll([0x1B, 0x40]);
    bytes.addAll([0x1B, 0x33, PosConstant.RECEIPT_LINE_SPACING]);
  }

  void _fontA(List<int> bytes) {
    bytes.addAll([0x1B, 0x4D, 0x00]);
  }

  void _center(List<int> bytes) {
    bytes.addAll([0x1B, 0x61, 0x01]);
  }

  void _left(List<int> bytes) {
    bytes.addAll([0x1B, 0x61, 0x00]);
  }

  void _bold(List<int> bytes, bool value) {
    bytes.addAll([0x1B, 0x45, value ? 0x01 : 0x00]);
  }

  void _doubleSize(List<int> bytes, bool value) {
    bytes.addAll([0x1D, 0x21, value ? 0x11 : 0x00]);
  }

  void _qr(List<int> bytes, String value) {
    final data = latin1.encode(_safeText(value));
    final storeLength = data.length + 3;
    _center(bytes);
    bytes.addAll([0x1D, 0x28, 0x6B, 0x04, 0x00, 0x31, 0x41, 0x32, 0x00]);
    bytes.addAll([
      0x1D,
      0x28,
      0x6B,
      0x03,
      0x00,
      0x31,
      0x43,
      PosConstant.RECEIPT_QR_SIZE,
    ]);
    bytes.addAll([0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x45, 0x31]);
    bytes.addAll([
      0x1D,
      0x28,
      0x6B,
      storeLength & 0xFF,
      (storeLength >> 8) & 0xFF,
      0x31,
      0x50,
      0x30,
      ...data,
    ]);
    bytes.addAll([0x1D, 0x28, 0x6B, 0x03, 0x00, 0x31, 0x51, 0x30]);
    _left(bytes);
  }

  void _raster(List<int> bytes, Uint8List rgbaBytes, int width, int height) {
    final widthBytes = (width + 7) ~/ 8;
    for (var top = 0; top < height; top += 240) {
      final chunkHeight = min(240, height - top);
      final data = Uint8List(widthBytes * chunkHeight);
      for (var y = 0; y < chunkHeight; y += 1) {
        for (var x = 0; x < width; x += 1) {
          final sourceIndex = ((top + y) * width + x) * 4;
          final red = rgbaBytes[sourceIndex];
          final green = rgbaBytes[sourceIndex + 1];
          final blue = rgbaBytes[sourceIndex + 2];
          final alpha = rgbaBytes[sourceIndex + 3] / 255.0;
          final luminance =
              255 -
              ((255 - (0.299 * red + 0.587 * green + 0.114 * blue)) * alpha);
          if (luminance < PosConstant.RECEIPT_IMAGE_THRESHOLD) {
            data[y * widthBytes + (x ~/ 8)] |= 0x80 >> (x % 8);
          }
        }
      }
      bytes.addAll([
        0x1D,
        0x76,
        0x30,
        0x00,
        widthBytes & 0xFF,
        (widthBytes >> 8) & 0xFF,
        chunkHeight & 0xFF,
        (chunkHeight >> 8) & 0xFF,
      ]);
      bytes.addAll(data);
    }
  }

  void _reverseFeedDots(List<int> bytes, int dots) {
    var remaining = dots;
    while (remaining > 0) {
      final chunk = min(255, remaining);
      bytes.addAll([0x1B, 0x6A, chunk]);
      remaining -= chunk;
    }
  }

  void _feed(List<int> bytes, int lines) {
    bytes.addAll([0x1B, 0x64, lines]);
  }

  void _cut(List<int> bytes) {
    bytes.addAll([0x1D, 0x56, 0x00]);
  }

  void _separator(List<int> bytes) {
    _line(bytes, PosConstant.RECEIPT_SEPARATOR);
  }

  void _wrapCenter(List<int> bytes, String value) {
    for (final line in _wrap(value, PosConstant.RECEIPT_PAPER_COLUMNS)) {
      _line(bytes, line);
    }
  }

  void _blank(List<int> bytes) {
    bytes.add(0x0A);
  }

  void _line(List<int> bytes, String value) {
    bytes.addAll(latin1.encode(_safeText(value)));
    bytes.add(0x0A);
  }
}

class _ImageCrop {
  final int left;
  final int top;
  final int width;
  final int height;

  const _ImageCrop({
    required this.left,
    required this.top,
    required this.width,
    required this.height,
  });
}
