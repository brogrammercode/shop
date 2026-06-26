import 'package:flutter/material.dart';
import 'package:mobile/features/core_hr/auth.page.dart';
import 'package:mobile/features/core_hr/home_layout.page.dart';
import 'package:mobile/features/core_hr/join_branch.page.dart';

class AppRoutes {
  static const String login = '/login';
  static const String home = '/home';
  static const String joinBranch = '/join-branch';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const AuthPage(),
    home: (context) => const HomeLayoutPage(),
    joinBranch: (context) => const JoinBranchPage(),
  };
}
