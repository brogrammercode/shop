import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';

class BomDetailPage extends StatelessWidget {
  const BomDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(ProductionConstant.bomDetailTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Kaju Katli (10 KG Batch)', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            SizedBox(height: 32.h),
            Text('INGREDIENTS', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary)),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView(
                children: [
                  _buildIngRow('Cashews (Kaju)', '4.5 KG'),
                  _buildIngRow('Sugar', '2.5 KG'),
                  _buildIngRow('Milk', '1.0 LTR'),
                ],
              ),
            ),
            AppButton(
              text: ProductionConstant.startBatch,
              onPressed: () => Navigator.pushNamed(context, '/create-production-batch'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIngRow(String name, String qty) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
          Text(qty, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
