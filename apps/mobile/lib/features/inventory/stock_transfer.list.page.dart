import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';

class StockTransferListPage extends StatelessWidget {
  const StockTransferListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(ProductionConstant.transferListTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 3,
        separatorBuilder: (c, i) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final statuses = ['Pending', 'In Transit', 'Received'];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/stock-transfer-detail'),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('TRF-2026-00${index+1}', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      Text(statuses[index], style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: statuses[index] == 'Received' ? AppColors.primaryGreen : Colors.orange)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Text('Main Store -> Kitchen', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-stock-transfer'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(ProductionConstant.newTransfer, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
