import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';

class RoyaltyListPage extends StatelessWidget {
  const RoyaltyListPage({super.key});

  static const List<Map<String, dynamic>> _royalties = [
    {'franchise': 'Franchise – North Delhi',    'amount': 12400.00, 'status': 'Paid',    'date': '01 Jun 2025'},
    {'franchise': 'Franchise – South Mumbai',   'amount': 9800.00,  'status': 'Pending', 'date': '01 Jun 2025'},
    {'franchise': 'Franchise – Ahmedabad East', 'amount': 7350.00,  'status': 'Overdue', 'date': '01 May 2025'},
  ];

  Color _statusColor(String status) {
    switch (status) {
      case 'Paid':    return AppColors.primaryGreen;
      case 'Overdue': return const Color(0xFFEF4444);
      default:        return const Color(0xFFF59E0B);
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
              itemCount: _royalties.length,
              separatorBuilder: (_, i) => SizedBox(height: 12.h),
              itemBuilder: (context, i) {
                final r = _royalties[i];
                final c = _statusColor(r['status'] as String);
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/finance-royalty-detail'),
                  child: Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: AppColors.pureWhite,
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: const [BoxShadow(color: AppColors.shadowColor, blurRadius: 8, offset: Offset(0, 4))],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(color: c.withOpacity(0.1), shape: BoxShape.circle),
                          child: Icon(Icons.handshake_outlined, color: c, size: 22.w),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(r['franchise'] as String, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                              SizedBox(height: 4.h),
                              Text('Due: ${r['date']}', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('₹${(r['amount'] as double).toStringAsFixed(0)}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
                            SizedBox(height: 4.h),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(6.r)),
                              child: Text(r['status'] as String, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: c)),
                            ),
                          ],
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
          Expanded(child: Text(FinanceConstant.ROYALTY_LIST_TITLE, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
