import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/di.dart';
import 'package:mobile/features/auth/pages/login_page.dart';
import 'package:mobile/features/auth/pages/onboarding_page.dart';
import 'package:mobile/features/auth/pages/session_page.dart';
import 'package:mobile/features/business/pages/create_branch_page.dart';
import 'package:mobile/features/business/pages/create_business_page.dart';
import 'package:mobile/features/business/pages/dashboard_page.dart';
import 'package:mobile/features/business/pages/find_business_page.dart';
import 'package:mobile/features/business/pages/pending_join_page.dart';
import 'package:mobile/features/order/cubit/counter_sale_cubit.dart';
import 'package:mobile/features/order/pages/counter_sale_page.dart';
import 'package:mobile/features/product/cubit/product_cubit.dart';
import 'package:mobile/features/product/pages/product_form_page.dart';
import 'package:mobile/features/product/pages/product_list_page.dart';

class AppRoutes {
  static const String session = '/';
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String createBusiness = '/create-business';
  static const String createBranch = '/create-branch';
  static const String findBusiness = '/find-business';
  static const String pendingJoin = '/pending-join';
  static const String dashboard = '/dashboard';
  static const String products = '/products';
  static const String productForm = '/product-form';
  static const String counterSale = '/counter-sale';

  static Map<String, WidgetBuilder> get routes => {
    session: (context) => const SessionPage(),
    login: (context) => const LoginPage(),
    onboarding: (context) => const OnboardingPage(),
    createBusiness: (context) => const CreateBusinessPage(),
    createBranch: (context) => const CreateBranchPage(),
    findBusiness: (context) => const FindBusinessPage(),
    pendingJoin: (context) => const PendingJoinPage(),
    dashboard: (context) => const DashboardPage(),
    products: (context) => BlocProvider<ProductCubit>(
      create: (context) => AppDependencies.productCubit(),
      child: const ProductListPage(),
    ),
    productForm: (context) => BlocProvider<ProductCubit>(
      create: (context) => AppDependencies.productCubit(),
      child: const ProductFormPage(),
    ),
    counterSale: (context) => BlocProvider<CounterSaleCubit>(
      create: (context) => AppDependencies.counterSaleCubit(),
      child: const CounterSalePage(),
    ),
  };
}
