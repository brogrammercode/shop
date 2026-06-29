import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';

class ShiftListPage extends StatelessWidget {
  const ShiftListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(HrConstant.shiftListTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 2,
        separatorBuilder: (c, i) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final shifts = ['Morning (8AM - 4PM)', 'Evening (4PM - 12AM)'];
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
            child: Row(
              children: [
                Icon(Icons.access_time, color: AppColors.primaryGreen),
                SizedBox(width: 12.w),
                Text(shifts[index], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/shift-form'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(HrConstant.addShift, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
