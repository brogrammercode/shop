import 'package:flutter/material.dart';
import 'package:mobile/features/auth/pages/login_page.dart';
import 'package:mobile/features/auth/pages/onboarding_page.dart';
import 'package:mobile/features/auth/pages/edit_profile_page.dart';
import 'package:mobile/features/setting/pages/setting_page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String onboarding = '/onboarding';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String editProfile = '/edit-profile';
  static const String joinGang = '/join-gang';
  static const String createGang = '/create-gang';
  static const String editGang = '/edit-gang';
  static const String playerList = '/player-list';
  static const String editPlayer = '/edit-player';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginPage(),
    onboarding: (context) => const OnboardingPage(),
    settings: (context) => const SettingPage(),
    editProfile: (context) => const EditProfilePage(),
  };
}
