import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';

class AccountListPage extends StatelessWidget {
  const AccountListPage({super.key});

  static const List<Map<String, String>> _accounts = [
    {'name': 'Cash in Hand',     'type': 'Asset',     'status': 'Active'},
    {'name': 'Sales Revenue',    'type': 'Revenue',   'status': 'Active'},
    {'name': 'Cost of Goods',    'type': 'Expense',   'status': 'Active'},
    {'name': 'Trade Payables',   'type': 'Liability', 'status': 'Active'},
    {'name': 'Owner Equity',     'type': 'Equity',    'status': 'Inactive'},
  ];

  Color _typeColor(String type) {
    switch (type) {
      case 'Asset':     return const Color(0xFF2563EB);
      case 'Revenue':   return AppColors.primaryGreen;
      case 'Expense':   return const Color(0xFFEF4444);
      case 'Liability': return const Color(0xFFF59E0B);
      default:          return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          _buildAppBar(context),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: _accounts.length,
              separatorBuilder: (_, i) => SizedBox(height: 12.h),
              itemBuilder: (context, i) {
                final acc = _accounts[i];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/finance-account-detail'),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: const [
                        BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 4)),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: _typeColor(acc['type']!).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.account_balance_wallet, color: _typeColor(acc['type']!), size: 22.w),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(acc['name']!, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                              SizedBox(height: 4.h),
                              Text(acc['type']!, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: acc['status'] == FinanceConstant.statusActive
                                ? const Color(0xFFE8F5E9)
                                : AppColors.softGrey,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(
                            acc['status']!,
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w800,
                              color: acc['status'] == FinanceConstant.statusActive
                                  ? AppColors.primaryGreen
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/finance-account-form'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(FinanceConstant.btnAddAccount, style: TextStyle(color: AppColors.pureWhite, fontSize: 14.sp, fontWeight: FontWeight.w800)),
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
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Text(FinanceConstant.accountListTitle, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
