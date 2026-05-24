import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user/core/color.dart';
import 'package:user/features/setting/_data_dummy/setting_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isVegModeOn = true;
  bool showPersonalisedRatings = false;

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: Column(
        children: [
          SizedBox(height: statusBarHeight),
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileCard(),
                  SizedBox(height: 16.h),
                  _buildQuickActions(),
                  SizedBox(height: 20.h),
                  _buildCategoryList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      color: const Color(0xFFFAFAFA),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back, color: AppColors.textPrimary, size: 24.w),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.pureWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.r,
                  backgroundImage: NetworkImage(dummyUserProfile.avatarUrl),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dummyUserProfile.name,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: 0.5,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      GestureDetector(
                        onTap: () {},
                        child: Row(
                          children: [
                            Text(
                              'Edit profile',
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primaryGreen,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Icons.arrow_right,
                              color: AppColors.primaryGreen,
                              size: 14.w,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: AppColors.deepOnyx,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(16.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Color(0xFFC99B3B),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.workspace_premium,
                        color: AppColors.deepOnyx,
                        size: 14.w,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Text(
                      'Renew your Gold Membership',
                      style: TextStyle(
                        color: const Color(0xFFFBD786),
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  color: const Color(0xFFFBD786),
                  size: 18.w,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.wallet,
                    color: AppColors.textSecondary,
                    size: 16.w,
                  ),
                ),
                SizedBox(width: 10.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Zomato Money',
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '₹0',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadowColor,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.percent,
                    color: AppColors.textSecondary,
                    size: 16.w,
                  ),
                ),
                SizedBox(width: 10.w),
                Text(
                  'Your coupons',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList() {
    return Column(
      children: dummySettingCategories.map((category) {
        return Container(
          margin: EdgeInsets.only(bottom: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 3.w,
                    height: 16.h,
                    color: AppColors.primaryGreen,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    category.title,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.pureWhite,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: AppColors.borderGrey),
                ),
                child: Column(
                  children: List.generate(category.items.length, (index) {
                    final item = category.items[index];
                    return Column(
                      children: [
                        _buildSettingTile(item, category.title),
                        if (index < category.items.length - 1)
                          Container(height: 1.h, color: AppColors.borderGrey),
                        if (category.title == 'Feeding India' &&
                            item.label == 'Your impact')
                          _buildFeedingIndiaBanner(),
                      ],
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSettingTile(SettingItem item, String categoryTitle) {
    Widget? trailingWidget;

    if (item.hasSwitch) {
      trailingWidget = Switch(
        value: showPersonalisedRatings,
        activeThumbColor: AppColors.pureWhite,
        activeTrackColor: AppColors.primaryGreen,
        inactiveThumbColor: AppColors.textTertiary,
        inactiveTrackColor: AppColors.borderGrey,
        onChanged: (val) {
          setState(() {
            showPersonalisedRatings = val;
          });
        },
      );
    } else if (item.label == 'Veg Mode') {
      trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isVegModeOn ? 'On' : 'Off',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 4.w),
          Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 16.w),
        ],
      );
    } else {
      trailingWidget = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (item.trailingText != null) ...[
            Text(
              item.trailingText!,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 4.w),
          ],
          Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 16.w),
        ],
      );
    }

    return ListTile(
      leading: Icon(
        item.icon,
        color: item.label == 'Veg Mode'
            ? AppColors.primaryGreen
            : AppColors.textSecondary,
        size: 20.w,
      ),
      title: Text(
        item.label,
        style: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
      trailing: trailingWidget,
      onTap: item.hasSwitch
          ? null
          : () {
              if (item.label == 'Veg Mode') {
                setState(() {
                  isVegModeOn = !isVegModeOn;
                });
              } else if (item.label == 'Log out') {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              }
            },
    );
  }

  Widget _buildFeedingIndiaBanner() {
    return Container(
      margin: EdgeInsets.all(12.w),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.favorite, color: const Color(0xFFEF4444), size: 16.w),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              "1 meal served! You've already won a smile.",
              style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFB91C1C),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
