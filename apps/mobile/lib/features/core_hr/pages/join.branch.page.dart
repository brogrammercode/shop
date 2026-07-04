import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/features/core_hr/constants/branch.constant.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/components/ui/dialog.dart';import 'package:mobile/components/ui/loader.dart';


class JoinBranchPage extends StatefulWidget {
  const JoinBranchPage({super.key});

  @override
  State<JoinBranchPage> createState() => _JoinBranchPageState();
}

class _JoinBranchPageState extends State<JoinBranchPage> {
  final TextEditingController _searchController = TextEditingController();

  bool _justSentRequest = false;

  @override
  void initState() {
    super.initState();
    context.read<CoreHrCubit>().searchBranches('');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CoreHrCubit>().resetJoinInfo();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch(String value) {
    context.read<CoreHrCubit>().searchBranches(value);
  }

  Future<void> _onRequestJoin(String branchId) async {
    final confirm = await AppDialog.showConfirmation(
      context: context,
      title: 'Request to Join',
      message: 'Are you sure you want to request to join this branch?',
      confirmText: 'Request Join',
    );
    if (confirm == true && mounted) {
      _justSentRequest = true;
      context.read<CoreHrCubit>().sendJoinRequest(branchId, 'Requesting to join branch.');
    }
  }

  Future<void> _onWithdrawRequest(String branchId) async {
    final confirm = await AppDialog.showConfirmation(
      context: context,
      title: 'Withdraw Request',
      message: 'Are you sure you want to withdraw your join request?',
      confirmText: 'Withdraw',
      isDestructive: true,
    );
    if (confirm == true && mounted) {
      context.read<CoreHrCubit>().withdrawJoinRequest(branchId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoreHrCubit, CoreHrState>(
      listenWhen: (previous, current) => previous.joinInfo.status != current.joinInfo.status,
      listener: (context, state) {
        if (state.joinInfo.status == OperationStatus.success && _justSentRequest) {
          _justSentRequest = false;
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.pureWhite,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildAppBar(context),
                _buildPageTitle(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        AppInput(
                          hintText: BranchConstant.ENTER_BRANCH_CODE,
                          controller: _searchController,
                          onChanged: _onSearch,
                          prefixIcon: Icon(Icons.search, color: AppColors.textTertiary, size: 20.w),
                        ),
                        SizedBox(height: 24.h),
                        Expanded(
                          child: _buildBranchList(state),
                        ),
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
            BranchConstant.SEARCH_BRANCH_HEADER,
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

  Widget _buildBranchList(CoreHrState state) {
    if (state.searchBranchInfo.status == OperationStatus.loading && state.searchedBranches.isEmpty) {
      return Center(
        child: SizedBox(
          width: 20.w,
          height: 20.w,
          child: const AppLoader(size: 24, strokeWidth: 2),
        ),
      );
    }

    final branches = state.searchedBranches;
    if (branches.isEmpty) {
      return Center(
        child: Text(
          'No branches found',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    return ListView.separated(
      padding: EdgeInsets.only(bottom: 24.h),
      itemCount: branches.length,
      separatorBuilder: (context, index) => SizedBox(height: 16.h),
      itemBuilder: (context, index) {
        final branch = branches[index];
        final hasAnyPendingRequest = branches.any((b) => b.has_pending_request == true);
        return _buildBranchCard(branch, state.joinInfo.status == OperationStatus.loading, hasAnyPendingRequest);
      },
    );
  }

  Widget _buildBranchCard(dynamic branch, bool isRequesting, bool hasAnyPendingRequest) {
    final name = branch.name ?? '';
    final code = branch.code ?? '';
    final isHq = branch.is_hq == true;
    final int employeeCount = branch.employee_count ?? 0;
    final Map<String, dynamic>? owner = branch.owner;
    final String ownerName = owner?['name'] ?? 'Unknown';
    
    String formattedDate = '';
    if (branch.created_at.isNotEmpty) {
      final date = DateTime.tryParse(branch.created_at);
      if (date != null) {
        formattedDate = '${date.day}/${date.month}/${date.year}';
      }
    }
    
    String locationText = 'Location unavailable';
    if (branch.addresses != null && branch.addresses!.isNotEmpty) {
      final addr = branch.addresses!.first;
      final parts = <String>[];
      if (addr.area.isNotEmpty) parts.add(addr.area);
      if (addr.locality.isNotEmpty) parts.add(addr.locality);
      if (addr.city.isNotEmpty) parts.add(addr.city);
      if (addr.state.isNotEmpty) parts.add(addr.state);
      if (parts.isNotEmpty) {
        locationText = parts.join(', ');
      }
    }

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.borderGrey),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (isHq)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'HQ',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                )
              else
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: AppColors.softGrey,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    'BRANCH',
                    style: TextStyle(
                      fontSize: 9.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            'CODE: $code',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: AppColors.textTertiary,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, color: AppColors.primaryGreen, size: 16.w),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  locationText,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Icon(Icons.person, color: AppColors.textTertiary, size: 14.w),
              SizedBox(width: 4.w),
              Text(
                'Owner: $ownerName',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              const Spacer(),
              Icon(Icons.people, color: AppColors.textTertiary, size: 14.w),
              SizedBox(width: 4.w),
              Text(
                '$employeeCount Employees',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          if (formattedDate.isNotEmpty) ...[
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.textTertiary, size: 14.w),
                SizedBox(width: 4.w),
                Text(
                  'Created: $formattedDate',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
          SizedBox(height: 16.h),
          if (branch.has_pending_request == true)
            AppButton(
              text: 'WITHDRAW REQUEST',
              isLoading: isRequesting,
              onPressed: () => _onWithdrawRequest(branch.id),
              backgroundColor: AppColors.error,
            )
          else
            AppButton(
              text: hasAnyPendingRequest
                  ? 'CANNOT JOIN MULTIPLE'
                  : BranchConstant.REQUEST_TO_JOIN,
              isLoading: isRequesting,
              onPressed: hasAnyPendingRequest ? () {} : () => _onRequestJoin(branch.id),
              backgroundColor: hasAnyPendingRequest ? AppColors.borderGrey : AppColors.primaryGreen,
              textColor: hasAnyPendingRequest ? AppColors.textTertiary : AppColors.pureWhite,
            ),
        ],
      ),
    );
  }
}
