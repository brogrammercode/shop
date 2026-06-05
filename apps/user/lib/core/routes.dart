import 'package:flutter/material.dart';
import 'package:user/features/home/pages/home_page.dart';
import 'package:user/features/home/pages/search_page.dart';
import 'package:user/features/home/pages/search_result.dart';
import 'package:user/features/store/pages/store_page.dart';
import 'package:user/features/order/pages/cart_page.dart';
import 'package:user/features/order/pages/payment_page.dart';
import 'package:user/features/setting/pages/setting_page.dart';
import 'package:user/features/auth/pages/login_page.dart';
import 'package:user/features/home/pages/food_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String searchResult = '/search-result';
  static const String store = '/store';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String setting = '/setting';
  static const String login = '/login';
  static const String food = '/food';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomePage(),
    search: (context) => const SearchPage(),
    searchResult: (context) => const SearchResultPage(),
    store: (context) => const StorePage(),
    cart: (context) => const CartPage(),
    payment: (context) => const PaymentPage(),
    setting: (context) => const SettingPage(),
    login: (context) => const LoginPage(),
    food: (context) => const FoodPage(),
  };
}

