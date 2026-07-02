import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';

class ItemDetailPage extends StatelessWidget {
  const ItemDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(CatalogConstant.ITEM_DETAIL_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 64.w,
                  height: 64.w,
                  decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(12.r)),
                  child: Center(child: Icon(Icons.fastfood, color: AppColors.textSecondary, size: 32.w)),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tomatoes', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                      SizedBox(height: 4.h),
                      Text('Category: Vegetables', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                      SizedBox(height: 4.h),
                      Text('Type: Raw Material • Shelf Life: 7 Days', style: TextStyle(fontSize: 12.sp, color: AppColors.textTertiary)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Text(CatalogConstant.VARIANTS_SECTION, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
            SizedBox(height: 12.h),
            _buildVariantCard(context, 'Grade A Tomatoes', 'SKU: TOM-A-01', '₹40.00 / KG'),
            _buildVariantCard(context, 'Grade B Tomatoes', 'SKU: TOM-B-01', '₹30.00 / KG'),
            SizedBox(height: 24.h),
            AppButton(
              text: CatalogConstant.ADD_VARIANT,
              backgroundColor: AppColors.softGrey,
              textColor: AppColors.textPrimary,
              icon: Icon(Icons.add, color: AppColors.textPrimary, size: 20.w),
              onPressed: () => Navigator.pushNamed(context, '/create-variant'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVariantCard(BuildContext context, String name, String sku, String price) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/variant-detail'),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(color: AppColors.pureWhite, border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                SizedBox(height: 4.h),
                Text(sku, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
              ],
            ),
            Text(price, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
          ],
        ),
      ),
    );
  }
}
