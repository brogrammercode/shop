import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/inventory/constants/procurement.constant.dart';

class VendorReturnFormPage extends StatelessWidget {
  const VendorReturnFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(ProcurementConstant.returnTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
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
                    Text('Fresh Farms Ltd.', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                    SizedBox(height: 24.h),
                    AppInput(hintText: ProcurementConstant.returnReason, maxLines: 3),
                    SizedBox(height: 32.h),
                    Text('ITEMS TO RETURN', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                    SizedBox(height: 12.h),
                    _buildReturnItem('Tomatoes (Grade A)'),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h))),
              child: AppButton(
                text: ProcurementConstant.processReturn,
                backgroundColor: const Color(0xFFEF4F5F),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReturnItem(String name) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(8.r)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          SizedBox(height: 12.h),
          SizedBox(
            width: 140.w,
            child: AppInput(hintText: 'Qty Return', keyboardType: TextInputType.number),
          ),
        ],
      ),
    );
  }
}
