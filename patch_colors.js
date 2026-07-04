const fs = require('fs');

let content = fs.readFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', 'utf8');

content = content.replace(/AppColors\.errorRed/g, 'AppColors.error');

fs.writeFileSync('apps/mobile/lib/features/catalog/pages/item.detail.page.dart', content);
