import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/auth/cubit/auth_cubit.dart';
import 'package:mobile/features/auth/cubit/auth_state.dart';
import 'package:mobile/features/business/constants/business.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/business/cubit/business_state.dart';
import 'package:mobile/utils/error.dart';

class SessionPage extends StatefulWidget {
  const SessionPage({super.key});

  @override
  State<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends State<SessionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().getCurrentUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.sessionInfo.status != current.sessionInfo.status,
          listener: (context, state) {
            if (state.sessionInfo.status == OperationStatus.success) {
              context.read<BusinessCubit>().getCurrentContext();
            }

            if (state.sessionInfo.status == OperationStatus.error) {
              Navigator.pushReplacementNamed(context, AppRoutes.login);
            }
          },
        ),
        BlocListener<BusinessCubit, BusinessState>(
          listenWhen: (previous, current) =>
              previous.contextInfo.status != current.contextInfo.status,
          listener: (context, state) {
            if (state.contextInfo.status == OperationStatus.success) {
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.dashboard,
                arguments: state.context,
              );
            }

            if (state.contextInfo.status == OperationStatus.error) {
              context.read<BusinessCubit>().getMyJoinRequests();
            }
          },
        ),
        BlocListener<BusinessCubit, BusinessState>(
          listenWhen: (previous, current) =>
              previous.myJoinRequestsInfo.status !=
              current.myJoinRequestsInfo.status,
          listener: (context, state) {
            if (state.myJoinRequestsInfo.status == OperationStatus.success) {
              final hasPendingRequest = state.myJoinRequests.any(
                (request) => request.status == BusinessConstants.pendingStatus,
              );
              Navigator.pushReplacementNamed(
                context,
                hasPendingRequest
                    ? AppRoutes.pendingJoin
                    : AppRoutes.onboarding,
              );
            }

            if (state.myJoinRequestsInfo.status == OperationStatus.error) {
              Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.primaryIndigo,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 42.w,
                    height: 42.w,
                    child: const CircularProgressIndicator(
                      color: AppColors.pureWhite,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    BusinessConstants.checkingSession,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.pureWhite,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
