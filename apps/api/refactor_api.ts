import { Project, SyntaxKind, Node } from 'ts-morph';

const project = new Project({
    tsConfigFilePath: 'C:/F0526/Quest/shop/apps/api/tsconfig.json',
});

function toSnakeCase(str: string): string {
    return str.replace(/[A-Z]/g, letter => `_${letter}`).toUpperCase();
}

async function run() {
    const constantFiles = project.getSourceFiles().filter((f: any) => f.getFilePath().includes('.constant.ts'));

    for (const file of constantFiles) {
        console.log(`Processing file: ${file.getFilePath()}`);
        
        // 1. Rename exported variables
        const varDecls = file.getVariableDeclarations();
        for (const varDecl of varDecls) {
            const currentName = varDecl.getName();
            const newName = toSnakeCase(currentName);
            if (currentName !== newName) {
                console.log(`Renaming variable ${currentName} to ${newName}`);
                varDecl.rename(newName);
            }
        }

        // 2. Rename object properties
        let changed = true;
        while (changed) {
            changed = false;
            const allProps = file.getDescendantsOfKind(SyntaxKind.PropertyAssignment);
            for (const prop of allProps) {
                const currentName = prop.getName();
                const newName = toSnakeCase(currentName);
                if (currentName !== newName && /^[a-zA-Z0-9]+$/.test(currentName) && currentName !== 'id') {
                    console.log(`Renaming property ${currentName} to ${newName}`);
                    try {
                        const nameNode = prop.getNameNode();
                        if (Node.isIdentifier(nameNode) || Node.isStringLiteral(nameNode)) {
                            // If it's a string literal property like 'Content-Type', skip it if it's not matching our regex.
                            // Rename using language service
                            if (Node.isIdentifier(nameNode)) {
                                nameNode.rename(newName);
                                changed = true;
                                break; // Break and re-collect descendants since AST changed
                            }
                        }
                    } catch (e) {
                        console.error(`Failed to rename ${currentName}`, e);
                    }
                }
            }
        }
    }

    console.log("Saving changes...");
    await project.save();
    console.log("Done!");
}

run().catch(console.error);
