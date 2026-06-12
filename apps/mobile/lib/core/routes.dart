import 'package:flutter/material.dart';
import 'package:mobile/features/auth/pages/login_page.dart';
import 'package:mobile/features/auth/pages/session_page.dart';
import 'package:mobile/features/home/pages/home_page.dart';
import 'package:mobile/features/business/pages/join_branch_page.dart';
import 'package:mobile/features/business/pages/create_branch_page.dart';

class AppRoutes {
  static const String home = '/';
  static const String login = '/login';
  static const String session = '/session';
  static const String joinBranch = '/join-branch';
  static const String createBranch = '/create-branch';

  static Map<String, WidgetBuilder> get routes => {
    home: (context) => const HomePage(),
    login: (context) => const LoginPage(),
    session: (context) => const SessionPage(),
    joinBranch: (context) => const JoinBranchPage(),
    createBranch: (context) => const CreateBranchPage(),
  };
}

