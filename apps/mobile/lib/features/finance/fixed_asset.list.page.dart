import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';

class FixedAssetListPage extends StatelessWidget {
  const FixedAssetListPage({super.key});

  static const List<Map<String, dynamic>> _assets = [
    {'name': 'Tandoor Oven',    'value': 45000.00, 'dep': 10.0, 'status': 'Active'},
    {'name': 'POS Terminal',    'value': 18000.00, 'dep': 20.0, 'status': 'Active'},
    {'name': 'Refrigerator',    'value': 28000.00, 'dep': 15.0, 'status': 'Active'},
    {'name': 'Delivery Bike',   'value': 65000.00, 'dep': 25.0, 'status': 'Inactive'},
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
            child: ListView.separated(
              padding: EdgeInsets.all(16.w),
              itemCount: _assets.length,
              separatorBuilder: (_, i) => SizedBox(height: 12.h),
              itemBuilder: (context, i) {
                final asset = _assets[i];
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/finance-asset-detail'),
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
                          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), shape: BoxShape.circle),
                          child: Icon(Icons.precision_manufacturing_outlined, color: AppColors.primaryGreen, size: 22.w),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(asset['name'] as String, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                              SizedBox(height: 4.h),
                              Text('₹${(asset['value'] as double).toStringAsFixed(0)}  •  Dep: ${(asset['dep'] as double).toStringAsFixed(0)}%/yr', style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: asset['status'] == FinanceConstant.STATUS_ACTIVE ? const Color(0xFFE8F5E9) : AppColors.softGrey,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Text(asset['status'] as String,
                              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: asset['status'] == FinanceConstant.STATUS_ACTIVE ? AppColors.primaryGreen : AppColors.textSecondary)),
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
        onPressed: () => Navigator.pushNamed(context, '/finance-asset-form'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(FinanceConstant.BTN_ADD_ASSET, style: TextStyle(color: AppColors.pureWhite, fontSize: 14.sp, fontWeight: FontWeight.w800)),
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
          Expanded(child: Text(FinanceConstant.ASSET_LIST_TITLE, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
