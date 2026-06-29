import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';

class EmployeeDetailPage extends StatelessWidget {
  const EmployeeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        actions: [
          IconButton(icon: const Icon(Icons.edit, color: AppColors.primaryGreen), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
              ),
              child: Column(
                children: [
                  CircleAvatar(radius: 40.r, backgroundColor: AppColors.primaryGreen, child: Text('A', style: TextStyle(color: Colors.white, fontSize: 32.sp))),
                  SizedBox(height: 16.h),
                  Text('Alice Smith', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900)),
                  Text('UID: EMP-001', style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            
            // Work Details
            _buildSectionCard(HrConstant.workDetails, [
              _buildRow('Department', 'Kitchen'),
              _buildRow('Post', 'Head Chef'),
              _buildRow('Shift', 'Morning (8AM - 4PM)'),
              _buildRow('Role', 'Chef Access'),
            ]),
            
            SizedBox(height: 16.h),
            _buildSectionCard(HrConstant.personalDetails, [
              _buildRow('Address', '123 Culinary Way, Flavor Town, CA 90210'),
            ]),
            
            SizedBox(height: 32.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: AppButton(text: HrConstant.deactivate, backgroundColor: Colors.redAccent, onPressed: () {}),
            ),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900)),
          SizedBox(height: 16.h),
          ...children,
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
          Text(label, style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary)),
          Flexible(child: Text(value, textAlign: TextAlign.right, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800))),
        ],
      ),
    );
  }
}
