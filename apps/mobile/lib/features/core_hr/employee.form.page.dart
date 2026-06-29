import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';

class EmployeeFormPage extends StatelessWidget {
  const EmployeeFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(HrConstant.addEmployee, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppInput(hintText: 'Full Name'),
                    SizedBox(height: 16.h),
                    AppInput(hintText: 'UID (e.g. EMP-002)'),
                    SizedBox(height: 16.h),
                    Text(HrConstant.workDetails, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.h),
                    AppInput(hintText: 'Department'),
                    SizedBox(height: 12.h),
                    AppInput(hintText: 'Post'),
                    SizedBox(height: 12.h),
                    AppInput(hintText: 'Shift'),
                    SizedBox(height: 12.h),
                    AppInput(hintText: 'Role'),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h))),
              child: AppButton(
                text: 'Save',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
