import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/constants/assets.dart';
import 'package:mobile/core/routes.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryIndigo,
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
                      children: [
                        Icon(
                          Icons.card_giftcard,
                          color: Colors.white,
                          size: 32.w,
                        ),
                        SizedBox(height: 24.h),
                        Text(
                          'Connect to\nCum App',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        const Spacer(),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 300.h,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(32.r),
                              ),
                            ),
                            Image.asset(
                              AppAssets.welcomeIllustration,
                              height: 250.h,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(
                                    Icons.palette_outlined,
                                    size: 150.w,
                                    color: Colors.white,
                                  ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 16.sp,
                                  fontFamily: GoogleFonts.outfit().fontFamily,
                                ),
                            children: [
                              TextSpan(
                                text: 'Sync',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: GoogleFonts.outfit().fontFamily,
                                ),
                              ),
                              const TextSpan(
                                text:
                                    ' is a smart way to alert friends when you start gaming. Think of it as a low-latency bridge, ensuring your community stays synchronized with your status in real-time always and forever!!',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (int i = 0; i < 4; i++)
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 4.w),
                                height: 8.h,
                                width: 8.w,
                                decoration: BoxDecoration(
                                  color: i == 0
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.3),
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 40.h),
                        AppButton(
                          text: 'Game on! Ready',
                          backgroundColor: AppColors.deepOnyx,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, AppRoutes.home);
                          },
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
    );
  }
}
