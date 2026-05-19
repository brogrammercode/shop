import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';
import 'package:mobile/features/business/components/business_action_tile.dart';
import 'package:mobile/features/business/constants/business.dart';

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
                        Container(
                          width: 72.w,
                          height: 72.w,
                          decoration: BoxDecoration(
                            color: AppColors.pureWhite.withOpacity(0.14),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Icon(
                            Icons.storefront,
                            color: AppColors.pureWhite,
                            size: 38.w,
                          ),
                        ),
                        SizedBox(height: 28.h),
                        Text(
                          BusinessConstants.discoverTitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(color: AppColors.pureWhite),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          BusinessConstants.discoverSubtitle,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.pureWhite.withOpacity(0.86),
                              ),
                        ),
                        const Spacer(),
                        BusinessActionTile(
                          title: BusinessConstants.findBusiness,
                          subtitle: BusinessConstants.searchExistingBusiness,
                          icon: Icons.search,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.findBusiness,
                            );
                          },
                        ),
                        SizedBox(height: 16.h),
                        BusinessActionTile(
                          title: BusinessConstants.createBusiness,
                          subtitle: BusinessConstants.createBusinessSubtitle,
                          icon: Icons.add_business,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.createBusiness,
                            );
                          },
                        ),
                        const Spacer(),
                        AppButton(
                          text: BusinessConstants.createBusiness,
                          backgroundColor: AppColors.deepOnyx,
                          textColor: AppColors.pureWhite,
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.createBusiness,
                            );
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
