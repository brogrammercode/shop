const fs = require('fs');

const file = 'c:/F0526/Quest/shop/apps/mobile/lib/features/core_hr/pages/home.layout.page.dart';
let content = fs.readFileSync(file, 'utf8');

// Normalize to \n
content = content.replace(/\r\n/g, '\n');

// 1. Initial State
content = content.replace(
    '  String? _currentRoute;',
    '  String? _currentRoute = \'/pos-terminal\';'
);

// 2. Billing & Orders
content = content.replace(
`                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.billing;
                      _showMoreNav = false;
                    });
                  },`,
`                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.billing;
                      _showMoreNav = false;
                      _currentRoute = '/pos-terminal';
                    });
                  },`
);
content = content.replace(
`                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.orders;
                      _showMoreNav = false;
                    });
                  },`,
`                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.orders;
                      _showMoreNav = false;
                      _currentRoute = '/order-list';
                    });
                  },`
);

// 3. More button default route
content = content.replace(
`                  onTap: () {
                    setState(() {
                      _showMoreNav = !_showMoreNav;
                      if (_showMoreNav) {
                        _mainTab = MainTab.more;
                        _moreTab ??= MoreTab.employees;
                      }
                    });
                  },`,
`                  onTap: () {
                    setState(() {
                      _showMoreNav = !_showMoreNav;
                      if (_showMoreNav) {
                        _mainTab = MainTab.more;
                        if (_moreTab == null) {
                          _moreTab = MoreTab.employees;
                          _currentRoute = '/employee-list';
                        }
                      }
                    });
                  },`
);

// 4. Employees & Products
content = content.replace(
`                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.more;
                      _moreTab = MoreTab.employees;
                      _showMoreNav =
                          false; // Hide after selection, or leave open? Usually stays or closes. Let's close it so the user can interact with the screen.
                    });
                  },`,
`                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.more;
                      _moreTab = MoreTab.employees;
                      _showMoreNav = false;
                      _currentRoute = '/employee-list';
                    });
                  },`
);

content = content.replace(
`                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.more;
                      _moreTab = MoreTab.products;
                      _showMoreNav = false;
                    });
                  },`,
`                  onTap: () {
                    setState(() {
                      _mainTab = MainTab.more;
                      _moreTab = MoreTab.products;
                      _showMoreNav = false;
                      _currentRoute = '/item-list';
                    });
                  },`
);

// 5. Settings
content = content.replace(
`                  onTap: () {
                    setState(() {
                      _showMoreNav = false;
                    });
                    Navigator.pushNamed(context, AppRoutes.settings);
                  },`,
`                  onTap: () {
                    setState(() {
                      _showMoreNav = false;
                      _currentRoute = AppRoutes.settings;
                    });
                  },`
);

fs.writeFileSync(file, content, 'utf8');
console.log('All remaining layout fixes applied with normalized newlines.');
