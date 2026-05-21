class OrderEndpoints {
  static const String counterOrder = '/order/counter/orders';

  static String receipt(String id) {
    return '/order/orders/$id/receipt';
  }
}
