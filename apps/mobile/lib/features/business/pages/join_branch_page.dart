import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/auth/controllers/user.cubit.dart';
import 'package:mobile/features/auth/controllers/user.state.dart';
import 'package:mobile/features/business/controllers/business.cubit.dart';
import 'package:mobile/core/widgets/action_bottom_sheet.dart';
import 'package:mobile/core/widgets/confirmation_dialog.dart';
import 'dart:async';
import 'package:mobile/features/business/controllers/business.state.dart';
import 'package:mobile/utils/error.dart';
import 'package:shimmer/shimmer.dart';

class JoinBranchPage extends StatefulWidget {
  const JoinBranchPage({super.key});

  @override
  State<JoinBranchPage> createState() => _JoinBranchPageState();
}

class _JoinBranchPageState extends State<JoinBranchPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;
  String? _activeWithdrawRequestId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessCubit>().getMyJoinRequests();
      context.read<BusinessCubit>().searchBranches('');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      context.read<BusinessCubit>().searchBranches(query.trim());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadowColor,
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Want to register your own business?',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.pureWhite,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              AppButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.createBranch);
                },
                backgroundColor: AppColors.pureWhite,
                textColor: AppColors.primaryGreen,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                height: 32.h,
                isFullWidth: false,
                text: 'Create',
              ),
            ],
          ),
        ),
      ),
      body: BlocListener<UserCubit, UserState>(
        listenWhen: (previous, current) => previous.logoutInfo != current.logoutInfo,
        listener: (context, state) {
          if (state.logoutInfo.status == OperationStatus.success) {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          }
        },
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).padding.top),
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 16.h),
                      _buildSearchBar(),
                      SizedBox(height: 24.h),
                      BlocBuilder<BusinessCubit, BusinessState>(
                        builder: (context, state) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (state.searchInfo.status ==
                                  OperationStatus.loading)
                                ...List.generate(5, (index) => _buildShimmerCard())
                              else if (state.searchResults != null &&
                                  state.searchResults!.isNotEmpty) ...[
                                Text(
                                  'SEARCH RESULTS',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textTertiary,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ...state.searchResults!.map(
                                  (branch) => _buildBranchCard(branch, context, state),
                                ),
                              ],
                              SizedBox(height: 32.h),
                              if (state.myJoinRequests != null &&
                                  state.myJoinRequests!.isNotEmpty) ...[
                                Text(
                                  'YOUR REQUESTS',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textTertiary,
                                    letterSpacing: 0.8,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ...state.myJoinRequests!.map(
                                  (request) =>
                                      _buildRequestCard(request, context, state),
                                ),
                                SizedBox(height: 32.h),
                              ],
                              SizedBox(height: 100.h),
                            ],
                          );
                        },
                      ),
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Join Branch',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: () => _showGlobalActions(context),
            child: Icon(Icons.more_vert, color: AppColors.textPrimary, size: 24.w),
          ),
        ],
      ),
    );
  }

  void _showGlobalActions(BuildContext context) {
    ActionBottomSheet.show(
      context,
      groups: [
        BottomSheetActionGroup(
          actions: [
            BottomSheetAction(
              label: 'Logout',
              icon: Icons.logout,
              labelColor: const Color(0xFFEF4F5F),
              iconColor: const Color(0xFFEF4F5F),
              onTap: () {
                ConfirmationDialog.show(
                  context,
                  title: 'Confirm Logout',
                  content: 'Are you sure you want to log out of your account?',
                  confirmText: 'Logout',
                  onConfirm: () => context.read<UserCubit>().logout(),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 42.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderGrey),
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
          Expanded(
            child: TextField(
              controller: _searchController,
              style: TextStyle(fontSize: 15.sp, color: AppColors.textPrimary),
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search branch by name...',
                hintStyle: TextStyle(
                  color: AppColors.textTertiary,
                  fontSize: 15.sp,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Container(height: 20.h, width: 1.w, color: AppColors.borderGrey),
          SizedBox(width: 12.w),
          Icon(
            Icons.search,
            color: AppColors.primaryGreen,
            size: 22.w,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Row(
          children: [
            Container(
              width: 52.w,
              height: 52.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 16.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    width: 100.w,
                    height: 12.h,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Container(
              width: 24.w,
              height: 24.w,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchCard(dynamic branch, BuildContext context, BusinessState state) {
    final hasRequested = state.myJoinRequests?.any((r) => r.branch_id == branch.id) ?? false;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
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
          Container(
            width: 52.w,
            height: 52.w,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.5), width: 1.5.w),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryGreen.withValues(alpha: 0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(Icons.store, color: AppColors.primaryGreen, size: 26.w),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  branch.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  'Code: ${branch.branch_code}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (branch.address != null && branch.address!.city.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 12.w, color: AppColors.textTertiary),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          '${branch.address!.city}, ${branch.address!.state}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textTertiary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _buildEmployeeAvatars(branch.employees),
          if (!hasRequested) ...[
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: () => _showBranchActions(context, branch),
              child: Icon(Icons.more_vert, color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  void _showBranchActions(BuildContext context, dynamic branch) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) {
        return BlocConsumer<BusinessCubit, BusinessState>(
          listenWhen: (previous, current) => previous.requestJoinInfo != current.requestJoinInfo,
          listener: (context, state) {
            if (state.requestJoinInfo.status == OperationStatus.success || 
                state.requestJoinInfo.status == OperationStatus.error) {
              Navigator.pop(bottomSheetContext);
            }
          },
          builder: (context, state) {
            return ActionBottomSheet(
              groups: [
                BottomSheetActionGroup(
                  actions: [
                    BottomSheetAction(
                      label: 'Request to Join',
                      icon: Icons.chevron_right,
                      isLoading: state.requestJoinInfo.status == OperationStatus.loading,
                      onTap: () {
                        context.read<BusinessCubit>().requestJoin(branch.id);
                      },
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmployeeAvatars(List<dynamic>? employees) {
    if (employees == null || employees.isEmpty) {
      return SizedBox(width: 0, height: 28.w);
    }
    
    final maxAvatars = 3;
    final totalCount = employees.length;
    final displayCount = totalCount > maxAvatars ? maxAvatars : totalCount;
    final hasExtra = totalCount > maxAvatars;

    return SizedBox(
      width: (displayCount * 18.w) + (hasExtra ? 18.w : 0) + 10.w,
      height: 28.w,
      child: Stack(
        children: [
          for (int i = 0; i < displayCount; i++)
            Positioned(
              left: (i * 18.w).toDouble(),
              child: Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.softGrey,
                  border: Border.all(color: AppColors.pureWhite, width: 2.w),
                ),
                child: Icon(Icons.person, size: 16.w, color: AppColors.textSecondary),
              ),
            ),
          if (hasExtra)
            Positioned(
              left: (displayCount * 18.w).toDouble(),
              child: Container(
                width: 28.w,
                height: 28.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGreen,
                  border: Border.all(color: AppColors.pureWhite, width: 2.w),
                ),
                child: Text(
                  '+${totalCount - maxAvatars}',
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.pureWhite,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(dynamic request, BuildContext context, BusinessState state) {
    final bool isPending = request.status == 'PENDING';
    final Color statusColor = isPending
        ? const Color(0xFFE67E22)
        : (request.status == 'APPROVED'
              ? AppColors.primaryGreen
              : const Color(0xFFEF4F5F));

    final String branchName = request.branch?.name ?? 'Unknown Branch';
    final String branchCode = request.branch?.branch_code ?? request.branch_id.substring(0, 8);
    final String roleName = request.requested_role?.name ?? 'Employee';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
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
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF5F5F5), Color(0xFFE0E0E0)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.borderGrey, width: 1.w),
                ),
                child: Icon(Icons.business, color: AppColors.textSecondary, size: 24.w),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      branchName,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          'Code: $branchCode',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 6.w),
                          width: 4.w,
                          height: 4.w,
                          decoration: const BoxDecoration(
                            color: AppColors.textTertiary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            roleName,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
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
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                ),
                child: Text(
                  request.status,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w900,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
          if (isPending) ...[
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              height: 42.h,
              child: OutlinedButton(
                onPressed: state.withdrawJoinInfo.status == OperationStatus.loading 
                    ? null 
                    : () {
                        ConfirmationDialog.show(
                          context,
                          title: 'Withdraw Request',
                          content: 'Are you sure you want to withdraw your request to join this branch?',
                          confirmText: 'Withdraw',
                          onConfirm: () {
                            setState(() {
                              _activeWithdrawRequestId = request.id;
                            });
                            context.read<BusinessCubit>().withdrawJoinRequest(request.id);
                          },
                        );
                      },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFFEF4F5F)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child: state.withdrawJoinInfo.status == OperationStatus.loading && _activeWithdrawRequestId == request.id
                    ? SizedBox(
                        width: 16.w,
                        height: 16.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEF4F5F)),
                        ),
                      )
                    : Text(
                        'Withdraw Request',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFEF4F5F),
                        ),
                      ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
