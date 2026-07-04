const fs = require('fs');
const path = require('path');

const dir = 'c:/F0526/Quest/shop/apps/mobile/lib/features';

function replaceBalanced(text, startKeyword, onRefreshBody) {
    let index = 0;
    while (true) {
        index = text.indexOf(startKeyword, index);
        if (index === -1) break;

        // Ensure we are not already wrapped (basic check)
        const checkIndex = Math.max(0, index - 30);
        if (text.substring(checkIndex, index).includes('RefreshIndicator(')) {
            index += startKeyword.length;
            continue;
        }
        
        let parenCount = 0;
        let i = index + startKeyword.length - 1; // startKeyword should end with '('
        if (text[i] !== '(') {
            index += startKeyword.length;
            continue;
        }
        parenCount = 1;
        i++;
        let foundEnd = false;
        for (; i < text.length; i++) {
            if (text[i] === '(') {
                parenCount++;
            } else if (text[i] === ')') {
                parenCount--;
            }
            if (parenCount === 0) {
                foundEnd = true;
                break;
            }
        }
        
        if (foundEnd) {
            const chunk = text.substring(index, i + 1);
            const replacement = `RefreshIndicator(
      color: AppColors.primaryGreen,
      onRefresh: () async {
        ${onRefreshBody}
      },
      child: ${chunk},
    )`;
            text = text.substring(0, index) + replacement + text.substring(i + 1);
            // Move index past the replacement
            index += replacement.length;
        } else {
            index += startKeyword.length;
        }
    }
    return text;
}

function processFiles() {
    // glob all .list.page.dart
    glob(dir + '/**/*.list.page.dart', (err, files) => {
        if (err) throw err;
        
        for (const file of files) {
            let content = fs.readFileSync(file, 'utf8');
            if (content.includes('RefreshIndicator(')) {
                console.log(`Skipping ${path.basename(file)} (already has RefreshIndicator)`);
                continue;
            }

            const initStateMatch = content.match(/void initState\(\)\s*\{([\s\S]*?)\}/);
            if (!initStateMatch) {
                console.log(`Skipping ${path.basename(file)} (no initState)`);
                continue;
            }
            
            const initStateBody = initStateMatch[1];
            const readCalls = [];
            const readRegex = /context\.read<[^>]+>\(\)\.[a-zA-Z0-9_]+\([^)]*\);/g;
            let match;
            while ((match = readRegex.exec(initStateBody)) !== null) {
                readCalls.push(match[0]);
            }
            
            if (readCalls.length === 0) {
                console.log(`Skipping ${path.basename(file)} (no context.read in initState)`);
                continue;
            }

            const onRefreshBody = readCalls.join('\n        ');
            
            // Now search for ListView.separated, ListView.builder, ListView
            const originalContent = content;
            content = replaceBalanced(content, 'ListView.separated(', onRefreshBody);
            content = replaceBalanced(content, 'ListView.builder(', onRefreshBody);
            content = replaceBalanced(content, 'ListView(', onRefreshBody);
            content = replaceBalanced(content, 'SingleChildScrollView(', onRefreshBody);
            
            if (originalContent !== content) {
                fs.writeFileSync(file, content, 'utf8');
                console.log(`Wrapped lists in ${path.basename(file)}`);
            } else {
                console.log(`Could not find lists to wrap in ${path.basename(file)}`);
            }
        }
    });
}

// We need to install glob or just use simple fs traversal since glob might not be installed.
// The project has package.json in backend, but mobile does not have glob in node_modules.
// Let's implement a simple walk function to avoid dependency issues.

function walkDir(dirPath, callback) {
    fs.readdirSync(dirPath).forEach(f => {
        let dirPathFull = path.join(dirPath, f);
        let isDirectory = fs.statSync(dirPathFull).isDirectory();
        if (isDirectory) {
            walkDir(dirPathFull, callback);
        } else if (dirPathFull.endsWith('.list.page.dart')) {
            callback(dirPathFull);
        }
    });
}

function run() {
    walkDir(dir, (file) => {
        let content = fs.readFileSync(file, 'utf8');
        if (content.includes('RefreshIndicator(')) {
            console.log(`Skipping ${path.basename(file)} (already has RefreshIndicator)`);
            return;
        }

        const initStateMatch = content.match(/void initState\(\)\s*\{([\s\S]*?)\}/);
        if (!initStateMatch) {
            console.log(`Skipping ${path.basename(file)} (no initState)`);
            return;
        }
        
        const initStateBody = initStateMatch[1];
        const readCalls = [];
        const readRegex = /context\.read<[^>]+>\(\)\.[a-zA-Z0-9_]+\([^)]*\);/g;
        let match;
        while ((match = readRegex.exec(initStateBody)) !== null) {
            readCalls.push(match[0]);
        }
        
        if (readCalls.length === 0) {
            console.log(`Skipping ${path.basename(file)} (no context.read in initState)`);
            return;
        }

        const onRefreshBody = readCalls.join('\n        ');
        
        const originalContent = content;
        content = replaceBalanced(content, 'ListView.separated(', onRefreshBody);
        content = replaceBalanced(content, 'ListView.builder(', onRefreshBody);
        content = replaceBalanced(content, 'ListView(', onRefreshBody);
        content = replaceBalanced(content, 'GridView.builder(', onRefreshBody);
        
        if (originalContent !== content) {
            fs.writeFileSync(file, content, 'utf8');
            console.log(`Wrapped lists in ${path.basename(file)}`);
        } else {
            console.log(`Could not find lists to wrap in ${path.basename(file)}`);
        }
    });
}

run();
