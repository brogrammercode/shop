import 'package:flutter/material.dart';
import 'package:mobile/features/auth/pages/login_page.dart';
import 'package:mobile/features/auth/pages/session_page.dart';
import 'package:mobile/features/business/pages/business_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String session = '/session';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const BusinessPage(),
    login: (context) => const LoginPage(),
    session: (context) => const SessionPage(),
  };
}

