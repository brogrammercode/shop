const fs = require('fs');
const path = require('path');

const targetDir = 'c:/F0526/Quest/shop/apps/mobile/lib';
const loaderImport = "import 'package:mobile/components/ui/loader.dart';\n";

function walkDir(dir) {
    let results = [];
    const list = fs.readdirSync(dir);
    list.forEach(file => {
        file = path.join(dir, file);
        const stat = fs.statSync(file);
        if (stat && stat.isDirectory()) {
            results = results.concat(walkDir(file));
        } else if (file.endsWith('.dart')) {
            results.push(file);
        }
    });
    return results;
}

const dartFiles = walkDir(targetDir);

function replaceLoaders(content) {
    let result = '';
    let i = 0;
    let changed = false;
    
    while (i < content.length) {
        let matchIndex = content.indexOf('CircularProgressIndicator', i);
        if (matchIndex === -1) {
            result += content.substring(i);
            break;
        }
        
        result += content.substring(i, matchIndex);
        
        let openParenIndex = content.indexOf('(', matchIndex);
        if (openParenIndex !== -1 && !content.substring(matchIndex + 25, openParenIndex).trim()) {
            let parenCount = 1;
            let j = openParenIndex + 1;
            while (j < content.length && parenCount > 0) {
                if (content[j] === '(') parenCount++;
                if (content[j] === ')') parenCount--;
                j++;
            }
            
            result += 'AppLoader(size: 24, strokeWidth: 2)';
            i = j;
            changed = true;
        } else {
            result += 'CircularProgressIndicator';
            i = matchIndex + 25;
        }
    }
    
    return { result, changed };
}

dartFiles.forEach(file => {
    let content = fs.readFileSync(file, 'utf8');
    if (file.includes('loader.dart')) return;
    if (file.includes('employee.list.page.dart')) return; // handled manually
    if (!content.includes('CircularProgressIndicator')) return;
    
    const { result, changed } = replaceLoaders(content);
    content = result;

    if (changed) {
        if (!content.includes('package:mobile/components/ui/loader.dart')) {
            const importMatches = [...content.matchAll(/^import\s+.*;/gm)];
            if (importMatches.length > 0) {
                const lastImport = importMatches[importMatches.length - 1];
                const insertIndex = lastImport.index + lastImport[0].length + 1;
                content = content.slice(0, insertIndex) + loaderImport + content.slice(insertIndex);
            } else {
                content = loaderImport + content;
            }
        }
        
        fs.writeFileSync(file, content, 'utf8');
        console.log(`Updated ${file}`);
    }
});
