class ReceiptPrinterException implements Exception {
  final String message;

  const ReceiptPrinterException(this.message);

  @override
  String toString() {
    return message;
  }
}
