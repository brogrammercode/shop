class ProductEndpoints {
  static const String list = '/product';

  static String detail(String id) {
    return '/product/$id';
  }
}
