import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

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
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'PROFILE'),
            _buildSettingTile(
              context,
              icon: Icons.person_outline,
              iconColor: Colors.blueAccent,
              title: 'Edit Profile',
              onTap: () => Navigator.pushNamed(context, AppRoutes.editProfile),
            ),
            _buildSettingTile(
              context,
              icon: Icons.shield_outlined,
              iconColor: Colors.greenAccent,
              title: 'Account Security',
              onTap: () {},
            ),
            SizedBox(height: 32.h),
            _buildSectionHeader(context, 'GANG'),
            _buildSettingTile(
              context,
              icon: Icons.group_add_outlined,
              iconColor: Colors.orangeAccent,
              title: 'Join a Gang (Case A)',
              onTap: () => Navigator.pushNamed(context, AppRoutes.joinGang),
            ),
            _buildSettingTile(
              context,
              icon: Icons.groups_outlined,
              iconColor: Colors.blueAccent,
              title: 'Pro Gamer Squad (Case B - Owner)',
              onTap: () => Navigator.pushNamed(context, AppRoutes.editGang),
            ),
            _buildSettingTile(
              context,
              icon: Icons.groups_outlined,
              iconColor: Colors.greenAccent,
              title: 'Noob Slayers (Case C - Member)',
              onTap: () => Navigator.pushNamed(context, AppRoutes.editPlayer),
            ),
            SizedBox(height: 32.h),
            _buildSectionHeader(context, 'NOTIFICATIONS'),
            _buildSettingTile(
              context,
              icon: Icons.notifications_none_outlined,
              iconColor: Colors.redAccent,
              title: 'Global Alerts',
              trailing: Switch(
                value: true,
                onChanged: (v) {},
                activeColor: AppColors.primaryIndigo,
              ),
            ),
            _buildSettingTile(
              context,
              icon: Icons.sync_outlined,
              iconColor: Colors.purpleAccent,
              title: 'Game Launch Sync',
              onTap: () {},
            ),
            SizedBox(height: 32.h),
            _buildSectionHeader(context, 'TECHNICAL'),
            _buildSettingTile(
              context,
              icon: Icons.volume_up_outlined,
              iconColor: Colors.cyanAccent,
              title: 'Voice & Audio',
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              icon: Icons.speed_outlined,
              iconColor: Colors.tealAccent,
              title: 'Performance Monitor',
              onTap: () {},
            ),
            _buildSettingTile(
              context,
              icon: Icons.dark_mode_outlined,
              iconColor: Colors.indigoAccent,
              title: 'Theme & Appearance',
              onTap: () {},
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h, left: 4.w),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondary.withOpacity(0.5),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: AppColors.softGrey.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Icon(icon, color: iconColor, size: 24.w),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.deepOnyx,
          ),
        ),
        trailing: trailing ??
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary.withOpacity(0.3),
              size: 20.w,
            ),
      ),
    );
  }
}
