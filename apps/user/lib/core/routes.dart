import 'package:flutter/material.dart';
import 'package:user/features/auth/splash_page.dart';
import 'package:user/features/home/home_page.dart';
import 'package:user/features/home/search_page.dart';
import 'package:user/features/home/search_result.dart';
import 'package:user/features/store/store_page.dart';
import 'package:user/features/order/cart_page.dart';
import 'package:user/features/order/payment_page.dart';
import 'package:user/features/setting/setting_page.dart';
import 'package:user/features/auth/login_page.dart';
import 'package:user/features/auth/session_page.dart';
import 'package:user/features/home/food_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String home = '/';
  static const String search = '/search';
  static const String searchResult = '/search-result';
  static const String store = '/store';
  static const String cart = '/cart';
  static const String payment = '/payment';
  static const String setting = '/setting';
  static const String login = '/login';
  static const String session = '/session';
  static const String food = '/food';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashPage(),
    home: (context) => const HomePage(),
    search: (context) => const SearchPage(),
    searchResult: (context) => const SearchResultPage(),
    store: (context) => const StorePage(),
    cart: (context) => const CartPage(),
    payment: (context) => const PaymentPage(),
    setting: (context) => const SettingPage(),
    login: (context) => const LoginPage(),
    session: (context) => const SessionPage(),
    food: (context) => const FoodPage(),
  };
}

