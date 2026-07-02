import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';

class CashRegisterDetailPage extends StatelessWidget {
  const CashRegisterDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(HrConstant.REGISTER_DETAIL_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
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
                    Center(
                      child: Text('TILL 1', style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.w900)),
                    ),
                    SizedBox(height: 24.h),
                    Text(HrConstant.OPEN_SHIFT, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.h),
                    AppInput(hintText: HrConstant.EXPECTED_CASH, keyboardType: TextInputType.number),
                    SizedBox(height: 12.h),
                    AppButton(text: HrConstant.OPEN_SHIFT, backgroundColor: AppColors.primaryGreen, onPressed: () {}),
                    
                    Divider(height: 48.h),
                    
                    Text(HrConstant.CLOSE_SHIFT, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8.h),
                    AppInput(hintText: HrConstant.ACTUAL_CASH, keyboardType: TextInputType.number),
                    SizedBox(height: 12.h),
                    AppButton(text: HrConstant.CLOSE_SHIFT, backgroundColor: Colors.orange, onPressed: () {}),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
