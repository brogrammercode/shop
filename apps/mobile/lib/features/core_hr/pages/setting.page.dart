import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/components/ui/dialog.dart';import 'package:mobile/components/ui/loader.dart';


class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoreHrCubit, CoreHrState>(
      listenWhen: (previous, current) => previous.logoutInfo.status != current.logoutInfo.status,
      listener: (context, state) {
        if (state.logoutInfo.status == OperationStatus.success) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.h),
                      Text(
                        'ACCOUNT',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textTertiary,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _buildLogoutTile(context, isLoggingOut),
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
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
          ),
          SizedBox(width: 16.w),
          Text(
            'Settings',
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

  Widget _buildLogoutTile(BuildContext context, bool isLoggingOut) {
    return GestureDetector(
      onTap: isLoggingOut
          ? null
          : () async {
              final confirm = await AppDialog.showConfirmation(
                context: context,
                title: 'Log Out',
                message: 'Are you sure you want to log out?',
                confirmText: 'Log out',
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
                'Log Out',
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
}
