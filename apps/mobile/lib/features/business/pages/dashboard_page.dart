import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/business/constants/business.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/business/cubit/business_state.dart';
import 'package:mobile/features/business/models/business_context_model.dart';
import 'package:mobile/features/business/models/business_join_request_model.dart';
import 'package:mobile/utils/error.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessCubit>().getPendingJoinRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final argument = ModalRoute.of(context)?.settings.arguments;
    final businessState = context.watch<BusinessCubit>().state;
    final cubitContext = businessState.context;
    final contextModel = argument is BusinessContextModel
        ? argument
        : cubitContext;
    final businessName =
        contextModel?.business.name ?? BusinessConstants.fallbackWorkspace;
    final branchName =
        contextModel?.branch.name ?? BusinessConstants.fallbackBranch;
    final permissions =
        contextModel?.permissions.join(', ') ?? BusinessConstants.allPermission;
    final canReviewJoinRequests =
        contextModel?.permissions.contains(BusinessConstants.allPermission) ==
            true ||
        contextModel?.permissions.contains(
              BusinessConstants.employeeWritePermission,
            ) ==
            true;

    return BlocListener<BusinessCubit, BusinessState>(
      listenWhen: (previous, current) =>
          previous.joinApprovalInfo.status != current.joinApprovalInfo.status,
      listener: (context, state) {
        if (state.joinApprovalInfo.status == OperationStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.joinApprovalInfo.error?.message ??
                    BusinessConstants.requiredFieldMessage,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        appBar: AppBar(
          backgroundColor: AppColors.pureWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            BusinessConstants.dashboardTitle,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(24.r),
                          decoration: BoxDecoration(
                            color: AppColors.primaryIndigo,
                            borderRadius: BorderRadius.circular(32.r),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.verified,
                                color: AppColors.pureWhite,
                                size: 42.w,
                              ),
                              SizedBox(height: 24.h),
                              Text(
                                BusinessConstants.dashboardSubtitle,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(color: AppColors.pureWhite),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                businessName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.pureWhite.withOpacity(
                                        0.88,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        _ContextTile(
                          label: BusinessConstants.businessLabel,
                          value: businessName,
                          icon: Icons.storefront,
                        ),
                        SizedBox(height: 12.h),
                        _ContextTile(
                          label: BusinessConstants.branchLabel,
                          value: branchName,
                          icon: Icons.apartment,
                        ),
                        SizedBox(height: 12.h),
                        _ContextTile(
                          label: BusinessConstants.permissionsLabel,
                          value: permissions,
                          icon: Icons.admin_panel_settings_outlined,
                        ),
                        if (canReviewJoinRequests) ...[
                          SizedBox(height: 24.h),
                          _JoinRequestSection(
                            requests: businessState.pendingJoinRequests,
                            isLoading:
                                businessState.pendingJoinRequestsInfo.status ==
                                OperationStatus.loading,
                            isApproving:
                                businessState.joinApprovalInfo.status ==
                                OperationStatus.loading,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: BusinessConstants.manageProducts,
                        backgroundColor: AppColors.deepOnyx,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.products);
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppButton(
                        text: BusinessConstants.startSelling,
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.counterSale);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JoinRequestSection extends StatelessWidget {
  final List<BusinessJoinRequestModel> requests;
  final bool isLoading;
  final bool isApproving;

  const _JoinRequestSection({
    required this.requests,
    required this.isLoading,
    required this.isApproving,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          BusinessConstants.pendingRequests,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        SizedBox(height: 12.h),
        if (isLoading)
          const Center(child: CircularProgressIndicator())
        else if (requests.isEmpty)
          _ContextTile(
            label: BusinessConstants.pendingRequests,
            value: BusinessConstants.noJoinRequests,
            icon: Icons.group_add_outlined,
          )
        else
          Column(
            children: requests
                .map(
                  (request) => _JoinRequestTile(
                    request: request,
                    isApproving: isApproving,
                  ),
                )
                .toList(),
          ),
      ],
    );
  }
}

class _JoinRequestTile extends StatelessWidget {
  final BusinessJoinRequestModel request;
  final bool isApproving;

  const _JoinRequestTile({required this.request, required this.isApproving});

  @override
  Widget build(BuildContext context) {
    final userName = request.user?.name ?? BusinessConstants.fallbackWorkspace;
    final userEmail = request.user?.email ?? '';

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person_add,
                color: AppColors.primaryIndigo,
                size: 24.w,
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      userEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: AppButton(
                  text: isApproving
                      ? BusinessConstants.approving
                      : BusinessConstants.approve,
                  onPressed: isApproving
                      ? () {}
                      : () {
                          context.read<BusinessCubit>().approveJoinRequest(
                            request.id.toString(),
                          );
                        },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: AppButton(
                  text: isApproving
                      ? BusinessConstants.rejecting
                      : BusinessConstants.reject,
                  backgroundColor: AppColors.deepOnyx,
                  onPressed: isApproving
                      ? () {}
                      : () {
                          context.read<BusinessCubit>().rejectJoinRequest(
                            request.id.toString(),
                          );
                        },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ContextTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ContextTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.softGrey,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryIndigo, size: 24.w),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
