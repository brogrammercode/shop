const fs = require('fs');
const path = require('path');

function walk(dir) {
    let results = [];
    const list = fs.readdirSync(dir);
    list.forEach(file => {
        file = dir + '/' + file;
        const stat = fs.statSync(file);
        if (stat && stat.isDirectory()) {
            results = results.concat(walk(file));
        } else {
            if (file.endsWith('.model.dart')) results.push(file);
        }
    });
    return results;
}

const files = walk('apps/mobile/lib/features');

files.forEach(file => {
    let content = fs.readFileSync(file, 'utf8');
    const regex = /([a-zA-Z0-9_]+):\s*json\['([a-zA-Z0-9_]+)'\]\s*\?\?\s*0\.0,/g;
    
    if (regex.test(content)) {
        content = content.replace(regex, '$1: (json[\'$2\'] as num?)?.toDouble() ?? 0.0,');
        fs.writeFileSync(file, content);
        console.log('Fixed: ' + file);
    }
});

console.log('Done.');
