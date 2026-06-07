import 'package:flutter/material.dart';

class UserProfile {
  final String name;
  final String avatarUrl;
  final bool isGoldMember;
  final double zomatoMoneyBalance;

  const UserProfile({
    required this.name,
    required this.avatarUrl,
    required this.isGoldMember,
    required this.zomatoMoneyBalance,
  });
}

class SettingItem {
  final String label;
  final IconData icon;
  final String? trailingText;
  final String? route;
  final bool hasSwitch;

  const SettingItem({
    required this.label,
    required this.icon,
    this.trailingText,
    this.route,
    this.hasSwitch = false,
  });
}

class SettingCategory {
  final String title;
  final List<SettingItem> items;

  const SettingCategory({
    required this.title,
    required this.items,
  });
}

const UserProfile dummyUserProfile = UserProfile(
  name: 'HARSH',
  avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?w=500',
  isGoldMember: true,
  zomatoMoneyBalance: 0,
);

const List<SettingCategory> dummySettingCategories = [
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

