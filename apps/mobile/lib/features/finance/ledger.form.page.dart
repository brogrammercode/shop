import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/features/finance/constants/finance.constant.dart';

class LedgerFormPage extends StatefulWidget {
  const LedgerFormPage({super.key});
  @override
  State<LedgerFormPage> createState() => _LedgerFormPageState();
}

class _LedgerFormPageState extends State<LedgerFormPage> {
  final _debitCtrl  = TextEditingController(text: '');
  final _creditCtrl = TextEditingController(text: '');
  final _notesCtrl  = TextEditingController(text: '');
  final _refCtrl    = TextEditingController(text: '');

  @override
  void dispose() {
    _debitCtrl.dispose();
    _creditCtrl.dispose();
    _notesCtrl.dispose();
    _refCtrl.dispose();
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
                  _buildSectionLabel(FinanceConstant.labelAccount),
                  SizedBox(height: 8.h),
                  _buildDropdownMock('Cash in Hand'),
                  SizedBox(height: 20.h),
                  _buildSectionLabel(FinanceConstant.sectionDebitCredit),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(child: _buildAmtField(_debitCtrl, FinanceConstant.labelDebit, const Color(0xFFEF4444))),
                      SizedBox(width: 12.w),
                      Expanded(child: _buildAmtField(_creditCtrl, FinanceConstant.labelCredit, AppColors.primaryGreen)),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  _buildSectionLabel(FinanceConstant.labelReferenceType),
                  SizedBox(height: 8.h),
                  _buildDropdownMock('Sale'),
                  SizedBox(height: 12.h),
                  _buildSectionLabel(FinanceConstant.labelReferenceId),
                  SizedBox(height: 8.h),
                  _buildTextField(_refCtrl, 'e.g. Sale #1042'),
                  SizedBox(height: 20.h),
                  _buildSectionLabel(FinanceConstant.labelNotes),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.borderGrey),
                    ),
                    child: TextField(
                      controller: _notesCtrl,
                      maxLines: 3,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Add notes or remarks…',
                        hintStyle: TextStyle(color: AppColors.textTertiary, fontSize: 14.sp),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildSaveBar(context),
        ],
      ),
    );
  }

  Widget _buildAmtField(TextEditingController ctrl, String label, Color accent) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w800, color: accent, letterSpacing: 0.5)),
        SizedBox(height: 6.h),
        Container(
          height: 48.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: accent.withOpacity(0.06),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: accent.withOpacity(0.3)),
          ),
          child: TextField(
            controller: ctrl,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: accent),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: TextStyle(color: accent.withOpacity(0.4), fontSize: 15.sp),
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
              prefixText: '₹ ',
              prefixStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w800, color: accent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownMock(String value) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(value, style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Icon(Icons.keyboard_arrow_down, color: AppColors.textSecondary, size: 20.w),
        ],
      ),
    );
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

  Widget _buildSectionLabel(String text) {
    return Text(text, style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w800, color: AppColors.textTertiary, letterSpacing: 0.8));
  }

  Widget _buildSaveBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(color: AppColors.pureWhite, border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h))),
      child: SizedBox(
        width: double.infinity,
        height: 48.h,
        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)), elevation: 0),
          child: Text(FinanceConstant.btnSave, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.pureWhite)),
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
          GestureDetector(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w)),
          SizedBox(width: 12.w),
          Expanded(child: Text(FinanceConstant.ledgerEntryFormTitle, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w900, color: AppColors.textPrimary))),
        ],
      ),
    );
  }
}
