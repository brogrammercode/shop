import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/inventory/constants/procurement.constant.dart';

class CreateSupplierPage extends StatelessWidget {
  const CreateSupplierPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        title: Text(ProcurementConstant.createSupplierTitle, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader(ProcurementConstant.basicInfoSection),
                    SizedBox(height: 12.h),
                    AppInput(hintText: ProcurementConstant.supplierName),
                    SizedBox(height: 12.h),
                    AppInput(hintText: ProcurementConstant.taxNumber),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: AppInput(hintText: ProcurementConstant.phone, keyboardType: TextInputType.phone)),
                        SizedBox(width: 12.w),
                        Expanded(child: AppInput(hintText: ProcurementConstant.email, keyboardType: TextInputType.emailAddress)),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    _buildSectionHeader(ProcurementConstant.addressSection),
                    SizedBox(height: 12.h),
                    AppInput(hintText: 'Locality / Street'),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: AppInput(hintText: 'City')),
                        SizedBox(width: 12.w),
                        Expanded(child: AppInput(hintText: 'State')),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    _buildSectionHeader(ProcurementConstant.bankSection),
                    SizedBox(height: 12.h),
                    AppInput(hintText: 'Bank Name'),
                    SizedBox(height: 12.h),
                    AppInput(hintText: 'Account Number', keyboardType: TextInputType.number),
                    SizedBox(height: 12.h),
                    AppInput(hintText: 'IFSC Code'),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h))),
              child: AppButton(
                text: ProcurementConstant.saveSupplier,
                onPressed: () => Navigator.pop(context),
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
}
