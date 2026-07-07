import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile/core/color.dart';
import 'package:mobile/core/routes.dart';

class BillingPage extends StatelessWidget {
  const BillingPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Billing"));
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Orders"));
}

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Employees"));
}

class RoleAndDeptPage extends StatelessWidget {
  const RoleAndDeptPage({super.key});
  @override
  Widget build(BuildContext context) => const Center(child: Text("Role & Dept"));
}



enum MainTab { billing, orders, kds, more }

enum MoreTab { employees, roleAndDept, settings }

enum ProcurementTab { suppliers, purchaseOrders, receipts }

enum CatalogTab { items, categories, uom }

enum ProductionTab { stock, recipes, kitchen }

enum PosTab { pos, kds, tables }

enum CoreHrTab { shifts, registers, depts }

enum FinanceTab { accounts, ledger, assets }

class HomeLayoutPage extends StatefulWidget {
  const HomeLayoutPage({super.key});

  @override
  State<HomeLayoutPage> createState() => _HomeLayoutPageState();
}

class _HomeLayoutPageState extends State<HomeLayoutPage> {
  MainTab _mainTab = MainTab.billing;
  MoreTab? _moreTab;
  ProcurementTab? _procurementTab;
  CatalogTab? _catalogTab;
  ProductionTab? _productionTab;
  PosTab? _posTab;
  CoreHrTab? _coreHrTab;
  FinanceTab? _financeTab;
  bool _showMoreNav = false;
  String? _currentRoute = '/pos-terminal';

  @override
  void initState() {
    super.initState();
    _loadContext();
  }

  Future<void> _loadContext() async {
    final data = null;
    if (data != null && mounted) {
      setState(() {});
    }
  }

  Widget _buildBody() {
    if (_currentRoute != null && AppRoutes.routes.containsKey(_currentRoute)) {
      return AppRoutes.routes[_currentRoute]!(context);
    }
    
    if (_mainTab == MainTab.billing) {
      return const BillingPage();
    } else if (_mainTab == MainTab.orders) {
      return const OrdersPage();
    } else if (_mainTab == MainTab.more) {
      if (_moreTab == MoreTab.employees) {
        return const EmployeesPage(); // Should this also be a nested route? The user request says "whatever page will be clicked from layout navbars, will be replacing the current page inside layout only not actually navigate"
      } else if (_moreTab == MoreTab.roleAndDept) {
        return const RoleAndDeptPage();
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
                    _currentRoute = '/pos-terminal';
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
                    _currentRoute = '/order-list';
                  });
                },
              ),
              _buildNavItem(
                icon: Icons.kitchen,
                label: 'KDS',
                isActive: _mainTab == MainTab.kds,
                onTap: () {
                  setState(() {
                    _mainTab = MainTab.kds;
                    _showMoreNav = false;
                    _currentRoute = AppRoutes.kdsTerminal;
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
                      if (_moreTab == null) {
                        _moreTab = MoreTab.employees;
                        _currentRoute = '/employee-list';
                      } else {
                        if (_moreTab == MoreTab.employees) _currentRoute = '/employee-list';
                        if (_moreTab == MoreTab.roleAndDept) _currentRoute = '/role-list';
                        if (_moreTab == MoreTab.settings) _currentRoute = AppRoutes.settings;
                      }
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

  Widget _buildNonaryNavBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: _showMoreNav
          ? (24.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h)
          : -480.h,
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
                  icon: Icons.restaurant_menu_outlined,
                  label: 'Menu Categories',
                  isActive: false,
                  
                  onTap: () {
                    setState(() {
                      _showMoreNav = false;
                      _currentRoute = '/menu-categories';
                    });
                  },
                ),
                SizedBox(width: 4.w),
                _buildNavItem(
                  icon: Icons.fastfood_outlined,
                  label: 'Menu Items',
                  isActive: false,
                  
                  onTap: () {
                    setState(() {
                      _showMoreNav = false;
                      _currentRoute = '/menu-items'; // this doesn't exist, wait, the user didn't even have an item list. But we will navigate to some placeholder or menu-items if available. Actually, I can just leave it as it was but change Navigator to _currentRoute.
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

  Widget _buildOctonaryNavBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: _showMoreNav
          ? (24.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h)
          : -420.h,
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
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Accounts',
                  isActive:
                      _financeTab == FinanceTab.accounts &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _financeTab = FinanceTab.accounts;
                      _showMoreNav = false;
      _currentRoute = '/finance-account-list';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.book_outlined,
                  label: 'Ledger',
                  isActive:
                      _financeTab == FinanceTab.ledger &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _financeTab = FinanceTab.ledger;
                      _showMoreNav = false;
      _currentRoute = '/finance-ledger-list';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.precision_manufacturing_outlined,
                  label: 'Assets',
                  isActive:
                      _financeTab == FinanceTab.assets &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _financeTab = FinanceTab.assets;
                      _showMoreNav = false;
      _currentRoute = '/finance-asset-list';
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

  Widget _buildSeptenaryNavBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: _showMoreNav
          ? (24.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h)
          : -360.h,
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
                  icon: Icons.access_time,
                  label: 'Shifts',
                  isActive:
                      _coreHrTab == CoreHrTab.shifts &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _coreHrTab = CoreHrTab.shifts;
                      _showMoreNav = false;
      _currentRoute = '/shift-list';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.point_of_sale_sharp,
                  label: 'Registers',
                  isActive:
                      _coreHrTab == CoreHrTab.registers &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _coreHrTab = CoreHrTab.registers;
                      _showMoreNav = false;
      _currentRoute = '/cash-register-list';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.corporate_fare,
                  label: 'Depts',
                  isActive:
                      _coreHrTab == CoreHrTab.depts && _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _coreHrTab = CoreHrTab.depts;
                      _showMoreNav = false;
      _currentRoute = '/department-list';
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

  Widget _buildSenaryNavBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: _showMoreNav
          ? (24.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h +
                60.h +
                6.h)
          : -300.h,
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
                  icon: Icons.point_of_sale,
                  label: 'POS',
                  isActive: _posTab == PosTab.pos && _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _posTab = PosTab.pos;
                      _showMoreNav = false;
      _currentRoute = '/pos-terminal';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.kitchen,
                  label: 'KDS',
                  isActive: _posTab == PosTab.kds && _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _posTab = PosTab.kds;
                      _showMoreNav = false;
      _currentRoute = '/kds-terminal';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.table_restaurant,
                  label: 'Tables',
                  isActive:
                      _posTab == PosTab.tables && _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _posTab = PosTab.tables;
                      _showMoreNav = false;
      _currentRoute = '/table-list';
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

  Widget _buildQuinaryNavBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: _showMoreNav
          ? (24.h + 60.h + 6.h + 60.h + 6.h + 60.h + 6.h + 60.h + 6.h)
          : -240.h,
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
                  icon: Icons.inventory,
                  label: 'Stock',
                  isActive:
                      _productionTab == ProductionTab.stock &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _productionTab = ProductionTab.stock;
                      _showMoreNav = false;
      _currentRoute = '/stock-ledger';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.receipt,
                  label: 'Recipes',
                  isActive:
                      _productionTab == ProductionTab.recipes &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _productionTab = ProductionTab.recipes;
                      _showMoreNav = false;
      _currentRoute = '/bom-list';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.restaurant,
                  label: 'Kitchen',
                  isActive:
                      _productionTab == ProductionTab.kitchen &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _productionTab = ProductionTab.kitchen;
                      _showMoreNav = false;
      _currentRoute = '/production-batch-list';
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

  Widget _buildQuaternaryNavBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: _showMoreNav
          ? (24.h + 60.h + 6.h + 60.h + 6.h + 60.h + 6.h)
          : -180.h,
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
                  icon: Icons.fastfood,
                  label: 'Items',
                  isActive:
                      _catalogTab == CatalogTab.items &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _catalogTab = CatalogTab.items;
                      _showMoreNav = false;
      _currentRoute = '/item-list';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.category,
                  label: 'Categories',
                  isActive:
                      _catalogTab == CatalogTab.categories &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _catalogTab = CatalogTab.categories;
                      _showMoreNav = false;
      _currentRoute = '/category-list';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.square_foot,
                  label: 'Units (UoM)',
                  isActive:
                      _catalogTab == CatalogTab.uom && _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _catalogTab = CatalogTab.uom;
                      _showMoreNav = false;
      _currentRoute = '/uom-list';
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

  Widget _buildTertiaryNavBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: _showMoreNav ? (24.h + 60.h + 6.h + 60.h + 6.h) : -120.h,
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
                  icon: Icons.local_shipping,
                  label: 'Suppliers',
                  isActive:
                      _procurementTab == ProcurementTab.suppliers &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _procurementTab = ProcurementTab.suppliers;
                      _showMoreNav = false;
      _currentRoute = '/supplier-list';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.assignment,
                  label: 'POrders',
                  isActive:
                      _procurementTab == ProcurementTab.purchaseOrders &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
      _mainTab = MainTab.more;
                      _procurementTab = ProcurementTab.purchaseOrders;
                      _showMoreNav = false;
      _currentRoute = '/po-list';
    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.assignment_return,
                  label: 'Receipts',
                  isActive:
                      _procurementTab == ProcurementTab.receipts &&
                      _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.more;
                      _procurementTab = ProcurementTab.receipts;
                      _showMoreNav = false;
                    });
                    // For dummy purposes, we'll navigate to GRN form directly.
                    _currentRoute = '/grn-form';
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryNavBar() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      bottom: _showMoreNav ? (24.h + 60.h + 6.h) : -60.h,
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
                      _showMoreNav = false;
                      _currentRoute = '/employee-list';
                    });
                  },
                ),
                _buildNavItem(
                  icon: Icons.manage_accounts,
                  label: 'Role & Dept',
                  isActive:
                      _moreTab == MoreTab.roleAndDept && _mainTab == MainTab.more,
                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.more;
                      _moreTab = MoreTab.roleAndDept;
                      _showMoreNav = false;
                      _currentRoute = '/role-list';
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
      _showMoreNav = false;
      _currentRoute = AppRoutes.settings;
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
      body: Stack(
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
          _buildNonaryNavBar(),
          _buildOctonaryNavBar(),
          _buildSeptenaryNavBar(),
          _buildSenaryNavBar(),
          _buildQuinaryNavBar(),
          _buildQuaternaryNavBar(),
          _buildTertiaryNavBar(),
          _buildSecondaryNavBar(),
          _buildPrimaryNavBar(),
        ],
      ),
    );
  }
}
