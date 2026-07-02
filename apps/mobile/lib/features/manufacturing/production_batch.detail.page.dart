import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';

class ProductionBatchDetailPage extends StatelessWidget {
  const ProductionBatchDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(ProductionConstant.BATCH_DETAIL_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('BAT-2026-001', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            SizedBox(height: 8.h),
            Text('Recipe: Kaju Katli (10 KG Batch)', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
            SizedBox(height: 32.h),
            Text('ACTIONS', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary)),
            SizedBox(height: 12.h),
            AppButton(
              text: ProductionConstant.CONSUME_MATERIALS,
              backgroundColor: AppColors.softGrey,
              textColor: AppColors.textPrimary,
              onPressed: () {},
            ),
            SizedBox(height: 16.h),
            AppButton(
              text: ProductionConstant.FINISH_BATCH,
              backgroundColor: AppColors.primaryGreen,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
