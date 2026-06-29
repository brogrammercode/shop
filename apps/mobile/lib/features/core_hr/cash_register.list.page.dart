import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';

class CashRegisterListPage extends StatelessWidget {
  const CashRegisterListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        title: Text(HrConstant.registerListTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 2,
        separatorBuilder: (c, i) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final isOpen = index == 0;
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/cash-register-detail'),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Till ${index + 1}', style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                      if (isOpen) Text('Active: Bob Johnson', style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(color: isOpen ? const Color(0xFFE8F5E9) : const Color(0xFFF3F4F6), borderRadius: BorderRadius.circular(8.r)),
                    child: Text(isOpen ? 'OPEN' : 'CLOSED', style: TextStyle(color: isOpen ? AppColors.primaryGreen : AppColors.textSecondary, fontSize: 12.sp, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/cash-register-form'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(HrConstant.addRegister, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
