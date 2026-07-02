import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/components/ui/toggle.dart';
import 'package:mobile/components/ui/bottom_action.dart';
import 'package:mobile/features/core_hr/constants/branch.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/utils/error.dart';

class CreateBranchPage extends StatefulWidget {
  const CreateBranchPage({super.key});

  @override
  State<CreateBranchPage> createState() => _CreateBranchPageState();
}

class _CreateBranchPageState extends State<CreateBranchPage> {
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _franchiseController = TextEditingController();
  bool _isHq = false;

  final _areaController = TextEditingController();
  final _localityController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _countryController = TextEditingController();
  final _pinCodeController = TextEditingController();

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
    final name = _nameController.text.trim();
    final code = _codeController.text.trim();
    if (name.isNotEmpty && code.isNotEmpty) {
      context.read<CoreHrCubit>().createBranch(name, code, _isHq);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoreHrCubit, CoreHrState>(
      listenWhen: (previous, current) =>
          previous.branchInfo.status != current.branchInfo.status,
      listener: (context, state) {
        if (state.branchInfo.status == OperationStatus.success) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        final isLoading = state.branchInfo.status == OperationStatus.loading;
        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          floatingActionButton: AppBottomAction(
            child: AppButton(
              text: BranchConstant.SUBMIT_CREATE_BRANCH,
              isLoading: isLoading,
              onPressed: _onCreate,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                _buildPageTitle(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 8.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        _buildSectionHeader(BranchConstant.BASIC_INFO_SECTION),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.BRANCH_NAME_LABEL,
                          controller: _nameController,
                        ),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.BRANCH_CODE_LABEL,
                          controller: _codeController,
                        ),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.FRANCHISE_LABEL,
                          controller: _franchiseController,
                        ),
                        SizedBox(height: 12.h),
                        AppToggle(
                          label: BranchConstant.IS_HQ_LABEL,
                          value: _isHq,
                          onChanged: (val) => setState(() => _isHq = val),
                        ),

                        SizedBox(height: 32.h),
                        _buildSectionHeader(BranchConstant.ADDRESS_SECTION),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.AREA_LABEL,
                          controller: _areaController,
                        ),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.LOCALITY_LABEL,
                          controller: _localityController,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: AppInput(
                                hintText: BranchConstant.CITY_LABEL,
                                controller: _cityController,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: AppInput(
                                hintText: BranchConstant.STATE_LABEL,
                                controller: _stateController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: AppInput(
                                hintText: BranchConstant.COUNTRY_LABEL,
                                controller: _countryController,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: AppInput(
                                hintText: BranchConstant.PIN_CODE_LABEL,
                                controller: _pinCodeController,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 32.h),
                        _buildSectionHeader(BranchConstant.BANK_SECTION),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.BANK_NAME_LABEL,
                          controller: _bankNameController,
                        ),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.ACCOUNT_NAME_LABEL,
                          controller: _accountNameController,
                        ),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.ACCOUNT_NUMBER_LABEL,
                          controller: _accountNumberController,
                          keyboardType: TextInputType.number,
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Expanded(
                              child: AppInput(
                                hintText: BranchConstant.IFSC_CODE_LABEL,
                                controller: _ifscCodeController,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: AppInput(
                                hintText: BranchConstant.SWIFT_CODE_LABEL,
                                controller: _swiftCodeController,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        AppInput(
                          hintText: BranchConstant.BANK_BRANCH_LABEL,
                          controller: _bankBranchController,
                        ),

                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
      ),
    );
  }

  Widget _buildPageTitle() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            BranchConstant.CREATE_BRANCH_HEADER,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 4.h),
          Container(height: 1.h, color: AppColors.borderGrey),
        ],
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
}
