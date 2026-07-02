import 'package:user/services/api_client.dart';
import 'package:user/utils/try_catch.dart';
import 'order.model.dart';

class OrderRepo {
  final ApiClient _apiClient;

  OrderRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<void> placeOrder(CreateOrderRequest request) async {
    return tryCatchAsync(() async {
      await _apiClient.post('/api/v1/orders', data: request.toJson());
    });
  }
}
