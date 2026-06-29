import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/manufacturing/constants/production.constant.dart';

class BomListPage extends StatelessWidget {
  const BomListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(ProductionConstant.bomListTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: EdgeInsets.all(16.w),
        itemCount: 2,
        separatorBuilder: (c, i) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          final items = ['Kaju Katli (10 KG Batch)', 'Rasgulla Base (5 KG Batch)'];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/bom-detail'),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(12.r)),
              child: Text(items[index], style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-bom'),
        backgroundColor: AppColors.primaryGreen,
        icon: const Icon(Icons.add, color: AppColors.pureWhite),
        label: Text(ProductionConstant.createRecipe, style: TextStyle(color: AppColors.pureWhite, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
