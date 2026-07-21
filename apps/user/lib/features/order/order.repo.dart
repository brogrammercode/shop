import 'package:user/services/api_client.dart';
import 'package:user/utils/try_catch.dart';
import 'order.constant.dart';
import 'order.model.dart';

class OrderRepo {
  final ApiClient _apiClient;

  OrderRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<void> placeOrder(CreateOrderRequest request) async {
    return tryCatchAsync(() async {
      await _apiClient.post(OrderConstants.POS_ORDERS_ENDPOINT, data: request.toJson());
    });
  }

  TaskResult<LadyluckSummaryModel> getLadyluckSummary(String branchId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        OrderConstants.LADYLUCK_SUMMARY_ENDPOINT,
        queryParams: {'branch_id': branchId},
      );
      return LadyluckSummaryModel.fromJson(response.data['data'] as Map<String, dynamic>);
    });
  }

  TaskResult<LadyluckDiscountModel> scratchLadyluckCard(String branchId, String scratchCardId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        '${OrderConstants.LADYLUCK_SCRATCH_CARD_ENDPOINT}/$scratchCardId/scratch',
        data: {'branch_id': branchId},
      );
      return LadyluckDiscountModel.fromJson(response.data['data'] as Map<String, dynamic>);
    });
  }
}
