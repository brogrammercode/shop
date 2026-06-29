import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';

class VariantDetailPage extends StatelessWidget {
  const VariantDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(CatalogConstant.variantDetailTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grade A Tomatoes', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
            SizedBox(height: 4.h),
            Text('Item: Tomatoes', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
            SizedBox(height: 32.h),
            _buildInfoRow('SKU', 'TOM-A-01'),
            _buildInfoRow('Barcode', '1234567890123'),
            _buildInfoRow('Unit of Measure', 'KG (Kilogram)'),
            _buildInfoRow('Base Cost', '₹40.00'),
            _buildInfoRow('Min Stock Level', '10.0 KG'),
            SizedBox(height: 32.h),
            Center(
              child: Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(8.r)),
                child: Column(
                  children: [
                    Icon(Icons.qr_code, size: 100.w, color: AppColors.textPrimary), // Dummy barcode representation
                    SizedBox(height: 8.h),
                    Text('1234567890123', style: TextStyle(fontSize: 14.sp, letterSpacing: 2, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
