import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/app_refresher.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/components/ui/dialog.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/loader.dart';

class EmployeeListPage extends StatefulWidget {
  const EmployeeListPage({super.key});

  @override
  State<EmployeeListPage> createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<CoreHrCubit>().listEmployees();
    context.read<CoreHrCubit>().listJoinRequests();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(context),
            _buildPageTitle(),
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEmployeeTab(),
                  _buildJoinRequestsTab(),
                ],
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
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(
          Icons.arrow_back,
          color: AppColors.textPrimary,
          size: 24.w,
        ),
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
            HrConstant.EMPLOYEE_LIST_TITLE,
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.pureWhite,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primaryGreen,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primaryGreen,
        indicatorWeight: 2.h,
        dividerColor: AppColors.borderGrey,
        labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        tabs: const [
          Tab(text: 'Employees'),
          Tab(text: 'Requests'),
        ],
      ),
    );
  }

  Widget _buildEmployeeTab() {
    return BlocBuilder<CoreHrCubit, CoreHrState>(
      builder: (context, state) {
        if (state.employeeInfo.status == OperationStatus.loading &&
            state.employees.isEmpty) {
          return const Center(child: AppLoader(size: 24, strokeWidth: 2));
        }
        final employees = state.employees;
        if (employees.isEmpty) {
          return Center(
            child: Text(
              'No employees found',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        return AppRefresher(
      onRefresh: () async {
        context.read<CoreHrCubit>().listEmployees();
        context.read<CoreHrCubit>().listJoinRequests();
      },
      child: ListView.separated(
          padding: EdgeInsets.all(24.w),
          itemCount: employees.length,
          separatorBuilder: (c, i) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final employee = employees[index];
            final name = employee.user?.name ?? employee.id;
            final phone = employee.user?.phone ?? '';
            final avatarUrl = employee.user?.avatar ?? '';
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/employee-detail', arguments: employee),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
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
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: AppColors.primaryGreen.withOpacity(0.2),
                      backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                      child: avatarUrl.isEmpty
                          ? Text(
                              name.isNotEmpty ? name[0].toUpperCase() : 'E',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            )
                          : null,
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              if (phone.isNotEmpty)
                                Expanded(
                                  child: Text(
                                    phone,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w400,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              if (phone.isNotEmpty) SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'Role: ${employee.role}',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textAlign: phone.isNotEmpty ? TextAlign.right : TextAlign.left,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Icon(
                      Icons.chevron_right,
                      color: AppColors.textTertiary,
                      size: 18.w,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
    );
      },
    );
  }

  Widget _buildJoinRequestsTab() {
    return BlocBuilder<CoreHrCubit, CoreHrState>(
      builder: (context, state) {
        if (state.joinInfo.status == OperationStatus.loading &&
            state.joinRequests.isEmpty) {
          return const Center(child: AppLoader(size: 24, strokeWidth: 2));
        }
        final requests = state.joinRequests;
        if (requests.isEmpty) {
          return Center(
            child: Text(
              'No join requests found',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        }
        return AppRefresher(
      onRefresh: () async {
        context.read<CoreHrCubit>().listEmployees();
        context.read<CoreHrCubit>().listJoinRequests();
      },
      child: ListView.separated(
          padding: EdgeInsets.all(24.w),
          itemCount: requests.length,
          separatorBuilder: (c, i) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            final request = requests[index];
            final requestId = request['id'] ?? '';
            final user = request['user'] ?? {};
            final name = user['name'] ?? 'Unknown User';
            final phone = user['phone'] ?? '';
            final avatarUrl = user['avatar'] ?? '';

            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
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
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20.r,
                        backgroundColor: AppColors.borderGrey,
                        backgroundImage: avatarUrl.isNotEmpty ? NetworkImage(avatarUrl) : null,
                        child: avatarUrl.isEmpty
                            ? Text(
                                name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (phone.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                phone,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          text: 'REJECT',
                          backgroundColor: const Color(0xFFEF4F5F),
                          onPressed: () async {
                            final confirm = await AppDialog.showConfirmation(
                              context: context,
                              title: 'Reject Request',
                              message: 'Are you sure you want to reject this request?',
                              confirmText: 'Reject',
                              isDestructive: true,
                            );
                            if (confirm == true && context.mounted) {
                              context.read<CoreHrCubit>().rejectJoinRequest(requestId);
                            }
                          },
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: AppButton(
                          text: 'APPROVE',
                          backgroundColor: AppColors.primaryGreen,
                          onPressed: () async {
                            final confirm = await AppDialog.showConfirmation(
                              context: context,
                              title: 'Approve Request',
                              message: 'Are you sure you want to approve this request?',
                              confirmText: 'Approve',
                            );
                            if (confirm == true && context.mounted) {
                              context.read<CoreHrCubit>().approveJoinRequest(requestId);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
    );
      },
    );
  }
}
