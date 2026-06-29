import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';

class AccountFormPage extends StatefulWidget {
  const AccountFormPage({super.key});
  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  final _nameCtrl = TextEditingController(text: '');
  String _selectedType = FinanceConstant.typeAsset;

  static const _accountTypes = [
    FinanceConstant.typeAsset,
    FinanceConstant.typeLiability,
    FinanceConstant.typeRevenue,
    FinanceConstant.typeExpense,
    FinanceConstant.typeEquity,
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
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
                  _buildLabel(FinanceConstant.labelAccountName),
                  SizedBox(height: 8.h),
                  _buildTextField(_nameCtrl, FinanceConstant.hintAccountName),
                  SizedBox(height: 20.h),
                  _buildLabel(FinanceConstant.labelAccountType),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: _accountTypes.map((type) {
                      final active = _selectedType == type;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedType = type),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: active ? AppColors.primaryGreen : AppColors.softGrey,
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(color: active ? AppColors.primaryGreen : AppColors.borderGrey),
                          ),
                          child: Text(type, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: active ? AppColors.pureWhite : AppColors.textSecondary)),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20.h),
                  _buildLabel(FinanceConstant.sectionBankDetails),
                  SizedBox(height: 8.h),
                  _buildTextField(TextEditingController(text: 'State Bank of India'), 'Bank Name'),
                  SizedBox(height: 12.h),
                  _buildTextField(TextEditingController(text: '12345678901234'), 'Account Number'),
                  SizedBox(height: 12.h),
                  _buildTextField(TextEditingController(text: 'SBIN0001234'), 'IFSC Code'),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(color: AppColors.pureWhite, border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h))),
            child: SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                  elevation: 0,
                ),
                child: Text(FinanceConstant.btnSave, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.pureWhite)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.4));
  }

  Widget _buildTextField(TextEditingController ctrl, String hint) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: TextField(
        controller: ctrl,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 14.sp),
          border: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
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
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
          ),
          SizedBox(width: 12.w),
          Expanded(child: Text(FinanceConstant.accountFormTitleCreate, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
