import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/dialog.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';
import 'package:mobile/features/core_hr/models/employee.model.dart';

class EmployeeDetailPage extends StatelessWidget {
  const EmployeeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final employee = ModalRoute.of(context)!.settings.arguments as EmployeeModel;
    final name = employee.user?.name ?? employee.id;
    final avatarUrl = employee.user?.avatar ?? '';
    final address = employee.addresses.isNotEmpty 
        ? '${employee.addresses.first.area}, ${employee.addresses.first.city}' 
        : 'N/A';

    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            _buildPageTitle(name, employee.role.isNotEmpty ? employee.role : 'Employee'),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      _buildProfileCard(employee, name, avatarUrl),
                      SizedBox(height: 24.h),
                      _buildSectionCard(HrConstant.WORK_DETAILS, [
                        _buildRow('Department', employee.department.isNotEmpty ? employee.department : 'N/A'),
                        _buildRow('Post', employee.post.isNotEmpty ? employee.post : 'N/A'),
                        _buildRow('Shift', employee.shift.isNotEmpty ? employee.shift : 'N/A'),
                        _buildRow('Role', employee.role.isNotEmpty ? employee.role : 'N/A'),
                      ]),
                      SizedBox(height: 16.h),
                      _buildSectionCard(HrConstant.PERSONAL_DETAILS, [
                        _buildRow('Phone', employee.user?.phone ?? 'N/A'),
                        _buildRow('Email', employee.user?.email ?? 'N/A'),
                        _buildRow('Address', address),
                      ]),
                      SizedBox(height: 32.h),
                      AppButton(
                        text: HrConstant.DEACTIVATE, 
                        backgroundColor: const Color(0xFFEF4F5F), 
                        onPressed: () async {
                          final confirm = await AppDialog.showConfirmation(
                            context: context,
                            title: 'Deactivate Employee',
                            message: 'Are you sure you want to deactivate this employee?',
                            confirmText: 'Deactivate',
                            isDestructive: true,
                          );
                          if (confirm == true) {
                            // Perform deactivation logic
                          }
                        },
                      ),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: AppColors.pureWhite,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: AppColors.textPrimary,
              size: 24.w,
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Icon(Icons.edit_outlined, size: 24.w, color: AppColors.primaryGreen),
          ),
        ],
      ),
    );
  }

  Widget _buildPageTitle(String name, String role) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            role,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard(EmployeeModel employee, String name, String avatarUrl) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        border: Border.all(color: AppColors.borderGrey, width: 1.w),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32.r,
            backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
            backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
            child: avatarUrl.isEmpty
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : 'E',
                    style: TextStyle(color: AppColors.primaryGreen, fontSize: 24.sp, fontWeight: FontWeight.bold),
                  )
                : null,
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Employee ID',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  employee.uid.isNotEmpty ? employee.uid : employee.id.substring(0, 8),
                  style: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    employee.status.isNotEmpty ? employee.status.toUpperCase() : 'ACTIVE',
                    style: TextStyle(
                      color: AppColors.primaryGreen,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey, width: 1.w),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
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
          Text(label, style: TextStyle(fontSize: 13.sp, color: AppColors.textSecondary)),
          SizedBox(width: 16.w),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
