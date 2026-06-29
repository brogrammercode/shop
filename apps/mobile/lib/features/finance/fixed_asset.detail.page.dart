import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';

class FixedAssetDetailPage extends StatelessWidget {
  const FixedAssetDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroCard(context),
                  SizedBox(height: 16.h),
                  _buildSectionLabel('ASSET DETAILS'),
                  SizedBox(height: 8.h),
                  _buildDetailsCard(),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      color: AppColors.pureWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8.r)),
                child: Text(FinanceConstant.statusActive, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text('Tandoor Oven', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          SizedBox(height: 4.h),
          Text('Added: 01 Jan 2024  •  Branch: Main Branch', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(child: _buildValueBox('Purchase Value', '₹45,000')),
              SizedBox(width: 12.w),
              Expanded(child: _buildValueBox('Current Value', '₹40,500')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          SizedBox(height: 4.h),
          Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: [
          _buildRow(FinanceConstant.labelDepreciationPct, '10% per year'),
          _buildRow('Status', FinanceConstant.statusActive),
          _buildRow('Branch', 'Main Branch'),
          _buildRow('Created At', '01 Jan 2024'),
          _buildRow('Updated At', '28 Jun 2025'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          Text(value, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 0),
      child: Text(text, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(color: AppColors.pureWhite, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))]),
              child: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24.w),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Text(FinanceConstant.assetDetailTitle, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/finance-asset-form'),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: const BoxDecoration(color: AppColors.pureWhite, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 4, offset: Offset(0, 2))]),
              child: Icon(Icons.edit_outlined, color: AppColors.primaryGreen, size: 20.w),
            ),
          ),
        ],
      ),
    );
  }
}
