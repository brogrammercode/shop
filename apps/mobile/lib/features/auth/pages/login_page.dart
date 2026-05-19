import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/constants/api.dart';
import 'package:mobile/constants/assets.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/auth/constants/auth.dart';
import 'package:mobile/features/auth/cubit/auth_cubit.dart';
import 'package:mobile/features/auth/cubit/auth_state.dart';
import 'package:mobile/features/business/constants/business.dart';
import 'package:mobile/features/business/cubit/business_cubit.dart';
import 'package:mobile/features/business/cubit/business_state.dart';
import 'package:mobile/utils/error.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listenWhen: (previous, current) =>
              previous.loginInfo.status != current.loginInfo.status,
          listener: (context, state) {
            if (state.loginInfo.status == OperationStatus.success) {
              context.read<BusinessCubit>().getCurrentContext();
            }

            if (state.loginInfo.status == OperationStatus.error) {
              _showMessage(
                context,
                state.loginInfo.error?.message ??
                    AuthConstants.googleSignInUnavailable,
              );
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
              final statusCode = state.contextInfo.error?.statusCode;
              if (statusCode == ApiConstants.notFoundStatusCode) {
                context.read<BusinessCubit>().getMyJoinRequests();
                return;
              }

              _showMessage(
                context,
                state.contextInfo.error?.message ??
                    AuthConstants.googleSignInUnavailable,
              );
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
        backgroundColor: AppColors.pureWhite,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 40.h,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(),
                          Image.asset(
                            AppAssets.bulbIllustration,
                            height: 200.h,
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.storefront,
                              size: 120.w,
                              color: AppColors.primaryIndigo,
                            ),
                          ),
                          SizedBox(height: 40.h),
                          Text(
                            AuthConstants.loginTitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            AuthConstants.loginSubtitle,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const Spacer(),
                          BlocBuilder<AuthCubit, AuthState>(
                            builder: (context, authState) {
                              return BlocBuilder<BusinessCubit, BusinessState>(
                                builder: (context, businessState) {
                                  final isLoading =
                                      authState.loginInfo.status ==
                                          OperationStatus.loading ||
                                      businessState.contextInfo.status ==
                                          OperationStatus.loading ||
                                      businessState.myJoinRequestsInfo.status ==
                                          OperationStatus.loading;

                                  return AppButton.social(
                                    text: isLoading
                                        ? AuthConstants.signingIn
                                        : AuthConstants.continueWithGoogle,
                                    backgroundColor: AppColors.googleRed,
                                    icon: const Icon(
                                      Icons.g_mobiledata,
                                      color: AppColors.pureWhite,
                                    ),
                                    onPressed: isLoading
                                        ? () {}
                                        : () {
                                            context
                                                .read<AuthCubit>()
                                                .loginWithGoogle();
                                          },
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: 24.h),
                          Text(
                            AuthConstants.termsText,
                            textAlign: TextAlign.center,
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 10.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
