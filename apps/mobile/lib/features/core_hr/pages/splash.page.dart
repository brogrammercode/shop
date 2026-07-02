import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/services/json_cache.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final JsonCache _cache = JsonCache();

  @override
  void initState() {
    super.initState();
    _routeOptimistically();
  }

  Future<void> _routeOptimistically() async {
    // 1. Read local cache extremely fast
    final savedProfile = await _cache.getSavedProfile();
    final hasProfile = savedProfile != null && savedProfile['user'] != null;

    if (!hasProfile) {
      // Not logged in -> go to login
      if (mounted) Navigator.pushReplacementNamed(context, AppRoutes.login);
      return;
    }

    final hasEmployee = savedProfile['employee'] != null;
    final businessContext = await _cache.getBusinessContext();
    final hasBusinessContext =
        businessContext != null && businessContext.isNotEmpty;

    // 2. Fire background validation that will silently sync or force logout on failure
    if (mounted) {
      context.read<CoreHrCubit>().verifySessionInBackground();
    }

    // 3. Route instantly based on cached info
    if (mounted) {
      if (!hasEmployee || !hasBusinessContext) {
        Navigator.pushReplacementNamed(context, AppRoutes.crossRoad);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // A simple, elegant splash screen
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', width: 120.w, height: 120.w),
            SizedBox(height: 24.h),
            SizedBox(
              height: 20.h,
              width: 20.h,
              child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF22C55E)),
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
