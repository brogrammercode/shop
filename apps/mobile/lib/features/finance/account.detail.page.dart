import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';

class AccountDetailPage extends StatelessWidget {
  const AccountDetailPage({super.key});

  static const List<Map<String, String>> _recentEntries = [
    {'date': '28 Jun 2025', 'ref': 'Sale #1042', 'debit': '0.00',  'credit': '3,200.00'},
    {'date': '27 Jun 2025', 'ref': 'Expense #89', 'debit': '450.00', 'credit': '0.00'},
    {'date': '26 Jun 2025', 'ref': 'Sale #1040', 'debit': '0.00',  'credit': '1,800.00'},
  ];

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
                  _buildHeroCard(),
                  SizedBox(height: 16.h),
                  _buildSectionHeader(FinanceConstant.sectionBankDetails),
                  _buildBankDetailsCard(),
                  SizedBox(height: 16.h),
                  _buildSectionHeader(FinanceConstant.sectionRecentEntries),
                  _buildRecentEntries(context),
                  SizedBox(height: 32.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: SizedBox(
                      width: double.infinity,
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4444),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                          elevation: 0,
                        ),
                        child: Text(FinanceConstant.btnDeactivate, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.pureWhite)),
                      ),
                    ),
                  ),
                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: const BoxDecoration(
        color: AppColors.pureWhite,
        boxShadow: [BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8.r)),
                child: Text(FinanceConstant.typeAsset, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(8.r)),
                child: Text(FinanceConstant.statusActive, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text('Cash in Hand', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          SizedBox(height: 4.h),
          Text('ID: acc-001 • Branch: Main Branch', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(child: _buildBalanceBox('Total Debit', '₹12,400.00', const Color(0xFFEF4444))),
              SizedBox(width: 12.w),
              Expanded(child: _buildBalanceBox('Total Credit', '₹18,200.00', AppColors.primaryGreen)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceBox(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          SizedBox(height: 4.h),
          Text(value, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: color)),
        ],
      ),
    );
  }

  Widget _buildBankDetailsCard() {
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
          _buildDetailRow('Bank Name', 'State Bank of India'),
          _buildDetailRow('Account Number', '****5678'),
          _buildDetailRow('IFSC Code', 'SBIN0001234'),
          _buildDetailRow('Branch', 'Ahmedabad Main'),
        ],
      ),
    );
  }

  Widget _buildRecentEntries(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Column(
        children: _recentEntries.asMap().entries.map((e) {
          final idx = e.key;
          final entry = e.value;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(entry['ref']!, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                          SizedBox(height: 4.h),
                          Text(entry['date']!, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (entry['debit'] != '0.00')
                          Text('- ₹${entry['debit']}', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: const Color(0xFFEF4444))),
                        if (entry['credit'] != '0.00')
                          Text('+ ₹${entry['credit']}', style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.primaryGreen)),
                      ],
                    ),
                  ],
                ),
              ),
              if (idx < _recentEntries.length - 1)
                Container(height: 1.h, color: AppColors.borderGrey),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String label) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Text(label, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
          Expanded(child: Text(FinanceConstant.accountDetailTitle, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/finance-account-form'),
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
