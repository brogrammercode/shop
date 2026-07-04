import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';

class StockTransferDetailPage extends StatelessWidget {
  const StockTransferDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(ProductionConstant.TRANSFER_DETAIL_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('TRF-2026-001', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            SizedBox(height: 8.h),
            Text('From: Main Store -> To: Kitchen', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
            SizedBox(height: 32.h),
            Text('ITEMS', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary)),
            SizedBox(height: 12.h),
            Expanded(
              child: ListView(
                children: [
                  _buildItemRow('Sugar', '50 KG'),
                  _buildItemRow('Milk', '10 LTR'),
                ],
              ),
            ),
            AppButton(
              text: ProductionConstant.MARK_RECEIVED,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemRow(String name, String qty) {
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
