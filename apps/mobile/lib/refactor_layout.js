const fs = require('fs');

const file = 'c:/F0526/Quest/shop/apps/mobile/lib/features/core_hr/pages/home.layout.page.dart';
let content = fs.readFileSync(file, 'utf8');

// We want to turn:
// onTap: () {
//   setState(() {
//     ...
//   });
//   Navigator.pushNamed(context, '/some-route');
// }
// INTO
// onTap: () {
//   setState(() {
//     ...
//     _currentRoute = '/some-route';
//   });
// }

// Use regex to match the pattern:
// setState\(\(\)\s*\{([^}]*)\}\);\s*Navigator\.pushNamed\(context,\s*('[^']+'|AppRoutes\.settings)\);
const regex = /setState\(\(\)\s*\{([^}]*)\}\);\s*Navigator\.pushNamed\(context,\s*('[^']+'|AppRoutes\.settings)\);/g;

content = content.replace(regex, (match, innerState, route) => {
    return `setState(() {\n      ${innerState.trim()}\n      _currentRoute = ${route};\n    });`;
});

// For EmployeesPage and ProductsPage in the main 'More' nav, wait, do they use Navigator.pushNamed?
// Let's check if there are any remaining Navigator.pushNamed
console.log('Remaining Navigator.pushNamed:', (content.match(/Navigator\.pushNamed/g) || []).length);

// Now we also need to add `String? _currentRoute;` to the state class.
// We'll replace `bool _showMoreNav = false;` with `bool _showMoreNav = false;\n  String? _currentRoute;`
content = content.replace('bool _showMoreNav = false;', 'bool _showMoreNav = false;\n  String? _currentRoute;');

// Finally, we need to modify `_buildBody()`.
const buildBodyReplacement = `  Widget _buildBody() {
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
      } else if (_moreTab == MoreTab.products) {
        return const ProductsPage();
      }
    }

    return const Center(child: Text('Select an option'));
  }`;

// Find existing _buildBody() and replace it entirely
const buildBodyStart = content.indexOf('  Widget _buildBody() {');
const buildBodyEnd = content.indexOf('  Widget _buildNavItem({', buildBodyStart);

if (buildBodyStart !== -1 && buildBodyEnd !== -1) {
    content = content.substring(0, buildBodyStart) + buildBodyReplacement + '\n\n' + content.substring(buildBodyEnd);
}

fs.writeFileSync(file, content, 'utf8');
console.log('Done modifying layout.');
