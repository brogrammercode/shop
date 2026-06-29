import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/catalog/constants/catalog.constant.dart';

class ItemListPage extends StatelessWidget {
  const ItemListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: const BoxDecoration(
                      color: AppColors.pureWhite,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
                    ),
                    child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24.w),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppInput(
                    hintText: CatalogConstant.searchItem,
                    prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                _buildFilterChip('All', true),
                _buildFilterChip('Vegetables', false),
                _buildFilterChip('Dairy', false),
                _buildFilterChip('Spices', false),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: 4,
              separatorBuilder: (c, i) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => _buildItemCard(context, index),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-item'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(CatalogConstant.addItem, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryGreen : AppColors.pureWhite,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: isSelected ? AppColors.primaryGreen : AppColors.borderGrey),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: isSelected ? AppColors.pureWhite : AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, int index) {
    final names = ['Tomatoes', 'Onions', 'Full Cream Milk', 'Turmeric Powder'];
    final categories = ['Vegetables', 'Vegetables', 'Dairy', 'Spices'];
    final variantCounts = [2, 1, 3, 4];
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/item-detail'),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.borderGrey),
          boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(color: const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8.r)),
              child: Center(child: Icon(Icons.fastfood, color: AppColors.textSecondary, size: 24.w)),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(names[index], style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                  SizedBox(height: 4.h),
                  Text(categories[index], style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(color: const Color(0xFFDBEAFE), borderRadius: BorderRadius.circular(6.r)),
              child: Text('${variantCounts[index]} Variants', style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: const Color(0xFF1D4ED8))),
            ),
          ],
        ),
      ),
    );
  }
}
