import 'package:flutter/material.dart';
import 'package:user/features/setting/setting.dart';

class SettingConstant {
  static const String PAGE_TITLE = 'Settings';
  static const String DEFAULT_AVATAR_URL = 'https://ui-avatars.com/api/?name=User&background=random';
  static const String EDIT_PROFILE = 'Edit profile';
  static const String RENEW_MEMBERSHIP = 'Renew your Gold Membership';
  static const String ZOMATO_MONEY = 'Zomato Money';
  static const String YOUR_COUPONS = 'Your coupons';
  static const String RUPEES_ZERO = '₹0';
  static const String VEG_MODE = 'Veg Mode';
  static const String ON = 'On';
  static const String OFF = 'Off';
  static const String FEEDING_INDIA = 'Feeding India';
  static const String YOUR_IMPACT = 'Your impact';
  static const String LOG_OUT = 'Log out';
  static const String FEEDING_INDIA_BANNER_TEXT = "1 meal served! You've already won a smile.";
  static const String LOGIN_ROUTE = '/login';

  static const List<SettingCategory> SETTING_CATEGORIES = [
    SettingCategory(
      title: 'Your preferences',
      items: [
        SettingItem(
          label: 'Veg Mode',
          icon: Icons.eco,
          trailingText: 'On',
        ),
        SettingItem(
          label: 'Show personalised ratings',
          icon: Icons.star_border,
          hasSwitch: true,
        ),
        SettingItem(
          label: 'Appearance',
          icon: Icons.palette_outlined,
          trailingText: 'Light',
        ),
        SettingItem(
          label: 'Payment methods',
          icon: Icons.credit_card_outlined,
        ),
      ],
    ),
    SettingCategory(
      title: 'Food delivery',
      items: [
        SettingItem(
          label: 'Your orders',
          icon: Icons.receipt_long_outlined,
        ),
        SettingItem(
          label: 'Address book',
          icon: Icons.home_outlined,
        ),
        SettingItem(
          label: 'Your collections',
          icon: Icons.bookmark_border,
        ),
        SettingItem(
          label: 'Manage recommendations',
          icon: Icons.psychology_outlined,
        ),
        SettingItem(
          label: 'Order on train',
          icon: Icons.train_outlined,
        ),
      ],
    ),
    SettingCategory(
      title: 'Gift cards & credits',
      items: [
        SettingItem(
          label: 'Buy Gift Card',
          icon: Icons.card_giftcard_outlined,
        ),
        SettingItem(
          label: 'Claim Gift Card',
          icon: Icons.confirmation_number_outlined,
        ),
        SettingItem(
          label: 'Zomato Credits',
          icon: Icons.monetization_on_outlined,
        ),
      ],
    ),
    SettingCategory(
      title: 'Zomato For Enterprise',
      items: [
        SettingItem(
          label: 'For employers',
          icon: Icons.business_outlined,
        ),
        SettingItem(
          label: 'For employees',
          icon: Icons.badge_outlined,
        ),
      ],
    ),
    SettingCategory(
      title: 'Feeding India',
      items: [
        SettingItem(
          label: 'Your impact',
          icon: Icons.volunteer_activism_outlined,
        ),
        SettingItem(
          label: 'Get donation receipt',
          icon: Icons.description_outlined,
        ),
      ],
    ),
    SettingCategory(
      title: 'Memberships & rewards',
      items: [
        SettingItem(
          label: 'Redeem Gold coupon',
          icon: Icons.percent_outlined,
        ),
        SettingItem(
          label: 'ZPL Hand Cricket',
          icon: Icons.sports_cricket_outlined,
        ),
      ],
    ),
    SettingCategory(
      title: 'More',
      items: [
        SettingItem(
          label: 'Your feedback',
          icon: Icons.thumb_up_alt_outlined,
        ),
        SettingItem(
          label: 'About',
          icon: Icons.info_outline,
        ),
        SettingItem(
          label: 'Send feedback',
          icon: Icons.rate_review_outlined,
        ),
        SettingItem(
          label: 'Report a safety emergency',
          icon: Icons.report_problem_outlined,
        ),
        SettingItem(
          label: 'Accessibility',
          icon: Icons.accessibility_new_outlined,
        ),
        SettingItem(
          label: 'Settings',
          icon: Icons.settings_outlined,
        ),
        SettingItem(
          label: 'Log out',
          icon: Icons.logout_outlined,
        ),
      ],
    ),
  ];
}
