const fs = require('fs');

const file = 'c:/F0526/Quest/shop/apps/mobile/lib/features/core_hr/pages/home.layout.page.dart';
let content = fs.readFileSync(file, 'utf8');

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

fs.writeFileSync(file, content, 'utf8');
console.log('Fixed routing for Employees and Products in layout.');
