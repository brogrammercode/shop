import 'package:mobile/features/order/models/cart_item_model.dart';
import 'package:mobile/features/order/models/receipt_model.dart';
import 'package:mobile/features/order/repo/order_endpoints.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';

class OrderRepo {
  final ApiClient _apiClient;

  OrderRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<ReceiptModel> createCounterOrder({
    required String branch_id,
    required List<CartItemModel> items,
  }) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        OrderEndpoints.counterOrder,
        data: {
          'branch_id': branch_id,
          'payment_method': 'UPI',
          'items': items.map((item) => item.toCounterJson()).toList(),
        },
      );
      final data = _unwrapResponseData(response.data);
      return ReceiptModel.fromJson(Map<String, dynamic>.from(data));
    });
  }

  TaskResult<ReceiptModel> getReceipt(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(OrderEndpoints.receipt(id));
      final data = _unwrapResponseData(response.data);
      return ReceiptModel.fromJson(Map<String, dynamic>.from(data));
    });
  }

  dynamic _unwrapResponseData(dynamic responseData) {
    if (responseData is Map<String, dynamic> &&
        responseData.containsKey('data')) {
      return responseData['data'];
    }

    return responseData;
  }
}
