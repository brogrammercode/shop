import '../../../services/api_client.dart';
import '../../../utils/try_catch.dart';
import '../constants/product.endpoints.dart';
import '../models/product.dart';
import '../models/product_category.dart';
import '../models/product_sub_category.dart';

class ProductRepo {
  final ApiClient _apiClient;

  ProductRepo({required ApiClient apiClient}) : _apiClient = apiClient;

  TaskResult<List<ProductModel>> getProducts(String branchId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        ProductEndpoints.products,
        queryParams: {'branch_id': branchId},
      );
      final List data = response.data['data'] ?? [];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    });
  }

  TaskResult<ProductModel> createProduct(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        ProductEndpoints.products,
        data: data,
      );
      return ProductModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ProductModel> updateProduct(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.put(
        ProductEndpoints.productDetail.replaceAll('{id}', id),
        data: data,
      );
      return ProductModel.fromJson(response.data['data']);
    });
  }

  TaskResult<void> deleteProduct(String id) async {
    return tryCatchAsync(() async {
      await _apiClient.delete(ProductEndpoints.productDetail.replaceAll('{id}', id));
    });
  }

  TaskResult<List<ProductCategoryModel>> getCategories(String branchId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        ProductEndpoints.categories,
        queryParams: {'branch_id': branchId},
      );
      final List data = response.data['data'] ?? [];
      return data.map((json) => ProductCategoryModel.fromJson(json)).toList();
    });
  }

  TaskResult<ProductCategoryModel> createCategory(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        ProductEndpoints.categories,
        data: data,
      );
      return ProductCategoryModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ProductCategoryModel> updateCategory(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.put(
        ProductEndpoints.categoryDetail.replaceAll('{id}', id),
        data: data,
      );
      return ProductCategoryModel.fromJson(response.data['data']);
    });
  }

  TaskResult<void> deleteCategory(String id) async {
    return tryCatchAsync(() async {
      await _apiClient.delete(ProductEndpoints.categoryDetail.replaceAll('{id}', id));
    });
  }

  TaskResult<List<ProductSubCategoryModel>> getSubCategories(String categoryId) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.get(
        ProductEndpoints.subCategories,
        queryParams: {'category_id': categoryId},
      );
      final List data = response.data['data'] ?? [];
      return data.map((json) => ProductSubCategoryModel.fromJson(json)).toList();
    });
  }

  TaskResult<ProductSubCategoryModel> createSubCategory(Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.post(
        ProductEndpoints.subCategories,
        data: data,
      );
      return ProductSubCategoryModel.fromJson(response.data['data']);
    });
  }

  TaskResult<ProductSubCategoryModel> updateSubCategory(String id, Map<String, dynamic> data) async {
    return tryCatchAsync(() async {
      final response = await _apiClient.put(
        ProductEndpoints.subCategoryDetail.replaceAll('{id}', id),
        data: data,
      );
      return ProductSubCategoryModel.fromJson(response.data['data']);
    });
  }

  TaskResult<void> deleteSubCategory(String id) async {
    return tryCatchAsync(() async {
      await _apiClient.delete(ProductEndpoints.subCategoryDetail.replaceAll('{id}', id));
    });
  }
}
