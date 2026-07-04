import 'package:flutter/material.dart';
import 'package:mobile/core/color.dart';

class AppRefresher extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefresher({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primaryGreen,
      backgroundColor: AppColors.pureWhite,
      strokeWidth: 2.5,
      displacement: 40.0,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
