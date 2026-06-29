import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/core/color.dart';

class DummySlide {
  final String title;
  final String imageUrl;
  final bool isSpecialDeals;
  final String logoText;
  const DummySlide(
    this.title,
    this.imageUrl,
    this.isSpecialDeals,
    this.logoText,
  );
}

const dummyLoginSlides = [
  DummySlide(
    'Welcome',
    'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8M3x8Zm9vZHxlbnwwfHwwfHx8MA%3D%3D',
    false,
    'Ladyluck',
  ),
  DummySlide(
    'Deals',
    'https://images.unsplash.com/photo-1511690656952-34342bb7c2f2?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTh8fGZvb2R8ZW58MHx8MHx8fDA%3D',
    true,
    '',
  ),
];

class UserConstant {
  static const String chooseYourAccount = 'Choose your account';
  static const String unknownUser = 'Unknown User';
  static const String logInOrSignUp = 'Log in or sign up';
  static const String enterPhoneNumber = 'Enter phone number';
  static const String enterOtp = 'Enter OTP';
  static String resendOtpIn(int secs) => 'Resend OTP in $secs s';
  static const String resendOtp = 'Resend OTP';
  static const String rememberLogin = 'Remember Login';
  static const String verifyOtp = 'Verify OTP';
  static const String continueText = 'Continue';
  static const String pleaseEnterPhoneNumber = 'Please enter phone number';
  static const String pleaseEnterOtp = 'Please enter OTP';
  static const String byContinuingYouAgreeToOur =
      'By continuing you agree to our';
  static const String termsOfService = 'Terms of Service';
  static const String privacyPolicy = 'Privacy Policy';
  static const String contentPolicies = 'Content Policies';
  static const String termsOfServiceUrl = 'https://example.com/terms';
  static const String privacyPolicyUrl = 'https://example.com/privacy';
  static const String contentPoliciesUrl = 'https://example.com/content';
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
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
    final profile = null;
    if (mounted && profile != null) {
      setState(() {
        _savedProfile = profile;
      });
    }
    if (mounted) {
      // getAdBanners
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
      body: Container(
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
    final adBanners = [];
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
    final contactDisplay = (phoneRaw != null && phoneRaw.isNotEmpty)
        ? phoneRaw
        : (emailRaw ?? '');
    final avatar = user['avatar_url'] as String?;

    return Builder(
      builder: (context) {
        final isLoading = false;
        return GestureDetector(
          onTap: () {
            // login
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
                    child: Icon(
                      Icons.person,
                      color: AppColors.textSecondary,
                      size: 24.r,
                    ),
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
                      setState(() {
                        _otpSent = true;
                      });
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
    return Builder(
      builder: (context) {
        final isSending = false;
        final isVerifying = false;
        final isLoading = isSending || isVerifying;

        return AppButton(
          text: _otpSent ? UserConstant.verifyOtp : UserConstant.continueText,
          backgroundColor: const Color(0xFFEF4F5F),
          isLoading: isLoading,
          onPressed: () {
            final phone = _phoneController.text.trim();
            if (phone.isEmpty) {
              Fluttertoast.showToast(msg: UserConstant.pleaseEnterPhoneNumber);
              return;
            }
            if (!_otpSent) {
              // sendOtp
            } else {
              final otp = _otpController.text.trim();
              if (otp.isEmpty) {
                Fluttertoast.showToast(msg: UserConstant.pleaseEnterOtp);
                return;
              }
              Navigator.pushNamed(context, '/crossroad');
            }
          },
        );
      },
    );
  }

  Widget _buildSocialLoginRow() {
    return Builder(
      builder: (context) {
        final isLoading = false;
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/crossroad');
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
