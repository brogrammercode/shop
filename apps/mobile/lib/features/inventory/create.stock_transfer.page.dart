import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';

class CreateStockTransferPage extends StatelessWidget {
  const CreateStockTransferPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(ProductionConstant.createTransferTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    AppInput(hintText: ProductionConstant.fromLocation),
                    SizedBox(height: 16.h),
                    AppInput(hintText: ProductionConstant.toLocation),
                    SizedBox(height: 16.h),
                    AppInput(hintText: ProductionConstant.driverName),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h))),
              child: AppButton(
                text: ProductionConstant.dispatchItems,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
