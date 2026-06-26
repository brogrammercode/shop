import 'package:flutter/material.dart';
import 'package:mobile/features/auth/pages/login_page.dart';
import 'package:mobile/features/auth/pages/session_page.dart';
import 'package:mobile/features/home/pages/home_page.dart';
import 'package:mobile/features/business/pages/join_branch_page.dart';
import 'package:mobile/features/business/pages/create_branch_page.dart';
import 'package:mobile/features/product/pages/products_page.dart';
import 'package:mobile/features/product/pages/category_page.dart';
import 'package:mobile/features/product/pages/category_detail_page.dart';
import 'package:mobile/features/product/pages/create_category_page.dart';
import 'package:mobile/features/product/pages/create_sub_category_page.dart';
import 'package:mobile/features/product/pages/create_product_page.dart';
import 'package:mobile/features/product/pages/product_detail_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String session = '/session';
  static const String joinBranch = '/join-branch';
  static const String createBranch = '/create-branch';

  static const String products = '/products';
  static const String categories = '/categories';
  static const String categoryDetail = '/category-detail';
  static const String createCategory = '/create-category';
  static const String createSubCategory = '/create-sub-category';
  static const String createProduct = '/create-product';
  static const String productDetail = '/product-detail';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomePage(),
    login: (context) => const LoginPage(),
    session: (context) => const SessionPage(),
    joinBranch: (context) => const JoinBranchPage(),
    createBranch: (context) => const CreateBranchPage(),
    products: (context) => const ProductsPage(),
    categories: (context) => const CategoryPage(),
    categoryDetail: (context) {
      final categoryId = ModalRoute.of(context)!.settings.arguments as String;
      return CategoryDetailPage(categoryId: categoryId);
    },
    createCategory: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        return CreateCategoryPage(
          branchId: args['branchId'] ?? '',
          categoryToEdit: args['category'],
        );
      }
      return CreateCategoryPage(branchId: args as String? ?? '');
    },
    createSubCategory: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        return CreateSubCategoryPage(
          categoryId: args['categoryId'] ?? '',
          subCategoryToEdit: args['subCategory'],
        );
      }
      return CreateSubCategoryPage(categoryId: args as String? ?? '');
    },
    createProduct: (context) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args is Map<String, dynamic>) {
        return CreateProductPage(
          branchId: args['branchId'] ?? '',
          productToEdit: args['product'],
          isSubProduct: args['isSubProduct'] ?? false,
          parentProductId: args['parentProductId'],
          parentProductLinkedIds: args['parentProductLinkedIds'] != null ? List<String>.from(args['parentProductLinkedIds']) : null,
        );
      }
      return CreateProductPage(branchId: args as String? ?? '');
    },
    productDetail: (context) {
      final productId = ModalRoute.of(context)!.settings.arguments as String;
      return ProductDetailPage(productId: productId);
    },
  };
}
