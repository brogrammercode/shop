import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/auth/controllers/user.cubit.dart';
import 'package:mobile/features/auth/controllers/user.state.dart';
import 'package:mobile/features/auth/_data_dummy/login_page.dart';
import 'package:mobile/utils/error.dart';
import 'package:mobile/features/auth/constants/user.constant.dart';
import 'package:mobile/services/json_cache.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late PageController _pageController;
  int _activeSlideIndex = 0;
  Timer? _slideTimer;
  bool _rememberLogin = true;
  bool _otpSent = false;
  int _resendSeconds = 30;
  Timer? _resendTimer;
  bool _canResend = false;
  Map<String, dynamic>? _savedProfile;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _initData();
    _slideTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        final nextIndex = (_activeSlideIndex + 1) % dummyLoginSlides.length;
        _pageController.animateToPage(
          nextIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Future<void> _initData() async {
    final cache = JsonCache();
    final profile = await cache.getSavedProfile();
    if (mounted && profile != null) {
      setState(() {
        _savedProfile = profile;
      });
    }
    if (mounted) {
      context.read<UserCubit>().getAdBanners();
    }
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
    _slideTimer?.cancel();
    _resendTimer?.cancel();
    _pageController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      body: BlocListener<UserCubit, UserState>(
        listenWhen: (previous, current) =>
            previous.sendOtpInfo.status != current.sendOtpInfo.status ||
            previous.verifyOtpInfo.status != current.verifyOtpInfo.status ||
            previous.loginInfo.status != current.loginInfo.status,
        listener: (context, state) {
          if (state.sendOtpInfo.status == OperationStatus.success) {
            if (!_otpSent) {
              setState(() {
                _otpSent = true;
              });
            }
            _startResendTimer();
          }
          if (state.verifyOtpInfo.status == OperationStatus.success) {
            if (state.hasEmployeeProfile == true) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.joinBranch);
            }
          }
          if (state.loginInfo.status == OperationStatus.success) {
            if (state.hasEmployeeProfile == true) {
              Navigator.pushReplacementNamed(context, AppRoutes.home);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.joinBranch);
            }
          }
        },
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
                          children: [
                            if (_savedProfile != null) ...[
                              Text(
                                UserConstant.chooseYourAccount,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 12.h),
                              _buildProfileCard(),
                              SizedBox(height: 16.h),
                            ],
                            Text(
                              UserConstant.logInOrSignUp,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textTertiary,
                              ),
                            ),
                            SizedBox(height: 12.h),
                            _buildPhoneInputField(),
                            if (_otpSent) ...[
                              SizedBox(height: 12.h),
                              _buildOtpInputField(),
                            ],
                            SizedBox(height: 12.h),
                            _buildRememberLoginOption(),
                            SizedBox(height: 16.h),
                            _buildContinueButton(),
                            SizedBox(height: 16.h),
                            _buildSocialLoginRow(),
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
    final adBanners = context.watch<UserCubit>().state.adBanners ?? [];
    final hasBanners = adBanners.isNotEmpty;
    final slideCount = hasBanners ? adBanners.length : dummyLoginSlides.length;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _activeSlideIndex = index;
              });
            },
            itemCount: slideCount,
            itemBuilder: (context, index) {
              final title = hasBanners
                  ? adBanners[index].type
                  : dummyLoginSlides[index].title;
              final imageUrl = hasBanners
                  ? adBanners[index].image_url
                  : dummyLoginSlides[index].imageUrl;

              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(imageUrl, fit: BoxFit.cover),
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
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 26.sp,
                            fontWeight: FontWeight.w900,
                            color: AppColors.pureWhite,
                            height: 1.2,
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        if (!hasBanners) ...[
                          dummyLoginSlides[index].isSpecialDeals
                              ? _buildPercentBadge()
                              : _buildZomatoLogoBadge(
                                  dummyLoginSlides[index].logoText,
                                ),
                        ],
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 16.h,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(slideCount, (index) {
                final isActive = _activeSlideIndex == index;
                return Container(
                  width: 6.w,
                  height: 6.w,
                  margin: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive
                        ? AppColors.pureWhite
                        : AppColors.pureWhite.withValues(alpha: 0.4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildZomatoLogoBadge(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4F5F),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          fontWeight: FontWeight.w900,
          fontStyle: FontStyle.italic,
          color: AppColors.pureWhite,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildPercentBadge() {
    return Container(
      width: 28.w,
      height: 28.w,
      decoration: const BoxDecoration(
        color: Color(0xFF1E88E5),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          '%',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w900,
            color: AppColors.pureWhite,
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    if (_savedProfile == null) return const SizedBox.shrink();
    final user = _savedProfile!['user'] as Map<String, dynamic>;
    final name = user['name'] ?? UserConstant.unknownUser;
    final phoneRaw = user['phone_number'] as String?;
    final emailRaw = user['email'] as String?;
    final contactDisplay = (phoneRaw != null && phoneRaw.isNotEmpty) ? phoneRaw : (emailRaw ?? '');
    final avatar = user['avatar_url'] as String?;

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final isLoading = state.loginInfo.status == OperationStatus.loading;
        return GestureDetector(
          onTap: isLoading
              ? null
              : () {
                  context.read<UserCubit>().loginWithSavedProfile();
                },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: const Color(0xFFE8E8E8)),
            ),
            child: Row(
              children: [
                if (avatar != null && avatar.isNotEmpty)
                  CircleAvatar(
                    radius: 20.r,
                    backgroundImage: NetworkImage(avatar),
                  )
                else
                  CircleAvatar(
                    radius: 20.r,
                    backgroundColor: const Color(0xFFF0F0F0),
                    child: Icon(Icons.person, color: AppColors.textSecondary, size: 24.r),
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
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        contactDisplay,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLoading)
                  SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primaryGreen,
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 24.r,
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneInputField() {
    return Row(
      children: [
        Container(
          height: 42.h,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: const Color(0xFFCCCCCC)),
          ),
          child: Row(
            children: [
              _buildIndianFlag(),
              SizedBox(width: 6.w),
              Icon(
                Icons.arrow_drop_down,
                color: AppColors.textPrimary,
                size: 16.w,
              ),
            ],
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
                  '+91 ',
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
                      TextInputFormatter.withFunction((oldValue, newValue) {
                        String text = newValue.text;
                        if (text.startsWith('91') && text.length > 10) {
                          text = text.substring(2);
                        } else if (text.startsWith('0') && text.length > 10) {
                          text = text.substring(1);
                        }
                        if (text.length > 10) {
                          text = text.substring(0, 10);
                        }
                        return TextEditingValue(
                          text: text,
                          selection: TextSelection.collapsed(
                            offset: text.length,
                          ),
                        );
                      }),
                    ],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: UserConstant.enterPhoneNumber,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 42.h,
                margin: EdgeInsets.only(right: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: const Color(0xFFCCCCCC)),
                ),
                child: Center(
                  child: TextField(
                    controller: _otpController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6),
                    ],
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: UserConstant.enterOtp,
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textTertiary,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            GestureDetector(
              onTap: _canResend
                  ? () {
                      final phone = _phoneController.text.trim();
                      context.read<UserCubit>().sendOtp('+91$phone');
                    }
                  : null,
              child: Text(
                _canResend
                    ? UserConstant.resendOtp
                    : UserConstant.resendOtpIn(_resendSeconds),
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: _canResend
                      ? const Color(0xFFEF4F5F)
                      : AppColors.textTertiary,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIndianFlag() {
    return Container(
      width: 20.w,
      height: 13.h,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDDDDD), width: 0.5),
      ),
      child: Column(
        children: [
          Expanded(child: Container(color: const Color(0xFFFF9933))),
          Expanded(
            child: Container(
              color: AppColors.pureWhite,
              child: Center(
                child: Container(
                  width: 3.w,
                  height: 3.w,
                  decoration: const BoxDecoration(
                    color: Color(0xFF000080),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Expanded(child: Container(color: const Color(0xFF128807))),
        ],
      ),
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
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final isSending = state.sendOtpInfo.status == OperationStatus.loading;
        final isVerifying =
            state.verifyOtpInfo.status == OperationStatus.loading;
        final isLoading = isSending || isVerifying;

        return AppButton(
          text: _otpSent ? UserConstant.verifyOtp : UserConstant.continueText,
          backgroundColor: const Color(0xFFEF4F5F),
          isLoading: isLoading,
          onPressed: () {
            final phone = _phoneController.text.trim();
            if (phone.isEmpty) {
              Fluttertoast.showToast(
                msg: UserConstant.pleaseEnterPhoneNumber,
              );
              return;
            }
            if (!_otpSent) {
              context.read<UserCubit>().sendOtp('+91$phone');
            } else {
              final otp = _otpController.text.trim();
              if (otp.isEmpty) {
                Fluttertoast.showToast(
                  msg: UserConstant.pleaseEnterOtp,
                );
                return;
              }
              context.read<UserCubit>().verifyOtp(
                '+91$phone',
                otp,
                rememberLogin: _rememberLogin,
              );
            }
          },
        );
      },
    );
  }

  Widget _buildSocialLoginRow() {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final isLoading = state.loginInfo.status == OperationStatus.loading;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: isLoading
                  ? null
                  : () {
                      context.read<UserCubit>().loginWithGoogle(
                        rememberLogin: _rememberLogin,
                      );
                    },
              child: Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE8E8E8)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryGreen,
                            ),
                          ),
                        )
                      : Image.network(
                          'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                          width: 20.w,
                          height: 20.w,
                        ),
                ),
              ),
            ),
          ],
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
            UserConstant.byContinuingYouAgreeToOur.trim(),
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
                UserConstant.termsOfService,
                UserConstant.termsOfServiceUrl,
              ),
              SizedBox(width: 8.w),
              _buildUnderlinedLink(
                UserConstant.privacyPolicy,
                UserConstant.privacyPolicyUrl,
              ),
              SizedBox(width: 8.w),
              _buildUnderlinedLink(
                UserConstant.contentPolicies,
                UserConstant.contentPoliciesUrl,
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
