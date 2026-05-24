import 'package:flutter/material.dart';
import 'package:user/features/home/pages/home_page.dart';
import 'package:user/features/home/pages/search_page.dart';
import 'package:user/features/home/pages/search_result.dart';
import 'package:user/features/store/pages/store_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String search = '/search';
  static const String searchResult = '/search-result';
  static const String store = '/store';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomePage(),
    search: (context) => const SearchPage(),
    searchResult: (context) => const SearchResultPage(),
    store: (context) => const StorePage(),
  };
}
