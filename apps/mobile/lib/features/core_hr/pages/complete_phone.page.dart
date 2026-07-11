import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/country_picker.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/constants/country.constant.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';
import 'package:mobile/services/json_cache.dart';
import 'package:mobile/utils/error.dart';

class CompletePhonePage extends StatefulWidget {
  const CompletePhonePage({super.key});

  @override
  State<CompletePhonePage> createState() => _CompletePhonePageState();
}

class _CompletePhonePageState extends State<CompletePhonePage> {
  final TextEditingController _phoneController = TextEditingController();

  CountryModel _selectedCountry = const CountryModel(
    name: 'India',
    flag: 'IN',
    dialCode: '+91',
    maxLength: 10,
  );

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    CountryPickerBottomSheet.show(
      context: context,
      selectedCountry: _selectedCountry,
      onCountrySelected: (country) {
        setState(() {
          _selectedCountry = country;
          _phoneController.clear();
        });
      },
    );
  }

  Future<void> _continueAfterPhone(CoreHrState state) async {
    if (state.requiresPhone) {
      Fluttertoast.showToast(msg: HrConstant.PLEASE_ENTER_PHONE_NUMBER);
      return;
    }

    final employee = state.currentEmployee;
    final hasEmployee = employee != null;
    final hasBranch = hasEmployee && employee.branch_id.isNotEmpty;
    if (hasBranch) {
      await JsonCache().saveBusinessContext({
        'branch_id': employee.branch_id,
        'employee_id': employee.id,
      });
    }

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      !hasEmployee || !hasBranch ? AppRoutes.crossRoad : AppRoutes.home,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CoreHrCubit, CoreHrState>(
      listenWhen: (previous, current) =>
          previous.completePhoneInfo.status != current.completePhoneInfo.status,
      listener: (context, state) {
        if (state.completePhoneInfo.status == OperationStatus.success) {
          _continueAfterPhone(state);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryGreen,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/logo.png', width: 80.w, height: 80.w),
                      SizedBox(height: 20.h),
                      Text(
                        'Complete profile',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.pureWhite,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Add your phone number to continue',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.pureWhite.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 24.h),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _showCountryPicker,
                          child: Container(
                            height: 46.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xFFCCCCCC),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  _selectedCountry.flag,
                                  style: TextStyle(fontSize: 16.sp),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.arrow_drop_down,
                                  color: AppColors.textPrimary,
                                  size: 18.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Container(
                            height: 46.h,
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: AppColors.pureWhite,
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: const Color(0xFFCCCCCC),
                              ),
                            ),
                            child: Row(
                              children: [
                                Text(
                                  '${_selectedCountry.dialCode} ',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Expanded(
                                  child: TextField(
                                    controller: _phoneController,
                                    keyboardType: TextInputType.phone,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(
                                        _selectedCountry.maxLength,
                                      ),
                                    ],
                                    decoration: InputDecoration(
                                      hintText: HrConstant.ENTER_PHONE_NUMBER,
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.zero,
                                      hintStyle: TextStyle(
                                        fontSize: 14.sp,
                                        color: AppColors.textTertiary,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),
                    BlocBuilder<CoreHrCubit, CoreHrState>(
                      buildWhen: (previous, current) =>
                          previous.completePhoneInfo.status !=
                          current.completePhoneInfo.status,
                      builder: (context, state) {
                        final isLoading =
                            state.completePhoneInfo.status ==
                            OperationStatus.loading;
                        return AppButton(
                          isLoading: isLoading,
                          onPressed: isLoading
                              ? () {}
                              : () {
                                  final phone = _phoneController.text.trim();
                                  if (phone.isEmpty) {
                                    Fluttertoast.showToast(
                                      msg: HrConstant.PLEASE_ENTER_PHONE_NUMBER,
                                    );
                                    return;
                                  }
                                  context.read<CoreHrCubit>().completePhone(
                                    '${_selectedCountry.dialCode}$phone',
                                  );
                                },
                          text: HrConstant.CONTINUE_TEXT,
                          backgroundColor: AppColors.primaryGreen,
                        );
                      },
                    ),
                    SizedBox(height: 8.h),
                    BlocBuilder<CoreHrCubit, CoreHrState>(
                      buildWhen: (previous, current) =>
                          previous.completePhoneInfo.status !=
                          current.completePhoneInfo.status,
                      builder: (context, state) {
                        if (state.completePhoneInfo.status !=
                            OperationStatus.loading) {
                          return const SizedBox.shrink();
                        }
                        return SizedBox(
                          height: 18.h,
                          width: 18.h,
                          child: const AppLoader(size: 24, strokeWidth: 2),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
