import 'package:mobile/features/product/models/product_input_model.dart';
import 'package:mobile/features/product/models/product_model.dart';
import 'package:mobile/features/product/repo/product_endpoints.dart';
import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';

class ProductRepo {
  final ApiClient _apiClient;

  ProductRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<List<ProductModel>> getList({
    required String branch_id,
    String search = '',
    bool? available,
  }) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        ProductEndpoints.list,
        queryParameters: {
          'branch_id': branch_id,
          if (search.trim().isNotEmpty) 'search': search.trim(),
          if (available != null) 'available': available.toString(),
        },
      );
      final data = _unwrapResponseData(response.data);
      return (data as List<dynamic>? ?? [])
          .map<ProductModel>(
            (item) => ProductModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList();
    });
  }

  TaskResult<ProductModel> create(ProductInputModel input) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        ProductEndpoints.list,
        data: input.toJson(),
      );
      return ProductModel.fromJson(
        Map<String, dynamic>.from(_unwrapResponseData(response.data)),
      );
    });
  }

  TaskResult<ProductModel> update(String id, ProductInputModel input) async {
    return tryCatchAsync(() async {
      final data = input.toJson();
      data.remove('branch_id');
      final response = await _apiClient.put(
        ProductEndpoints.detail(id),
        data: data,
      );
      return ProductModel.fromJson(
        Map<String, dynamic>.from(_unwrapResponseData(response.data)),
      );
    });
  }

  TaskResult<void> delete(String id) async {
    return tryCatchAsync(() async {
      await _apiClient.delete(ProductEndpoints.detail(id));
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
