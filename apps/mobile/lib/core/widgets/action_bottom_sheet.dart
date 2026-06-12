import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';

class BottomSheetAction {
  final String label;
  final IconData icon;
  final Color? labelColor;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool isLoading;
  final VoidCallback onTap;

  BottomSheetAction({
    required this.label,
    required this.icon,
    this.labelColor,
    this.backgroundColor,
    this.iconColor,
    this.isLoading = false,
    required this.onTap,
  });
}

class ActionBottomSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<BottomSheetAction> actions;

  const ActionBottomSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom + 20.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12.h),
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E0E0),
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.keyboard_double_arrow_left, color: AppColors.textPrimary, size: 24.w),
                ),
                SizedBox(width: 8.w),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          ...actions.map((action) => Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
            child: GestureDetector(
              onTap: action.isLoading ? null : action.onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    decoration: BoxDecoration(
                      color: action.backgroundColor ?? const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      action.label,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: action.labelColor ?? AppColors.textPrimary,
                      ),
                    ),
                  ),
                  action.isLoading
                      ? SizedBox(
                          width: 16.w,
                          height: 16.h,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                action.iconColor ?? AppColors.primaryGreen),
                          ),
                        )
                      : Icon(
                          action.icon,
                          color: action.iconColor ?? AppColors.primaryGreen,
                          size: 24.w,
                        ),
                ],
              ),
            ),
          )),
        ],
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<BottomSheetAction> actions,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ActionBottomSheet(
          title: title,
          subtitle: subtitle,
          actions: actions,
        );
      },
    );
  }
}
