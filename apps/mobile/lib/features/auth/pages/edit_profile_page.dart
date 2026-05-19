import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/components/ui/button.dart';
import 'package:mobile/components/ui/input.dart';
import 'package:mobile/core/color.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pureWhite,
      appBar: AppBar(
        backgroundColor: AppColors.pureWhite,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepOnyx),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Edit Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: AppColors.softGrey,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primaryIndigo.withOpacity(0.1),
                        width: 4,
                      ),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      size: 60.w,
                      color: AppColors.primaryIndigo,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: AppColors.primaryIndigo,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 20.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            const AppInput(
              hintText: 'GamerTag',
              prefixIcon: Icon(
                Icons.alternate_email,
                color: AppColors.primaryIndigo,
              ),
            ),
            SizedBox(height: 20.h),
            const AppInput(
              hintText: 'Bio',
              prefixIcon: Icon(
                Icons.info_outline,
                color: AppColors.primaryIndigo,
              ),
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 40.h),
            AppButton(
              text: 'Save Changes',
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
