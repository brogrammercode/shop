const fs = require('fs');
const file = 'c:/F0526/Quest/shop/apps/mobile/lib/features/core_hr/pages/home.layout.page.dart';
let content = fs.readFileSync(file, 'utf8');

content = content.replace(
    '// For dummy purposes, we\'ll navigate to GRN form directly.\n                    Navigator.pushNamed(context, \'/grn-form\');',
    '// For dummy purposes, we\'ll navigate to GRN form directly.\n                    _currentRoute = \'/grn-form\';'
);

fs.writeFileSync(file, content, 'utf8');
console.log('Fixed final pushNamed.');
