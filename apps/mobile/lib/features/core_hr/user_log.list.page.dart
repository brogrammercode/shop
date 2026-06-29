import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';

class UserLogListPage extends StatelessWidget {
  const UserLogListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(HrConstant.userLogTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 4,
        separatorBuilder: (c, i) => Divider(color: AppColors.borderGrey),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Admin opened Till 1', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800)),
                SizedBox(height: 4.h),
                Text('2023-10-27 08:00 AM', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
              ],
            ),
          );
        },
      ),
    );
  }
}
