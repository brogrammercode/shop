import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/utils/error.dart';

class EmployeeFormPage extends StatefulWidget {
  const EmployeeFormPage({super.key});

  @override
  State<EmployeeFormPage> createState() => _EmployeeFormPageState();
}

class _EmployeeFormPageState extends State<EmployeeFormPage> {
  final _uidController = TextEditingController();
  final _roleController = TextEditingController();

  @override
  void dispose() {
    _uidController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  void _onSave() {
    final uid = _uidController.text.trim();
    final role = _roleController.text.trim();
    if (uid.isNotEmpty && role.isNotEmpty) {
      context.read<CoreHrCubit>().createEmployee(uid, role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoreHrCubit, CoreHrState>(
      listenWhen: (previous, current) =>
          previous.employeeInfo.status != current.employeeInfo.status,
      listener: (context, state) {
        if (state.employeeInfo.status == OperationStatus.success) {
          if (Navigator.canPop(context)) Navigator.pop(context);
        }
      },
      builder: (context, state) {
        final isLoading = state.employeeInfo.status == OperationStatus.loading;
        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          appBar: AppBar(
            backgroundColor: AppColors.pureWhite,
            elevation: 0,
            title: Text(
              HrConstant.ADD_EMPLOYEE,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w900,
                color: AppColors.textPrimary,
              ),
            ),
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
                        AppInput(hintText: 'Full Name'),
                        SizedBox(height: 16.h),
                        AppInput(
                          hintText: 'UID (e.g. EMP-002)',
                          controller: _uidController,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          HrConstant.WORK_DETAILS,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        AppInput(hintText: 'Department'),
                        SizedBox(height: 12.h),
                        AppInput(hintText: 'Post'),
                        SizedBox(height: 12.h),
                        AppInput(hintText: 'Shift'),
                        SizedBox(height: 12.h),
                        AppInput(hintText: 'Role', controller: _roleController),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(color: AppColors.borderGrey, width: 1.h),
                    ),
                  ),
                  child: AppButton(
                    text: 'Save',
                    isLoading: isLoading,
                    onPressed: _onSave,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
