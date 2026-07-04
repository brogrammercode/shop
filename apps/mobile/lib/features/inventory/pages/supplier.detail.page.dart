import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/inventory/constants/procurement.constant.dart';

class SupplierDetailPage extends StatelessWidget {
  const SupplierDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(ProcurementConstant.SUPPLIER_DETAIL_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(radius: 32.r, backgroundColor: const Color(0xFFE8F5E9), child: Icon(Icons.store, size: 32.w, color: AppColors.primaryGreen)),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Fresh Farms Ltd.', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                      SizedBox(height: 4.h),
                      Text('GST: 07AABCU9603R1ZX', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 32.h),
            _buildSectionHeader(ProcurementConstant.ADDRESS_SECTION),
            SizedBox(height: 12.h),
            _buildCardTile(Icons.location_on, '123 Farm Road, Sector 5\nGurgaon, Haryana - 122001'),
            SizedBox(height: 32.h),
            _buildSectionHeader(ProcurementConstant.BANK_SECTION),
            SizedBox(height: 12.h),
            _buildCardTile(Icons.account_balance, 'HDFC Bank (DLF Cyber City)\nA/c: 50100230000000\nIFSC: HDFC0001234'),
            SizedBox(height: 32.h),
            _buildSectionHeader(ProcurementConstant.RECENT_POS),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('PO-2026-001', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      SizedBox(height: 4.h),
                      Text('28 Jun 2026', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
                    ],
                  ),
                  Text('₹4,500.00', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8));
  }

  Widget _buildCardTile(IconData icon, String content) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: AppColors.pureWhite, border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20.w),
          SizedBox(width: 12.w),
          Expanded(child: Text(content, style: TextStyle(fontSize: 14.sp, color: AppColors.textPrimary, height: 1.4))),
        ],
      ),
    );
  }
}
