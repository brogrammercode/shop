import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/loader.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/core_hr/constants/hr.constant.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.cubit.dart';
import 'package:mobile/features/core_hr/controllers/core_hr.state.dart';
import 'package:mobile/services/json_cache.dart';
import 'package:mobile/utils/error.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<void> _continueAfterGoogleSignIn(CoreHrState state) async {
    if (state.requiresPhone) {
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.completePhone);
      }
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
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              children: [
                _buildTopPanel(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox.shrink(),
                        Column(
                          children: [
                            Text(
                              HrConstant.LOG_IN_OR_SIGN_UP,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textTertiary,
                              ),
                            ),
                            SizedBox(height: 14.h),
                            _buildGoogleButton(),
                            SizedBox(height: 22.h),
                            _buildFooterLinks(),
                          ],
                        ),
                      ],
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

  Widget _buildTopPanel() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(child: Container(color: AppColors.primaryGreen)),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.6),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/logo.png', width: 80.w, height: 80.w),
                SizedBox(height: 16.h),
                Text(
                  HrConstant.WELCOME_TITLE,
                  style: TextStyle(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColors.pureWhite,
                    height: 1.2,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  HrConstant.WELCOME_SUBTITLE,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: AppColors.pureWhite.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleButton() {
    return BlocBuilder<CoreHrCubit, CoreHrState>(
      buildWhen: (previous, current) =>
          previous.googleSignInInfo.status != current.googleSignInInfo.status,
      builder: (context, state) {
        final isLoading =
            state.googleSignInInfo.status == OperationStatus.loading;

        return GestureDetector(
          onTap: isLoading
              ? null
              : () async {
                  final cubit = context.read<CoreHrCubit>();
                  final signedIn = await cubit.signInWithGoogle();
                  if (!mounted || !signedIn) {
                    return;
                  }
                  await _continueAfterGoogleSignIn(cubit.state);
                },
          child: Container(
            height: 48.h,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFE8E8E8)),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: isLoading
                ? SizedBox(
                    width: 18.w,
                    height: 18.w,
                    child: const AppLoader(size: 24, strokeWidth: 2),
                  )
                : Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 20.w,
                        height: 20.w,
                        child: Image.network(
                          'https://developers.google.com/identity/images/g-logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        HrConstant.CONTINUE_WITH_GOOGLE,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildFooterLinks() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Column(
        children: [
          Text(
            HrConstant.BY_CONTINUING_YOU_AGREE_TO_OUR.trim(),
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildUnderlinedLink(
                HrConstant.TERMS_OF_SERVICE,
                HrConstant.TERMS_OF_SERVICE_URL,
              ),
              SizedBox(width: 8.w),
              _buildUnderlinedLink(
                HrConstant.PRIVACY_POLICY,
                HrConstant.PRIVACY_POLICY_URL,
              ),
              SizedBox(width: 8.w),
              _buildUnderlinedLink(
                HrConstant.CONTENT_POLICIES,
                HrConstant.CONTENT_POLICIES_URL,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUnderlinedLink(String text, String url) {
    return GestureDetector(
      onTap: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10.sp,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
