import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';

class FinanceDashboardPage extends StatelessWidget {
  const FinanceDashboardPage({super.key});

  static const List<Map<String, dynamic>> _tiles = [
    {'icon': Icons.account_balance_wallet, 'title': 'Chart of Accounts', 'subtitle': '5 accounts', 'route': '/finance-account-list', 'color': Color(0xFF2563EB)},
    {'icon': Icons.book_outlined,          'title': 'Ledger',             'subtitle': '4 entries today', 'route': '/finance-ledger-list',   'color': Color(0xFF7C3AED)},
    {'icon': Icons.precision_manufacturing_outlined, 'title': 'Fixed Assets', 'subtitle': '4 assets', 'route': '/finance-asset-list',    'color': Color(0xFF0F8244)},
    {'icon': Icons.handshake_outlined,     'title': 'Royalty',            'subtitle': '1 overdue',    'route': '/finance-royalty-list',  'color': Color(0xFFEF4444)},
  ];

  static const List<Map<String, String>> _summaryCards = [
    {'label': 'Total Revenue', 'value': '₹1,84,200',  'trend': '+12%'},
    {'label': 'Total Expenses','value': '₹68,450',   'trend': '-3%'},
    {'label': 'Net Profit',    'value': '₹1,15,750', 'trend': '+18%'},
    {'label': 'Pending Roy.',  'value': '₹9,800',    'trend': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).padding.top),
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('OVERVIEW', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                  SizedBox(height: 12.h),
                  GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12.w,
                    mainAxisSpacing: 12.h,
                    childAspectRatio: 1.8,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: _summaryCards.map((card) => _buildSummaryCard(card)).toList(),
                  ),
                  SizedBox(height: 24.h),
                  Text('MODULES', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8)),
                  SizedBox(height: 12.h),
                  ...(_tiles.map((tile) => _buildModuleTile(context, tile))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(Map<String, String> card) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(card['label']!, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w700, color: AppColors.textSecondary)),
          SizedBox(height: 4.h),
          Text(card['value']!, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
          if (card['trend']!.isNotEmpty) ...[
            SizedBox(height: 2.h),
            Text(card['trend']!, style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w800, color: card['trend']!.startsWith('+') ? AppColors.primaryGreen : const Color(0xFFEF4444))),
          ],
        ],
      ),
    );
  }

  Widget _buildModuleTile(BuildContext context, Map<String, dynamic> tile) {
    final color = tile['color'] as Color;
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, tile['route'] as String),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.pureWhite,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(tile['icon'] as IconData, color: color, size: 24.w),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tile['title'] as String, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                  SizedBox(height: 4.h),
                  Text(tile['subtitle'] as String, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 22.w),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w)),
          SizedBox(width: 12.w),
          Expanded(child: Text(FinanceConstant.MODULE_TITLE, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
