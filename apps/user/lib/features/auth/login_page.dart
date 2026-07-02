import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/core/color.dart';
import 'package:user/core/routes.dart';
import 'package:user/features/auth/auth.cubit.dart';
import 'package:user/features/auth/auth.state.dart';
import 'package:user/features/auth/user.constant.dart';
import 'package:pinput/pinput.dart';
import 'package:user/constants/country.constant.dart';
import 'package:user/components/ui/country_picker.dart';
import 'package:user/components/ui/button.dart';
import 'package:user/utils/error.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _rememberLogin = true;
  bool _otpSent = false;
  int _resendSeconds = 30;
  Timer? _resendTimer;
  bool _canResend = false;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  CountryModel _selectedCountry = const CountryModel(
    name: 'India',
    flag: '🇮🇳',
    dialCode: '+91',
    maxLength: 10,
  );

  @override
  void initState() {
    super.initState();
  }

  void _startResendTimer() {
    setState(() {
      _resendSeconds = 30;
      _canResend = false;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds > 0 && mounted) {
        setState(() {
          _resendSeconds--;
        });
      } else {
        if (mounted) {
          setState(() {
            _canResend = true;
          });
        }
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _showCountryPicker() {
    CountryPickerBottomSheet.show(
      context: context,
      selectedCountry: _selectedCountry,
      onCountrySelected: (country) {
        setState(() {
          _selectedCountry = country;
          _phoneController.clear();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.sendOtpInfo.status != current.sendOtpInfo.status,
            listener: (context, state) {
              if (state.sendOtpInfo.status == OperationStatus.success) {
                Fluttertoast.showToast(msg: UserConstant.OTP_SENT_SUCCESSFULLY);
                if (!_otpSent) {
                  setState(() {
                    _otpSent = true;
                  });
                }
                _startResendTimer();
              }
            },
          ),
          BlocListener<AuthCubit, AuthState>(
            listenWhen: (previous, current) =>
                previous.loginInfo.status != current.loginInfo.status ||
                previous.googleSignInInfo.status != current.googleSignInInfo.status,
            listener: (context, state) {
              if (state.loginInfo.status == OperationStatus.success ||
                  state.googleSignInInfo.status == OperationStatus.success) {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              }
            },
          ),
        ],
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                children: [
                  _buildTopCarousel(),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 16.h,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  UserConstant.LOG_IN_OR_SIGN_UP,
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textTertiary,
                                  ),
                                ),
                              ),
                              SizedBox(height: 12.h),
                              if (_otpSent) ...[
                                _buildOtpInputField(),
                              ] else ...[
                                _buildPhoneInputField(),
                              ],
                              SizedBox(height: 12.h),
                              _buildRememberLoginOption(),
                              SizedBox(height: 16.h),
                              _buildContinueButton(),
                              SizedBox(height: 20.h),
                              _buildSocialDivider(),
                              SizedBox(height: 16.h),
                              _buildSocialButtons(),
                            ],
                          ),
                          _buildFooterLinks(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopCarousel() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(color: AppColors.primaryGreen),
          ),
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
            padding: EdgeInsets.symmetric(
              horizontal: 24.w,
              vertical: 40.h,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset('assets/logo.png', width: 80.w, height: 80.w),
                SizedBox(height: 16.h),
                Text(
                  UserConstant.WELCOME_TITLE,
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
                  UserConstant.WELCOME_SUBTITLE,
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

  Widget _buildPhoneInputField() {
    return Row(
      children: [
        GestureDetector(
          onTap: _showCountryPicker,
          child: Container(
            height: 42.h,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFCCCCCC)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _selectedCountry.flag,
                  style: TextStyle(fontSize: 18.sp),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textPrimary,
                  size: 16.w,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Container(
            height: 42.h,
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: const Color(0xFFCCCCCC)),
            ),
            child: Row(
              children: [
                Text(
                  '${_selectedCountry.dialCode} ',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_selectedCountry.maxLength),
                    ],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: UserConstant.ENTER_PHONE_NUMBER,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpInputField() {
    return Column(
      children: [
        Pinput(
          controller: _otpController,
          length: 6,
          autofillHints: const [AutofillHints.oneTimeCode],
          defaultPinTheme: PinTheme(
            width: 48.w,
            height: 56.h,
            textStyle: TextStyle(
              fontSize: 20.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              border: Border.all(color: const Color(0xFFCCCCCC)),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          focusedPinTheme: PinTheme(
            width: 48.w,
            height: 56.h,
            textStyle: TextStyle(
              fontSize: 20.sp,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              border: Border.all(color: AppColors.primaryGreen, width: 2),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
        ),
        SizedBox(height: 16.h),
        BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (prev, curr) => prev.sendOtpInfo.status != curr.sendOtpInfo.status,
          builder: (context, state) {
            final isSending = state.sendOtpInfo.status == OperationStatus.loading;
            if (isSending) {
              return SizedBox(
                width: 16.w,
                height: 16.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFEF4F5F)),
                ),
              );
            }
            return GestureDetector(
              onTap: _canResend
                  ? () {
                      final phone = _phoneController.text.trim();
                      context.read<AuthCubit>().sendOtp(
                        '${_selectedCountry.dialCode}$phone',
                      );
                    }
                  : null,
              child: Text(
                _canResend ? UserConstant.RESEND_OTP : UserConstant.RESEND_OTP_IN(_resendSeconds),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: _canResend ? const Color(0xFFEF4F5F) : AppColors.textTertiary,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRememberLoginOption() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _rememberLogin = !_rememberLogin;
            });
          },
          child: Container(
            width: 18.w,
            height: 18.w,
            decoration: BoxDecoration(
              color: _rememberLogin
                  ? const Color(0xFFEF4F5F)
                  : Colors.transparent,
              border: Border.all(
                color: _rememberLogin
                    ? const Color(0xFFEF4F5F)
                    : AppColors.textSecondary,
                width: 1.5.w,
              ),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: _rememberLogin
                ? Icon(Icons.check, color: AppColors.pureWhite, size: 12.w)
                : null,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          UserConstant.rememberLogin,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        final isSending = state.sendOtpInfo.status == OperationStatus.loading;
        final isVerifying = state.loginInfo.status == OperationStatus.loading;
        final isLoading = isSending || isVerifying;

        return AppButton(
          isLoading: isLoading,
          onPressed: isLoading
              ? () {}
              : () {
                  final phone = _phoneController.text.trim();
                  if (phone.isEmpty) {
                    Fluttertoast.showToast(
                      msg: UserConstant.PLEASE_ENTER_PHONE_NUMBER,
                    );
                    return;
                  }
                  if (!_otpSent) {
                    context.read<AuthCubit>().sendOtp(
                          '${_selectedCountry.dialCode}$phone',
                        );
                  } else {
                    final otp = _otpController.text.trim();
                    if (otp.isEmpty) {
                      Fluttertoast.showToast(
                        msg: UserConstant.PLEASE_ENTER_OTP,
                      );
                      return;
                    }
                    context.read<AuthCubit>().login(
                          '${_selectedCountry.dialCode}$phone',
                          otp,
                          rememberLogin: _rememberLogin,
                        );
                  }
                },
          text: _otpSent
              ? UserConstant.VERIFY_OTP
              : UserConstant.continueText,
        );
      },
    );
  }

  Widget _buildSocialDivider() {
    return Row(
      children: [
        Expanded(child: Container(height: 1.h, color: AppColors.borderGrey)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            UserConstant.orContinueWith,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        Expanded(child: Container(height: 1.h, color: AppColors.borderGrey)),
      ],
    );
  }

  Widget _buildSocialButtons() {
    return BlocBuilder<AuthCubit, AuthState>(
      buildWhen: (prev, curr) => prev.googleSignInInfo.status != curr.googleSignInInfo.status,
      builder: (context, state) {
        final isGoogleLoading = state.googleSignInInfo.status == OperationStatus.loading;

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSocialButton(
              onTap: isGoogleLoading
                  ? null
                  : () => context.read<AuthCubit>().loginWithGoogle(),
              isLoading: isGoogleLoading,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildGoogleIcon(),
                  SizedBox(width: 8.w),
                  Text(
                    UserConstant.continueWithGoogle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSocialButton({
    required VoidCallback? onTap,
    required Widget child,
    bool isLoading = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44.h,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
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
            ? Center(
                child: SizedBox(
                  width: 18.w,
                  height: 18.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.textSecondary,
                    ),
                  ),
                ),
              )
            : child,
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 20.w,
      height: 20.w,
      child: Image.network(
        'https://developers.google.com/identity/images/g-logo.png',
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildFooterLinks() {
    return Column(
      children: [
        Divider(color: const Color(0xFFEEEEEE), thickness: 1.h),
        SizedBox(height: 12.h),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.textTertiary,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: UserConstant.byContinuingYouAgreeToOur),
              TextSpan(
                text: UserConstant.termsOfService,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri.parse(UserConstant.termsOfServiceUrl)),
              ),
              const TextSpan(text: UserConstant.bulletPoint),
              TextSpan(
                text: UserConstant.privacyPolicy,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri.parse(UserConstant.privacyPolicyUrl)),
              ),
              const TextSpan(text: UserConstant.bulletPoint),
              TextSpan(
                text: UserConstant.contentPolicies,
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textSecondary,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => launchUrl(Uri.parse(UserConstant.contentPoliciesUrl)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


