import 'package:flutter/material.dart';
import 'package:mobile/features/auth/pages/login_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginPage(),
  };
}
