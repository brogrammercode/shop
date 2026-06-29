import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(HrConstant.employeeListTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 3,
        separatorBuilder: (c, i) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final names = ['Alice Smith', 'Bob Johnson', 'Charlie Davis'];
          final posts = ['Head Chef', 'Waitress', 'Cashier'];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/employee-detail'),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.circular(16.r),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                    child: Text(names[index][0], style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18.sp)),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(names[index], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                        Text(posts[index], style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8.r)),
                    child: Text('Active', style: TextStyle(color: AppColors.primaryGreen, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/employee-form'),
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.person_add, color: AppColors.pureWhite),
      ),
    );
  }
}
