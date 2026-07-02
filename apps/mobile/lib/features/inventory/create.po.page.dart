import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/inventory/constants/procurement.constant.dart';

class CreatePoPage extends StatelessWidget {
  const CreatePoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(ProcurementConstant.CREATE_PO_TITLE, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      floatingActionButton:         AppBottomAction(
        child: AppButton(
        text: ProcurementConstant.SUBMIT_PO,
        onPressed: () => Navigator.pop(context),
        ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(ProcurementConstant.SELECT_SUPPLIER),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(10.r)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Fresh Farms Ltd.', style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                          Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary),
                        ],
                      ),
                    ),
                    SizedBox(height: 32.h),
                    _buildSectionHeader(ProcurementConstant.ITEMS_SECTION),
                    SizedBox(height: 12.h),
                    _buildLineItem('Tomatoes (Grade A)', '50 kg', '₹40.00', '₹2,000.00'),
                    _buildLineItem('Onions', '100 kg', '₹25.00', '₹2,500.00'),
                    SizedBox(height: 12.h),
                    AppButton(text: ProcurementConstant.ADD_ITEM, backgroundColor: AppColors.softGrey, textColor: AppColors.textPrimary, onPressed: () {}),
                    SizedBox(height: 32.h),
                    _buildSectionHeader(ProcurementConstant.REVIEW_SECTION),
                    SizedBox(height: 12.h),
                    AppInput(hintText: ProcurementConstant.NOTES, maxLines: 3),
                    SizedBox(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(ProcurementConstant.GRAND_TOTAL, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
                        Text('₹4,500.00', style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.w900, color: AppColors.primaryGreen)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(title, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8));
  }

  Widget _buildLineItem(String name, String qty, String price, String total) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(border: Border.all(color: AppColors.borderGrey), borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
                SizedBox(height: 4.h),
                Text('$qty × $price', style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Text(total, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}
