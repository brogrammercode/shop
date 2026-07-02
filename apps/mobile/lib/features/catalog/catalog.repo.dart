import 'package:mobile/services/api_client.dart';
import 'package:mobile/utils/try_catch.dart';
import 'package:mobile/features/catalog/menu_category.model.dart';
import 'package:mobile/features/catalog/menu_item.model.dart';
import 'package:mobile/features/catalog/modifier_group.model.dart';
import 'package:mobile/features/catalog/modifier.model.dart';
import 'package:mobile/features/catalog/combo_meal.model.dart';

class CatalogEndpoints {
  static const String publicMenu = '/catalog/menu';
  static const String categories = '/catalog/categories';
  static String category(String id) => '/catalog/categories/$id';
  static const String items = '/catalog/items';
  static String item(String id) => '/catalog/items/$id';
  static const String modifierGroups = '/catalog/modifier-groups';
  static const String modifiers = '/catalog/modifiers';
  static String modifiersByGroup(String groupId) => '/catalog/modifier-groups/$groupId/modifiers';
  static String modifier(String id) => '/catalog/modifiers/$id';
  static const String comboMeals = '/catalog/combo-meals';
  static String comboMeal(String id) => '/catalog/combo-meals/$id';
  static String comboItem(String comboId, String itemId) => '/catalog/combo-meals/$comboId/items/$itemId';
  static String addComboItem(String comboId) => '/catalog/combo-meals/$comboId/items';
}

class CatalogRepo {
  final ApiClient _apiClient;

  CatalogRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<dynamic> getPublicMenu(String branchId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get('${CatalogEndpoints.publicMenu}?branch_id=$branchId');
      return response.data['data'];
    });
  }

  TaskResult<List<MenuCategoryModel>> listCategories() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CatalogEndpoints.categories);
      final data = response.data['data'] as List;
      return data.map((e) => MenuCategoryModel.fromJson(e)).toList();
    });
  }

  TaskResult<MenuCategoryModel> createCategory(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CatalogEndpoints.categories, data: data);
      return MenuCategoryModel.fromJson(response.data['data']);
    });
  }

  TaskResult<MenuCategoryModel> updateCategory(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(CatalogEndpoints.category(id), data: data);
      return MenuCategoryModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> deleteCategory(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.delete(CatalogEndpoints.category(id));
      return response.data['data'];
    });
  }

  TaskResult<List<MenuItemModel>> listItems() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CatalogEndpoints.items);
      final data = response.data['data'] as List;
      return data.map((e) => MenuItemModel.fromJson(e)).toList();
    });
  }

  TaskResult<MenuItemModel> createItem(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CatalogEndpoints.items, data: data);
      return MenuItemModel.fromJson(response.data['data']);
    });
  }

  TaskResult<MenuItemModel> updateItem(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(CatalogEndpoints.item(id), data: data);
      return MenuItemModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> deleteItem(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.delete(CatalogEndpoints.item(id));
      return response.data['data'];
    });
  }

  TaskResult<List<ModifierGroupModel>> listModifierGroups() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CatalogEndpoints.modifierGroups);
      final data = response.data['data'] as List;
      return data.map((e) => ModifierGroupModel.fromJson(e)).toList();
    });
  }

  TaskResult<ModifierGroupModel> createModifierGroup(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CatalogEndpoints.modifierGroups, data: data);
      return ModifierGroupModel.fromJson(response.data['data']);
    });
  }

  TaskResult<List<ModifierModel>> listModifiersByGroup(String groupId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CatalogEndpoints.modifiersByGroup(groupId));
      final data = response.data['data'] as List;
      return data.map((e) => ModifierModel.fromJson(e)).toList();
    });
  }

  TaskResult<ModifierModel> createModifier(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CatalogEndpoints.modifiers, data: data);
      return ModifierModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ModifierModel> updateModifier(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(CatalogEndpoints.modifier(id), data: data);
      return ModifierModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> deleteModifier(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.delete(CatalogEndpoints.modifier(id));
      return response.data['data'];
    });
  }

  TaskResult<List<ComboMealModel>> listComboMeals() async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(CatalogEndpoints.comboMeals);
      final data = response.data['data'] as List;
      return data.map((e) => ComboMealModel.fromJson(e)).toList();
    });
  }

  TaskResult<ComboMealModel> createComboMeal(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CatalogEndpoints.comboMeals, data: data);
      return ComboMealModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ComboMealModel> updateComboMeal(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.patch(CatalogEndpoints.comboMeal(id), data: data);
      return ComboMealModel.fromJson(response.data['data']);
    });
  }

  TaskResult<dynamic> deleteComboMeal(String id) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.delete(CatalogEndpoints.comboMeal(id));
      return response.data['data'];
    });
  }

  TaskResult<dynamic> addComboItem(String comboId, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(CatalogEndpoints.addComboItem(comboId), data: data);
      return response.data['data'];
    });
  }

  TaskResult<dynamic> removeComboItem(String comboId, String itemId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.delete(CatalogEndpoints.comboItem(comboId, itemId));
      return response.data['data'];
    });
  }
}
