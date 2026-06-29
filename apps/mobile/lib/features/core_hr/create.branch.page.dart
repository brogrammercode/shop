import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/core_hr/constants/branch.constant.dart';

class CreateBranchPage extends StatefulWidget {
  const CreateBranchPage({super.key});

  @override
  State<CreateBranchPage> createState() => _CreateBranchPageState();
}

class _CreateBranchPageState extends State<CreateBranchPage> {
  // Branch Controllers
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _franchiseController = TextEditingController();
  bool _isHq = false;

  // Address Controllers
  final _areaController = TextEditingController();
  final _localityController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _pinCodeController = TextEditingController();

  // Bank Controllers
  final _bankNameController = TextEditingController();
  final _accountNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _ifscCodeController = TextEditingController();
  final _swiftCodeController = TextEditingController();
  final _bankBranchController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _franchiseController.dispose();
    _areaController.dispose();
    _localityController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _pinCodeController.dispose();
    _bankNameController.dispose();
    _accountNameController.dispose();
    _accountNumberController.dispose();
    _ifscCodeController.dispose();
    _swiftCodeController.dispose();
    _bankBranchController.dispose();
    super.dispose();
  }

  void _onCreate() {
    // Navigate to home to simulate success
    Navigator.pushNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      BranchConstant.createBranchHeader,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    
                    _buildSectionHeader(BranchConstant.basicInfoSection),
                    SizedBox(height: 12.h),
                    AppInput(hintText: BranchConstant.branchNameLabel, controller: _nameController),
                    SizedBox(height: 12.h),
                    AppInput(hintText: BranchConstant.branchCodeLabel, controller: _codeController),
                    SizedBox(height: 12.h),
                    AppInput(hintText: BranchConstant.franchiseLabel, controller: _franchiseController),
                    SizedBox(height: 12.h),
                    _buildToggleRow(BranchConstant.isHqLabel, _isHq, (val) {
                      setState(() {
                        _isHq = val;
                      });
                    }),
                    
                    SizedBox(height: 32.h),
                    _buildSectionHeader(BranchConstant.addressSection),
                    SizedBox(height: 12.h),
                    AppInput(hintText: BranchConstant.areaLabel, controller: _areaController),
                    SizedBox(height: 12.h),
                    AppInput(hintText: BranchConstant.localityLabel, controller: _localityController),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: AppInput(hintText: BranchConstant.cityLabel, controller: _cityController)),
                        SizedBox(width: 12.w),
                        Expanded(child: AppInput(hintText: BranchConstant.stateLabel, controller: _stateController)),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: AppInput(hintText: BranchConstant.countryLabel, controller: _countryController)),
                        SizedBox(width: 12.w),
                        Expanded(child: AppInput(hintText: BranchConstant.pinCodeLabel, controller: _pinCodeController)),
                      ],
                    ),
                    
                    SizedBox(height: 32.h),
                    _buildSectionHeader(BranchConstant.bankSection),
                    SizedBox(height: 12.h),
                    AppInput(hintText: BranchConstant.bankNameLabel, controller: _bankNameController),
                    SizedBox(height: 12.h),
                    AppInput(hintText: BranchConstant.accountNameLabel, controller: _accountNameController),
                    SizedBox(height: 12.h),
                    AppInput(hintText: BranchConstant.accountNumberLabel, controller: _accountNumberController, keyboardType: TextInputType.number),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(child: AppInput(hintText: BranchConstant.ifscCodeLabel, controller: _ifscCodeController)),
                        SizedBox(width: 12.w),
                        Expanded(child: AppInput(hintText: BranchConstant.swiftCodeLabel, controller: _swiftCodeController)),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    AppInput(hintText: BranchConstant.bankBranchLabel, controller: _bankBranchController),
                    
                    SizedBox(height: 48.h),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: AppColors.pureWhite,
                border: Border(top: BorderSide(color: AppColors.borderGrey, width: 1.h)),
              ),
              child: AppButton(
                text: BranchConstant.submitCreateBranch,
                onPressed: _onCreate,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.w800,
        color: AppColors.textTertiary,
        letterSpacing: 0.8,
      ),
    );
  }

  Widget _buildToggleRow(String title, bool value, ValueChanged<bool> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(
            height: 24.h,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: AppColors.pureWhite,
              activeTrackColor: AppColors.primaryGreen,
              inactiveTrackColor: AppColors.borderGrey,
            ),
          ),
        ],
      ),
    );
  }
}
