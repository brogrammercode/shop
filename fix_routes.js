const fs = require('fs');
const path = require('path');

const features = ['catalog', 'crm', 'finance', 'inventory', 'manufacturing', 'pos_kds'];

features.forEach(f => {
  const file = path.join('c:/F0526/Quest/shop/apps/api/src/features', f, f + '.route.ts');
  if (!fs.existsSync(file)) return;
  
  let content = fs.readFileSync(file, 'utf8');
  
  // 1. Uncomment router.use
  content = content.replace(/\/\/\s*router\.use\(authenticate/g, 'router.use(authenticate');
  
  // 2. Fix imports
  const pascalF = f.split('_').map(w => w.charAt(0).toUpperCase() + w.slice(1)).join('');
  const requireName = 'require' + pascalF + 'Access';
  
  // Uncomment import if it was commented out
  const importRegex = new RegExp('\\/\\/\\s*import\\s*\\{\\s*authenticate\\s*,\\s*' + requireName + '\\s*\\}\\s*from\\s*["\']\\.\\/' + f + '\\.middleware["\'];?');
  
  if (importRegex.test(content)) {
      content = content.replace(importRegex, 'import { authenticate, ' + requireName + ' } from \'./' + f + '.middleware\';');
  } else {
      // If it's completely missing, add it
      if (!content.includes('import { authenticate') && !content.includes(requireName + ' } from')) {
          const importStr = 'import { authenticate, ' + requireName + ' } from \'./' + f + '.middleware\';\n';
          content = content.replace('import { Router } from "express";\n', 'import { Router } from "express";\n' + importStr);
      }
  }

  fs.writeFileSync(file, content);
  console.log('Fixed ' + f);
});
