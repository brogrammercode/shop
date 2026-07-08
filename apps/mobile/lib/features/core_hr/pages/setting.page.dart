import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/dialog.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/di.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/features/notification/notification.constant.dart';
import 'package:mobile/utils/error.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _notificationPollingSeconds = 10;
  int _kdsPollingSeconds = 10;
  final List<int> _notificationPollingOptions = const [5, 10, 30, 60, 300];
  final List<int> _kdsPollingOptions = const [10, 30, 60, 300, 600, 900];

  @override
  void initState() {
    super.initState();
    _loadPollingSettings();
  }

  Future<void> _loadPollingSettings() async {
    final notificationSeconds = await AppDependencies.localStorage
        .getNotificationPollingSeconds();
    final kdsSeconds = await AppDependencies.localStorage
        .getKdsPollingSeconds();
    if (!mounted) {
      return;
    }
    setState(() {
      _notificationPollingSeconds = notificationSeconds;
      _kdsPollingSeconds = kdsSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoreHrCubit, CoreHrState>(
      listenWhen: (previous, current) =>
          previous.logoutInfo.status != current.logoutInfo.status,
      listener: (context, state) {
        if (state.logoutInfo.status == OperationStatus.success) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.login,
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        final isLoggingOut = state.logoutInfo.status == OperationStatus.loading;
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).padding.top),
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 24.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      _buildSectionHeader(NotificationConstant.ACCOUNT),
                      SizedBox(height: 12.h),
                      _buildLogoutTile(context, isLoggingOut),
                      SizedBox(height: 24.h),
                      _buildSectionHeader(
                        NotificationConstant.NOTIFICATION_SETTINGS,
                      ),
                      SizedBox(height: 12.h),
                      _buildPollingTile(
                        title: NotificationConstant.NOTIFICATION_POLLING,
                        selectedSeconds: _notificationPollingSeconds,
                        options: _notificationPollingOptions,
                        onSelected: (seconds) async {
                          await AppDependencies.localStorage
                              .saveNotificationPollingSeconds(seconds);
                          if (mounted) {
                            setState(
                              () => _notificationPollingSeconds = seconds,
                            );
                          }
                        },
                      ),
                      SizedBox(height: 12.h),
                      _buildPollingTile(
                        title: NotificationConstant.KDS_POLLING,
                        selectedSeconds: _kdsPollingSeconds,
                        options: _kdsPollingOptions,
                        onSelected: (seconds) async {
                          await AppDependencies.localStorage
                              .saveKdsPollingSeconds(seconds);
                          if (mounted) {
                            setState(() => _kdsPollingSeconds = seconds);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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
          Text(
            NotificationConstant.SETTINGS,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textTertiary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context, bool isLoggingOut) {
    return GestureDetector(
      onTap: isLoggingOut
          ? null
          : () async {
              final confirm = await AppDialog.showConfirmation(
                context: context,
                title: NotificationConstant.LOG_OUT,
                message: NotificationConstant.LOG_OUT_CONFIRM,
                confirmText: NotificationConstant.LOG_OUT_ACTION,
                isDestructive: true,
              );
              if (confirm == true && context.mounted) {
                context.read<CoreHrCubit>().logout();
              }
            },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          border: Border.all(color: AppColors.borderGrey, width: 1.w),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowColor,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              Icons.logout_rounded,
              color: const Color(0xFFEF4F5F),
              size: 20.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                NotificationConstant.LOG_OUT,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFEF4F5F),
                ),
              ),
            ),
            if (isLoggingOut)
              SizedBox(
                width: 16.w,
                height: 16.w,
                child: const AppLoader(size: 24, strokeWidth: 2),
              )
            else
              Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
                size: 18.w,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollingTile({
    required String title,
    required int selectedSeconds,
    required List<int> options,
    required ValueChanged<int> onSelected,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        border: Border.all(color: AppColors.borderGrey, width: 1.w),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: AppColors.textSecondary,
                size: 20.w,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${NotificationConstant.POLLING_SUBTITLE}: ${_formatSeconds(selectedSeconds)}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: options.map((seconds) {
              return _buildPollingChip(
                seconds: seconds,
                selectedSeconds: selectedSeconds,
                onSelected: onSelected,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildPollingChip({
    required int seconds,
    required int selectedSeconds,
    required ValueChanged<int> onSelected,
  }) {
    final isSelected = selectedSeconds == seconds;
    return GestureDetector(
      onTap: () => onSelected(seconds),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F5E9) : AppColors.pureWhite,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey,
          ),
        ),
        child: Text(
          _formatSeconds(seconds),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w800,
            color: isSelected ? AppColors.primaryGreen : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }

  String _formatSeconds(int seconds) {
    if (seconds < 60) {
      return '$seconds ${NotificationConstant.SECONDS_SUFFIX}';
    }
    return '${seconds ~/ 60} ${NotificationConstant.MINUTES_SUFFIX}';
  }
}
