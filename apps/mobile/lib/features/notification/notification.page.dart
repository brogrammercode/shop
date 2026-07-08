import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/di.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/notification/models/notification.model.dart';
import 'package:mobile/features/notification/notification.constant.dart';
import 'package:mobile/features/notification/notification.cubit.dart';
import 'package:mobile/features/notification/notification.state.dart';
import 'package:mobile/features/pos_kds/controllers/pos_kds.cubit.dart';
import 'package:mobile/utils/error.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  Timer? _pollingTimer;
  String _dateFilter = NotificationConstant.TODAY;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await context.read<NotificationCubit>().openNotificationPage();
    final interval = await AppDependencies.localStorage
        .getNotificationPollingSeconds();
    if (!mounted) {
      return;
    }
    _pollingTimer?.cancel();
    _pollingTimer = Timer.periodic(Duration(seconds: interval), (_) {
      if (mounted) {
        context.read<NotificationCubit>().listNotifications(silent: true);
      }
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFFFAFAFA),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 24.w,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              NotificationConstant.TITLE,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
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
                Icons.filter_list_rounded,
                color: AppColors.textPrimary,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 32.h),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: AppColors.borderGrey,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  NotificationConstant.FILTERS,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    _buildFilterChip(NotificationConstant.TODAY),
                    SizedBox(width: 8.w),
                    _buildFilterChip(NotificationConstant.PREVIOUS),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String value) {
    final isSelected = _dateFilter == value;
    return GestureDetector(
      onTap: () {
        setState(() => _dateFilter = value);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey,
          ),
        ),
        child: Text(
          value,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  List<AppNotificationModel> _visibleNotifications(
    List<AppNotificationModel> notifications,
  ) {
    return notifications.where((notification) {
      final date = DateTime.tryParse(notification.time)?.toLocal();
      if (date == null) {
        return _dateFilter == NotificationConstant.PREVIOUS;
      }
      final now = DateTime.now();
      final isToday =
          date.year == now.year &&
          date.month == now.month &&
          date.day == now.day;
      if (_dateFilter == NotificationConstant.TODAY) {
        return isToday;
      }
      return !isToday;
    }).toList();
  }

  Future<void> _openNotification(AppNotificationModel notification) async {
    final notificationCubit = context.read<NotificationCubit>();
    final posKdsCubit = context.read<PosKdsCubit>();
    await notificationCubit.markRead(notification.id);
    final orderId = _extractOrderId(notification);
    if (orderId == null) {
      return;
    }
    await posKdsCubit.getOrder(orderId);
    if (mounted && posKdsCubit.state.selectedOrder?.id == orderId) {
      Navigator.pushNamed(context, AppRoutes.orderDetail);
    }
  }

  String? _extractOrderId(AppNotificationModel notification) {
    if (notification.ref_type != NotificationConstant.REF_TYPE_ORDER) {
      return null;
    }
    final uri = Uri.tryParse(notification.ref_link);
    final segments = uri?.pathSegments ?? const [];
    if (segments.isNotEmpty) {
      return segments.last;
    }
    if (notification.ref_link.trim().isNotEmpty) {
      return notification.ref_link.trim();
    }
    return null;
  }

  String _formatTime(String value) {
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) {
      return value;
    }
    final hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final amPm = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $amPm';
  }

  Widget _buildNotificationCard(AppNotificationModel notification) {
    return GestureDetector(
      onTap: () => _openNotification(notification),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: notification.read
                ? AppColors.borderGrey
                : AppColors.primaryGreen,
          ),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38.w,
              height: 38.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryGreen),
              ),
              child: Icon(
                Icons.receipt_long_outlined,
                color: AppColors.primaryGreen,
                size: 18.w,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          notification.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formatTime(notification.time),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    notification.message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  if (state.loadInfo.status == OperationStatus.loading &&
                      state.notifications.isEmpty) {
                    return const Center(
                      child: AppLoader(size: 24, strokeWidth: 2),
                    );
                  }
                  final notifications = _visibleNotifications(
                    state.notifications,
                  );
                  if (notifications.isEmpty) {
                    return Center(
                      child: Text(
                        NotificationConstant.NO_NOTIFICATIONS,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    );
                  }
                  return RefreshIndicator(
                    color: AppColors.primaryGreen,
                    onRefresh: () async {
                      await context
                          .read<NotificationCubit>()
                          .listNotifications();
                    },
                    child: ListView.separated(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                      itemBuilder: (context, index) {
                        return _buildNotificationCard(notifications[index]);
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 12.h),
                      itemCount: notifications.length,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
