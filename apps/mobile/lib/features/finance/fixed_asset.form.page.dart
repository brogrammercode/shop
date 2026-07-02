import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';

class FixedAssetFormPage extends StatefulWidget {
  const FixedAssetFormPage({super.key});
  @override
  State<FixedAssetFormPage> createState() => _FixedAssetFormPageState();
}

class _FixedAssetFormPageState extends State<FixedAssetFormPage> {
  final _nameCtrl  = TextEditingController();
  final _valueCtrl = TextEditingController();
  final _depCtrl   = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    _depCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      floatingActionButton:         AppBottomAction(
        child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)), elevation: 0),
        child: Text(FinanceConstant.BTN_SAVE, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.pureWhite)),
        ),
        ),
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  _buildLabel(FinanceConstant.LABEL_ASSET_NAME),
                  SizedBox(height: 8.h),
                  _buildTextField(_nameCtrl, 'e.g. Tandoor Oven'),
                  SizedBox(height: 20.h),
                  _buildLabel(FinanceConstant.LABEL_PURCHASE_VALUE),
                  SizedBox(height: 8.h),
                  _buildTextField(_valueCtrl, '45000', inputType: TextInputType.number),
                  SizedBox(height: 20.h),
                  _buildLabel(FinanceConstant.LABEL_DEPRECIATION_PCT),
                  SizedBox(height: 8.h),
                  _buildTextField(_depCtrl, '10', inputType: TextInputType.number),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Text(text, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w800, color: AppColors.textSecondary, letterSpacing: 0.4));

  Widget _buildTextField(TextEditingController ctrl, String hint, {TextInputType? inputType}) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(color: AppColors.softGrey, borderRadius: BorderRadius.circular(12.r), border: Border.all(color: AppColors.borderGrey)),
      child: TextField(
        controller: ctrl,
        keyboardType: inputType,
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        decoration: InputDecoration(hintText: hint, hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 14.sp), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
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
          Expanded(child: Text(FinanceConstant.ASSET_FORM_TITLE_CREATE, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
