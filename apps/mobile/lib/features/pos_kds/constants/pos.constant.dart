class PosConstant {
  // Table Management
  static const String TABLE_ZONE_TITLE = 'Table Zones';
  static const String CREATE_ZONE = 'Create Zone';
  static const String TABLE_LIST_TITLE = 'Floor Plan';
  static const String FILTER_BY_ZONE = 'Filter by Zone...';

  // POS Terminal
  static const String POS_TITLE = 'POS Terminal';
  static const String CATALOG_TAB = 'Menu / Catalog';
  static const String CART_TAB = 'Current Order';
  static const String ORDER_TYPE = 'Order Type';
  static const String TABLE_ORDER = 'Table (Dine-in)';
  static const String TAKEAWAY_ORDER = 'Takeaway';
  static const String ONLINE_ORDER = 'Online/Delivery';
  static const String SELECT_CHAIR = 'Select Chair / Side';
  static const String SELECT_PARTNER = 'Delivery Partner';
  static const String SEND_TO_KITCHEN = 'Send KOT';
  static const String GENERATE_BILL = 'Generate Bill & Pay';

  // Orders
  static const String ORDER_LIST_TITLE = 'All Orders';
  static const String ORDER_DETAIL_TITLE = 'Order Receipt';
  static const String PRINT_BILL = 'Print Bill';
  static const String PRINT_TEST_BILL = 'Test Print';
  static const String PRINT_LOG_TITLE = 'Print Log';
  static const String PRINT_LOG_EMPTY =
      'Print logs will appear here while printing.';
  static const String PRINT_LOG_STARTED = 'Receipt print started.';
  static const String PRINT_LOG_TEST_STARTED = 'Test print started.';
  static const String PRINT_LOG_CHECKING_USB_DEVICES =
      'Checking Android USB devices.';
  static const String PRINT_LOG_USB_DEVICE_COUNT = 'Connected USB device count';
  static const String PRINT_LOG_USB_PRINTER_COUNT =
      'Printable USB device count';
  static const String PRINT_LOG_USB_DEVICE = 'USB device';
  static const String PRINT_LOG_NO_USB_PRINTERS =
      'No printable USB devices returned by Android.';
  static const String PRINT_LOG_REQUESTING_USB_PERMISSION =
      'Requesting USB permission.';
  static const String PRINT_LOG_USB_PERMISSION_GRANTED =
      'USB permission granted.';
  static const String PRINT_LOG_USB_PERMISSION_DENIED =
      'USB permission denied by Android.';
  static const String PRINT_LOG_FORMATTING_ORDER =
      'Formatting order receipt bytes.';
  static const String PRINT_LOG_FORMATTING_TEST =
      'Formatting test receipt bytes.';
  static const String PRINT_LOG_RECEIPT_BYTES = 'Receipt byte count';
  static const String PRINT_LOG_SENDING_BYTES = 'Sending bytes to Android USB.';
  static const String PRINT_LOG_NATIVE_WRITE_COMPLETE =
      'Android USB bulk write completed.';
  static const String PRINT_LOG_PRINT_SUCCESS = 'Print flow completed.';
  static const String PRINT_LOG_PRINT_FAILED = 'Print flow failed';
  static const String PRINT_LOG_METHOD_CHANNEL_ERROR =
      'Android MethodChannel error';
  static const String REFUND = 'Refund';
  static const String MARK_FULFILLED = 'Mark Fulfilled';
  static const String RECEIPT_LOGO_ASSET = 'assets/logo_transparent.png';
  static const String RECEIPT_BUSINESS_NAME = 'LadyLuck Foods';
  static const String RECEIPT_DISPLAY_NAME = 'LadyLuck';
  static const String RECEIPT_SUBTITLE = 'Sweets, Fast Food & Restaurant';
  static const String RECEIPT_ADDRESS =
      'RHMTB Barari, Bhagalpur, Bihar, 812003';
  static const String RECEIPT_PHONE_LABEL = 'Phone/WhatsApp';
  static const String RECEIPT_PHONE = '7782832940';
  static const String RECEIPT_INSTAGRAM_LABEL = 'Instagram';
  static const String RECEIPT_INSTAGRAM = 'ladyluckfoods';
  static const String RECEIPT_ORDER_LABEL = 'Order No';
  static const String RECEIPT_DATE_LABEL = 'Date';
  static const String RECEIPT_ORDER_ID_LABEL = 'Order ID';
  static const String RECEIPT_CUSTOMER_LABEL = 'Customer';
  static const String RECEIPT_CUSTOMER_PHONE_LABEL = 'Phone';
  static const String RECEIPT_CUSTOMER_EMAIL_LABEL = 'Email';
  static const String RECEIPT_DELIVERY_ADDRESS_LABEL = 'Address';
  static const String RECEIPT_TABLE_LABEL = 'Table';
  static const String RECEIPT_TABLE_SIDES_LABEL = 'Table Sides';
  static const String RECEIPT_ORDER_TYPE_LABEL = 'Order Type';
  static const String RECEIPT_PAYMENT_STATUS_LABEL = 'Payment Status';
  static const String RECEIPT_ITEM_HEADER = 'ITEM';
  static const String RECEIPT_QTY_HEADER = 'QTY';
  static const String RECEIPT_RATE_HEADER = 'RATE';
  static const String RECEIPT_TOTAL_HEADER = 'TOTAL';
  static const String RECEIPT_ITEM_FALLBACK = 'Item';
  static const String RECEIPT_SUBTOTAL_LABEL = 'Subtotal';
  static const String RECEIPT_DISCOUNT_LABEL = 'Discount';
  static const String RECEIPT_TAX_LABEL = 'Tax/GST';
  static const String RECEIPT_TOTAL_AMOUNT_LABEL = 'Total Amount';
  static const String RECEIPT_FINAL_PAYING_LABEL = 'Final Paying';
  static const String RECEIPT_GRAND_TOTAL_LABEL = 'Grand Total';
  static const String RECEIPT_THANK_YOU = 'THANK YOU FOR YOUR ORDER';
  static const String RECEIPT_FOOTER = 'Where every bite feels lucky';
  static const String RECEIPT_RUPEE_SYMBOL = 'Rs.';
  static const String RECEIPT_RUPEE_FALLBACK = 'Rs.';
  static const String RECEIPT_AM = 'AM';
  static const String RECEIPT_PM = 'PM';
  static const String RECEIPT_SEPARATOR =
      '------------------------------------------------';
  static const String USB_PRINT_TEST_TITLE = 'USB Print Test';
  static const String PRINTER_NOT_CONNECTED_MESSAGE =
      'Printer not connected. Please connect Epson printer using OTG.';
  static const String USB_PERMISSION_DENIED_MESSAGE = 'USB permission denied.';
  static const String UNABLE_TO_DETECT_EPSON_MESSAGE =
      'Unable to detect Epson printer.';
  static const String PRINTING_FAILED_MESSAGE =
      'Printing failed. Please check printer power, paper roll, and USB cable.';
  static const String RECEIPT_PRINT_SUCCESS_MESSAGE =
      'Receipt printed successfully.';
  static const String USB_PRINTER_CHANNEL = 'mobile/usb_receipt_printer';
  static const String USB_LIST_DEVICES_METHOD = 'listUsbDevices';
  static const String USB_LIST_PRINTERS_METHOD = 'listUsbPrinters';
  static const String USB_REQUEST_PERMISSION_METHOD = 'requestUsbPermission';
  static const String USB_PRINT_BYTES_METHOD = 'printReceiptBytes';
  static const String USB_BYTES_ARG = 'bytes';
  static const String USB_VENDOR_ID_KEY = 'vendorId';
  static const String USB_PRODUCT_ID_KEY = 'productId';
  static const String USB_DEVICE_NAME_KEY = 'deviceName';
  static const String USB_MANUFACTURER_NAME_KEY = 'manufacturerName';
  static const String USB_PRODUCT_NAME_KEY = 'productName';
  static const String USB_HAS_PERMISSION_KEY = 'hasPermission';
  static const String USB_IS_EPSON_KEY = 'isEpson';
  static const String USB_IS_PRINTER_CANDIDATE_KEY = 'isPrinterCandidate';
  static const String USB_ERROR_PERMISSION_DENIED = 'USB_PERMISSION_DENIED';
  static const String USB_ERROR_PRINTER_NOT_CONNECTED = 'PRINTER_NOT_CONNECTED';
  static const String USB_ERROR_EPSON_NOT_DETECTED = 'EPSON_NOT_DETECTED';
  static const bool RECEIPT_USE_RUPEE_SYMBOL = false;
  static const int RECEIPT_PAPER_COLUMNS = 48;
  static const int RECEIPT_NAME_WIDTH = 31;
  static const int RECEIPT_QTY_WIDTH = 5;
  static const int RECEIPT_RATE_WIDTH = 0;
  static const int RECEIPT_TOTAL_WIDTH = 10;
  static const int RECEIPT_END_FEED_LINES = 8;
  static const int RECEIPT_QR_SIZE = 6;
  static const int RECEIPT_LINE_SPACING = 36;
  static const int RECEIPT_LOGO_WIDTH = 360;
  static const int RECEIPT_LOGO_MAX_HEIGHT = 82;
  static const int RECEIPT_LOGO_ALPHA_THRESHOLD = 12;
  static const int RECEIPT_LOGO_CROP_PADDING = 2;
  static const int RECEIPT_PAID_STAMP_WIDTH = 360;
  static const int RECEIPT_PAID_STAMP_HEIGHT = 140;
  static const int RECEIPT_IMAGE_THRESHOLD = 210;

  // Payments & Deliveries
  static const String ADVANCE_PAYMENT_TITLE = 'Advance Payment';
  static const String AMOUNT = 'Payment Amount';
  static const String PAYMENT_METHOD = 'Payment Method';
  static const String RECORD_PAYMENT = 'Record Payment';
  static const String PARTNER_LIST_TITLE = 'Delivery Partners';

  // KDS
  static const String KDS_TITLE = 'Kitchen Display (KDS)';
  static const String MARK_PREPARING = 'Preparing';
  static const String MARK_READY = 'Ready to Serve';
}
