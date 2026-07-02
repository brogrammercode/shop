import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/core/color.dart';

class BottomSheetTopAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  BottomSheetTopAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}

class BottomSheetAction {
  final String label;
  final IconData icon;
  final Color? labelColor;
  final Color? iconColor;
  final bool isLoading;
  final VoidCallback onTap;

  BottomSheetAction({
    required this.label,
    required this.icon,
    this.labelColor,
    this.iconColor,
    this.isLoading = false,
    required this.onTap,
  });
}

class BottomSheetActionGroup {
  final List<BottomSheetAction> actions;

  BottomSheetActionGroup({required this.actions});
}

class ActionBottomSheet extends StatelessWidget {
  final List<BottomSheetTopAction>? topActions;
  final List<BottomSheetActionGroup> groups;

  const ActionBottomSheet({super.key, this.topActions, required this.groups});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(
          0xFFF4F4F4,
        ), // Exact light gray from screenshot description
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 12.h),
            Center(
              child: Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCDCDC),
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
            ),
            SizedBox(height: 24.h),

            // Top Grid Actions (Row instead of Wrap for exact spacing)
            if (topActions != null && topActions!.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: topActions!.map((action) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        action.onTap();
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: const BoxDecoration(
                              color: AppColors.pureWhite,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              action.icon,
                              color: AppColors.textPrimary,
                              size: 24.w,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            action.label,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 24.h),
            ],

            // Action Groups
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: groups.map((group) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 10.h),
                      decoration: BoxDecoration(
                        color: AppColors.pureWhite,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(group.actions.length, (index) {
                          final action = group.actions[index];
                          return InkWell(
                            onTap: action.isLoading
                                ? null
                                : () {
                                    Navigator.pop(context);
                                    action.onTap();
                                  },
                            borderRadius: BorderRadius.circular(16.r),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 16.h,
                                  ),
                                  child: Row(
                                    children: [
                                      action.isLoading
                                          ? SizedBox(
                                              width: 24.w,
                                              height: 24.w,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(
                                                      action.iconColor ??
                                                          AppColors.textPrimary,
                                                    ),
                                              ),
                                            )
                                          : Icon(
                                              action.icon,
                                              color:
                                                  action.iconColor ??
                                                  const Color(0xFF555555),
                                              size: 20.w,
                                            ),
                                      SizedBox(width: 16.w),
                                      Expanded(
                                        child: Text(
                                          action.label,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                action.labelColor ??
                                                AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (index < group.actions.length - 1)
                                  Divider(
                                    height: 1,
                                    thickness: 1,
                                    color: const Color(0xFFF0F0F0),
                                    indent: 56.w,
                                    endIndent: 0,
                                  ),
                              ],
                            ),
                          );
                        }),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show(
    BuildContext context, {
    List<BottomSheetTopAction>? topActions,
    required List<BottomSheetActionGroup> groups,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return ActionBottomSheet(topActions: topActions, groups: groups);
      },
    );
  }
}
