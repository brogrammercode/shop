import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/di.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/notification/notification.cubit.dart';
import 'package:mobile/features/notification/notification.state.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final notificationCubit = context.read<NotificationCubit>();
    await notificationCubit.initializeFirebaseMessaging();
    await notificationCubit.listNotifications(silent: true);
    final interval = await AppDependencies.localStorage
        .getNotificationPollingSeconds();
    if (!mounted) {
      return;
    }
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: interval), (_) {
      if (mounted) {
        notificationCubit.listNotifications(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => Navigator.pushNamed(context, AppRoutes.notifications),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: const BoxDecoration(
                  color: AppColors.pureWhite,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadowColor,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  color: AppColors.textPrimary,
                  size: 20.w,
                ),
              ),
              if (state.unreadCount > 0)
                Positioned(
                  right: -2.w,
                  top: -2.h,
                  child: Container(
                    constraints: BoxConstraints(minWidth: 16.w),
                    height: 16.w,
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEF4F5F),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      state.unreadCount > 9 ? '9+' : '${state.unreadCount}',
                      style: TextStyle(
                        color: AppColors.pureWhite,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
