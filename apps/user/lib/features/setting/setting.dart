import 'package:flutter/material.dart';

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
