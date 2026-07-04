const fs = require('fs');

const file = 'c:/F0526/Quest/shop/apps/mobile/lib/features/core_hr/pages/home.layout.page.dart';
let content = fs.readFileSync(file, 'utf8');

// 1. Set default _currentRoute
content = content.replace(
    '  String? _currentRoute;',
    '  String? _currentRoute = \'/pos-terminal\';'
);

// 2. Fix Billing routing
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

// 3. Fix Orders routing
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

fs.writeFileSync(file, content, 'utf8');
console.log('Fixed routing for Default, Billing, and Orders.');
