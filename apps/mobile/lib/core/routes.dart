import 'package:flutter/material.dart';
import 'package:mobile/features/auth/pages/login_page.dart';
import 'package:mobile/features/auth/pages/onboarding_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String onboarding = '/onboarding';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginPage(),
    onboarding: (context) => const OnboardingPage(),
  };
}
