import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';

class TimeLogListPage extends StatelessWidget {
  const TimeLogListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(HrConstant.timeLogTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 2,
        separatorBuilder: (c, i) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(color: AppColors.pureWhite, borderRadius: BorderRadius.circular(16.r)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Alice Smith', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900)),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Clock In', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                        Text('07:55 AM', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Clock Out', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                        Text('04:10 PM', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: Colors.orange)),
                      ],
                    ),
                  ],
                ),
                Divider(height: 24.h),
                Text('Total: 8.25 hrs', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}
