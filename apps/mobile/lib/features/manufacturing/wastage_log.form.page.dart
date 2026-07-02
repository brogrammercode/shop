import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';

class WastageLogFormPage extends StatelessWidget {
  const WastageLogFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(ProductionConstant.WASTAGE_FORM_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      floatingActionButton:         AppBottomAction(
        child: AppButton(
        text: ProductionConstant.LOG_WASTAGE,
        onPressed: () => Navigator.pop(context),
        ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    AppInput(hintText: ProductionConstant.WASTE_REASON),
                    SizedBox(height: 16.h),
                    AppInput(hintText: ProductionConstant.QUANTITY_WASTED, keyboardType: TextInputType.number),
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
