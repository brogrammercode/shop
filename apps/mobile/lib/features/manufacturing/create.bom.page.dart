import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';

class CreateBomPage extends StatelessWidget {
  const CreateBomPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(ProductionConstant.CREATE_BOM_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
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
                    AppInput(hintText: ProductionConstant.OUTPUT_PRODUCT),
                    SizedBox(height: 16.h),
                    AppInput(hintText: ProductionConstant.EXPECTED_YIELD, keyboardType: TextInputType.number),
                    SizedBox(height: 16.h),
                    AppInput(hintText: ProductionConstant.INSTRUCTIONS, maxLines: 4),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h))),
              child: AppButton(
                text: ProductionConstant.SAVE_RECIPE,
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
