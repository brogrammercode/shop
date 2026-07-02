import 'package:user/services/api_client.dart';
import 'package:user/utils/try_catch.dart';
import 'menu.model.dart';
import 'store.constant.dart';

class StoreRepo {
  final ApiClient _apiClient;

  StoreRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<List<MenuCategory>> getMenu() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(StoreConstants.MENU_ENDPOINT);
      final List<dynamic> data = response.data['data'] as List<dynamic>;
      return data.map((json) => MenuCategory.fromJson(json as Map<String, dynamic>)).toList();
    });
  }
}
