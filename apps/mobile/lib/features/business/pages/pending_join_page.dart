import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/auth/cubit/auth_cubit.dart';
import 'package:mobile/features/auth/cubit/auth_state.dart';
import 'package:mobile/features/business/constants/business.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/business/cubit/business_state.dart';
import 'package:mobile/utils/error.dart';

class PendingJoinPage extends StatefulWidget {
  const PendingJoinPage({super.key});

  @override
  State<PendingJoinPage> createState() => _PendingJoinPageState();
}

class _PendingJoinPageState extends State<PendingJoinPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BusinessCubit>().getMyJoinRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.logoutInfo.status != current.logoutInfo.status,
          listener: (context, state) {
            if (state.logoutInfo.status == OperationStatus.success) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            }
          },
        ),
        BlocListener<BusinessCubit, BusinessState>(
          listenWhen: (previous, current) =>
              previous.contextInfo.status != current.contextInfo.status,
          listener: (context, state) {
            if (state.contextInfo.status == OperationStatus.success) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.dashboard,
                (route) => false,
                arguments: state.context,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.pureWhite,
        appBar: AppBar(
          backgroundColor: AppColors.pureWhite,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            BusinessConstants.requestSent,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
            child: BlocBuilder<BusinessCubit, BusinessState>(
              builder: (context, state) {
                final requests = state.myJoinRequests;
                final isLoading =
                    state.myJoinRequestsInfo.status == OperationStatus.loading;

                return Column(
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
                            Icons.hourglass_top,
                            color: AppColors.pureWhite,
                            size: 42.w,
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            BusinessConstants.pendingApprovalTitle,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(color: AppColors.pureWhite),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            BusinessConstants.pendingApprovalSubtitle,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: AppColors.pureWhite.withOpacity(0.88),
                                ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (requests.isEmpty)
                      _PendingRequestTile(
                        title: BusinessConstants.noJoinRequests,
                        subtitle: BusinessConstants.pendingApprovalSubtitle,
                        status: BusinessConstants.pendingStatus,
                      )
                    else
                      Expanded(
                        child: ListView.separated(
                          itemCount: requests.length,
                          separatorBuilder: (context, index) =>
                              SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            return _PendingRequestTile(
                              title:
                                  request.business?.name ??
                                  BusinessConstants.fallbackWorkspace,
                              subtitle:
                                  request.branch?.name ??
                                  BusinessConstants.fallbackBranch,
                              status: request.status,
                            );
                          },
                        ),
                      ),
                    const Spacer(),
                    AppButton(
                      text: BusinessConstants.startSelling,
                      onPressed: () {
                        context.read<BusinessCubit>().getCurrentContext();
                      },
                    ),
                    SizedBox(height: 12.h),
                    AppButton(
                      text: BusinessConstants.returnToLogin,
                      backgroundColor: AppColors.deepOnyx,
                      onPressed: () {
                        context.read<AuthCubit>().logout();
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _PendingRequestTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;

  const _PendingRequestTile({
    required this.title,
    required this.subtitle,
    required this.status,
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
          Icon(Icons.schedule, color: AppColors.primaryIndigo, size: 24.w),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primaryIndigo,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
