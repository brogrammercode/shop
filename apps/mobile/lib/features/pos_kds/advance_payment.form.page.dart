import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/pos_kds/constants/pos.constant.dart';

class AdvancePaymentFormPage extends StatelessWidget {
  const AdvancePaymentFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(PosConstant.ADVANCE_PAYMENT_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      floatingActionButton:         AppBottomAction(
        child: AppButton(
        text: PosConstant.RECORD_PAYMENT,
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
                    AppInput(hintText: 'Order ID'),
                    SizedBox(height: 16.h),
                    AppInput(hintText: PosConstant.AMOUNT, keyboardType: TextInputType.number),
                    SizedBox(height: 16.h),
                    AppInput(hintText: PosConstant.PAYMENT_METHOD),
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
