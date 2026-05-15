import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/constants/assets.dart';
import 'package:mobile/core/routes.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            Icons.lightbulb_outline,
                            size: 120.w,
                            color: AppColors.primaryIndigo,
                          ),
                        ),
                        SizedBox(height: 40.h),
                        Text(
                          'Stay connected\ninstantly with\nyour gamer squad',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Notify your friends when you launch a game, join low-latency voice channels and stay in the loop daily.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        AppButton.social(
                          text: 'using Google Signin',
                          backgroundColor: AppColors.googleRed,
                          icon: const Icon(
                            Icons.g_mobiledata,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, AppRoutes.onboarding);
                          },
                        ),

                        SizedBox(height: 24.h),
                        Text(
                          'By tapping "using Google Signin" above, you confirm that you have read, understood, and agree to the Cum Terms and Privacy policy for gamers!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontSize: 10.sp,
                            color: Colors.grey,
                          ),
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
