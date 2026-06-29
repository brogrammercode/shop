import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/inventory/constants/procurement.constant.dart';

class SupplierListPage extends StatelessWidget {
  const SupplierListPage({super.key});

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
                    hintText: ProcurementConstant.searchSupplier,
                    prefixIcon: Icon(Icons.search, color: AppColors.textTertiary),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: 3,
              separatorBuilder: (c, i) => SizedBox(height: 12.h),
              itemBuilder: (context, index) => _buildSupplierCard(context, index),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-supplier'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(ProcurementConstant.addSupplier, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }

  Widget _buildSupplierCard(BuildContext context, int index) {
    final names = ['Fresh Farms Ltd.', 'Dairy Best Co.', 'Metro Wholesale'];
    final phones = ['+91 9876543210', '+91 8765432109', '+91 7654321098'];
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/supplier-detail'),
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
            CircleAvatar(
              radius: 24.r,
              backgroundColor: const Color(0xFFE8F5E9),
              child: Icon(Icons.local_shipping, color: AppColors.primaryGreen, size: 24.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(names[index], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  SizedBox(height: 4.h),
                  Text(phones[index], style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(6.r)),
              child: Text(ProcurementConstant.active, style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
            ),
          ],
        ),
      ),
    );
  }
}
