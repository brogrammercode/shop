import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';













class BillingPage extends StatelessWidget { const BillingPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Billing")); }
class OrdersPage extends StatelessWidget { const OrdersPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Orders")); }
class EmployeesPage extends StatelessWidget { const EmployeesPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Employees")); }
class ProductsPage extends StatelessWidget { const ProductsPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Products")); }
class SettingsPage extends StatelessWidget { const SettingsPage({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Settings")); }

enum MainTab { billing, orders, more }

enum MoreTab { employees, products, settings }

class HomeLayoutPage extends StatefulWidget {
  const HomeLayoutPage({super.key});

  @override
  State<HomeLayoutPage> createState() => _HomeLayoutPageState();
}

class _HomeLayoutPageState extends State<HomeLayoutPage> {
  bool _contextLoaded = false;
  MainTab _mainTab = MainTab.billing;
  MoreTab? _moreTab;
  bool _showMoreNav = false;

  @override
  void initState() {
    super.initState();
    _loadContext();
  }

  Future<void> _loadContext() async {
    final data = null;
    if (data != null && mounted) {
      setState(() {
        _contextLoaded = true;
      });
    }
  }

  Widget _buildBody() {
    if (!_contextLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      );
    }

    if (_mainTab == MainTab.billing) {
      return const BillingPage();
    } else if (_mainTab == MainTab.orders) {
      return const OrdersPage();
    } else if (_mainTab == MainTab.more) {
      if (_moreTab == MoreTab.employees) {
        return const EmployeesPage();
      } else if (_moreTab == MoreTab.products) {
        return const ProductsPage();
      } else if (_moreTab == MoreTab.settings) {
        return const SettingsPage();
      }
    }

    return const Center(child: Text('Select an option'));
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: isActive
            ? EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h)
            : EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFE8F5E9) : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isActive ? AppColors.primaryGreen : AppColors.textTertiary,
              size: 20.w,
            ),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? AppColors.primaryGreen
                    : AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrimaryNavBar() {
    return Positioned(
      bottom: 24.h,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.pureWhite,
            borderRadius: BorderRadius.circular(40.r),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000), // 8% opacity black
                blurRadius: 24,
                spreadRadius: 0,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildNavItem(
                icon: Icons.receipt_long,
                label: 'Billing',
                isActive: _mainTab == MainTab.billing,
                onTap: () {
                  setState(() {
                    _mainTab = MainTab.billing;
                    _showMoreNav = false;
                  });
                },
              ),
              _buildNavItem(
                icon: Icons.list_alt,
                label: 'Orders',
                isActive: _mainTab == MainTab.orders,
                onTap: () {
                  setState(() {
                    _mainTab = MainTab.orders;
                    _showMoreNav = false;
                  });
                },
              ),
              _buildNavItem(
                icon: Icons.more_horiz,
                label: 'More',
                isActive: _mainTab == MainTab.more || _showMoreNav,
                onTap: () {
                  setState(() {
                    _showMoreNav = !_showMoreNav;
                    if (_showMoreNav) {
                      _mainTab = MainTab.more;
                      _moreTab ??= MoreTab.employees;
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryNavBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: _showMoreNav ? (24.h + 60.h + 16.h) : -60.h,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 200),
        opacity: _showMoreNav ? 1.0 : 0.0,
        child: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.pureWhite,
              borderRadius: BorderRadius.circular(40.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 24,
                  spreadRadius: 0,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildNavItem(
                  icon: Icons.people,
                  label: 'Employees',
                  isActive:
                      _moreTab == MoreTab.employees && _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.more;
                      _moreTab = MoreTab.employees;
                      _showMoreNav =
                          false; // Hide after selection, or leave open? Usually stays or closes. Let's close it so the user can interact with the screen.
                    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.inventory_2,
                  label: 'Products',
                  isActive:
                      _moreTab == MoreTab.products && _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.more;
                      _moreTab = MoreTab.products;
                      _showMoreNav = false;
                    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.settings,
                  label: 'Settings',
                  isActive:
                      _moreTab == MoreTab.settings && _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.more;
                      _moreTab = MoreTab.settings;
                      _showMoreNav = false;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.softGrey,
      body: Container(
child: Stack(
          children: [
            Positioned.fill(child: _buildBody()),
            // Semi-transparent overlay when More nav is open
            if (_showMoreNav)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _showMoreNav = false;
                    });
                  },
                  child: Container(color: Colors.black.withOpacity(0.1)),
                ),
              ),
            _buildSecondaryNavBar(),
            _buildPrimaryNavBar(),
          ],
        ),
      ),
    );
  }
}
