import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';
import 'package:mobile/features/pos_kds/order.model.dart';
import 'package:mobile/features/pos_kds/table.model.dart';
import 'package:mobile/features/pos_kds/kitchen_order_ticket.model.dart';
import 'package:mobile/features/pos_kds/advance_payment.model.dart';

class PosKdsEndpoints {
  static const String orders = '/pos-kds/orders';
  static String order(String id) => '/pos-kds/orders/$id';
  static String payOrder(String id) => '/pos-kds/orders/$id/pay';
  static String refundOrder(String id) => '/pos-kds/orders/$id/refund';
  static String cancelOrder(String id) => '/pos-kds/orders/$id/cancel';
  
  static const String tables = '/pos-kds/tables';
  static String table(String id) => '/pos-kds/tables/$id';
  
  static const String kots = '/pos-kds/kots';
  static String kot(String id) => '/pos-kds/kots/$id';
  static String kotStatus(String id) => '/pos-kds/kots/$id/status';
  
  static const String payments = '/pos-kds/payments';
  static String payment(String id) => '/pos-kds/payments/$id';
}

class PosKdsRepo {
  final ApiClient _apiClient;

  PosKdsRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<List<OrderModel>> listOrders() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(PosKdsEndpoints.orders);
      final data = response.data['data'] as List;
      return data.map((e) => OrderModel.fromJson(e)).toList();
    });
  }

  TaskResult<OrderModel> createOrder(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(PosKdsEndpoints.orders, data: data);
      return OrderModel.fromJson(response.data['data']);
    });
  }

  TaskResult<OrderModel> getOrder(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(PosKdsEndpoints.order(id));
      return OrderModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> payOrder(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(PosKdsEndpoints.payOrder(id), data: data);
      return response.data['data'];
    });
  }

  TaskResult<dynamic> refundOrder(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(PosKdsEndpoints.refundOrder(id));
      return response.data['data'];
    });
  }

  TaskResult<dynamic> cancelOrder(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(PosKdsEndpoints.cancelOrder(id));
      return response.data['data'];
    });
  }

  TaskResult<List<TableModel>> listTables() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(PosKdsEndpoints.tables);
      final data = response.data['data'] as List;
      return data.map((e) => TableModel.fromJson(e)).toList();
    });
  }

  TaskResult<TableModel> createTable(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(PosKdsEndpoints.tables, data: data);
      return TableModel.fromJson(response.data['data']);
    });
  }

  TaskResult<TableModel> updateTable(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(PosKdsEndpoints.table(id), data: data);
      return TableModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> deleteTable(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.delete(PosKdsEndpoints.table(id));
      return response.data['data'];
    });
  }

  TaskResult<List<KitchenOrderTicketModel>> listKOTs() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(PosKdsEndpoints.kots);
      final data = response.data['data'] as List;
      return data.map((e) => KitchenOrderTicketModel.fromJson(e)).toList();
    });
  }

  TaskResult<KitchenOrderTicketModel> getKOT(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(PosKdsEndpoints.kot(id));
      return KitchenOrderTicketModel.fromJson(response.data['data']);
    });
  }

  TaskResult<KitchenOrderTicketModel> updateKOTStatus(String id, String status) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(PosKdsEndpoints.kotStatus(id), data: {'status': status});
      return KitchenOrderTicketModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<AdvancePaymentModel>> listPayments() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(PosKdsEndpoints.payments);
      final data = response.data['data'] as List;
      return data.map((e) => AdvancePaymentModel.fromJson(e)).toList();
    });
  }

  TaskResult<AdvancePaymentModel> getPayment(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(PosKdsEndpoints.payment(id));
      return AdvancePaymentModel.fromJson(response.data['data']);
    });
  }
}
