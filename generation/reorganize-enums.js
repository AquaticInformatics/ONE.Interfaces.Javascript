const fs = require('fs');
const path = require('path');

console.log('=== Enum Reorganization Script ===');

const outputDir = './out/js';
if (!fs.existsSync(outputDir)) {
  console.log('Output directory does not exist. Run the full generation first.');
  process.exit(1);
}

const files = fs.readdirSync(outputDir).filter(f => f.endsWith('.js'));
console.log(`Found ${files.length} JS files to process`);

files.forEach(filename => {
  const filepath = path.join(outputDir, filename);
  const content = fs.readFileSync(filepath, 'utf8');
  
  console.log(`Processing ${filename}...`);
  
  // Check if file has already been processed
  if (content.includes('// === ENUMS SECTION - All enums moved to bottom ===')) {
    console.log(`  - Already processed, skipping ${filename}`);
    return;
  }
  
  const lines = content.split('\n');
  const cleanLines = [];
  const enumBlocks = [];
  let i = 0;

  // First pass: Find all enum definitions and their JSDoc comments
  while (i < lines.length) {
    const line = lines[i];
    
    // Check if this is an enum definition
    if (line.match(/^\$root\.Enum.*= \(function\(\)/)) {
      const enumNameMatch = line.match(/^\$root\.(Enum\w+)/);
      const enumName = enumNameMatch ? enumNameMatch[1] : null;
      
      console.log(`  Found enum: ${enumName}`);
      
      // Find the end of the enum definition
      let enumLines = [line];
      let braceCount = 1;
      let j = i + 1;
      
      while (j < lines.length && braceCount > 0) {
        const nextLine = lines[j];
        enumLines.push(nextLine);
        
        // Count braces
        const openBraces = (nextLine.match(/\(/g) || []).length;
        const closeBraces = (nextLine.match(/\)/g) || []).length;
        braceCount += openBraces - closeBraces;
        
        if (braceCount === 0 && nextLine.match(/^\}\)\(\);/)) {
          break;
        }
        j++;
      }
      
      // Look for JSDoc comment for this enum (search backwards from current position first, then forwards)
      let enumComment = null;
      
      // Search backwards first (more likely to be nearby)
      for (let k = i - 1; k >= 0; k--) {
        if (lines[k] && lines[k].includes(`@exports ${enumName}`)) {
          // Found the JSDoc comment, find its boundaries
          let commentStart = k;
          while (commentStart > 0 && lines[commentStart] && !lines[commentStart].match(/^\s*\/\*\*/)) {
            commentStart--;
          }
          
          let commentEnd = k;
          while (commentEnd < lines.length && lines[commentEnd] && !lines[commentEnd].match(/^\s*\*\//)) {
            commentEnd++;
          }
          
          if (commentStart >= 0 && commentEnd < lines.length && lines[commentStart] && lines[commentEnd]) {
            enumComment = lines.slice(commentStart, commentEnd + 1).join('\n');
            console.log(`    Found JSDoc comment for ${enumName} (backward search)`);
          }
          break;
        }
      }
      
      // If not found backwards, search forwards
      if (!enumComment) {
        for (let k = j + 1; k < lines.length; k++) {
          if (lines[k] && lines[k].includes(`@exports ${enumName}`)) {
            // Found the JSDoc comment, find its boundaries
            let commentStart = k;
            while (commentStart > 0 && lines[commentStart] && !lines[commentStart].match(/^\s*\/\*\*/)) {
              commentStart--;
            }
            
            let commentEnd = k;
            while (commentEnd < lines.length && lines[commentEnd] && !lines[commentEnd].match(/^\s*\*\//)) {
              commentEnd++;
            }
            
            if (commentStart >= 0 && commentEnd < lines.length && lines[commentStart] && lines[commentEnd]) {
              enumComment = lines.slice(commentStart, commentEnd + 1).join('\n');
              console.log(`    Found JSDoc comment for ${enumName} (forward search)`);
            }
            break;
          }
        }
      }
      
      // Create the complete enum block
      let enumBlock = '';
      if (enumComment) {
        enumBlock = enumComment + '\n' + enumLines.join('\n');
      } else {
        enumBlock = enumLines.join('\n');
        console.log(`    No JSDoc comment found for ${enumName}`);
      }
      
      enumBlocks.push(enumBlock);
      
      // Skip past this enum definition
      i = j + 1;
      continue;
    }
    
    // Check if this line is part of an enum JSDoc comment (to be removed)
    if (line.match(/^\s*\/\*\*/) || line.match(/^\s*\*\s*@exports\s+Enum/)) {
      // This might be an enum JSDoc comment, check if it's for an enum
      let isEnumComment = false;
      let commentEnd = i;
      
      // Find the end of this comment block
      while (commentEnd < lines.length && !lines[commentEnd].match(/^\s*\*\//)) {
        if (lines[commentEnd].match(/^\s*\*\s*@exports\s+Enum/)) {
          isEnumComment = true;
        }
        commentEnd++;
      }
      
      if (isEnumComment) {
        console.log(`    Removing orphaned enum JSDoc comment at line ${i + 1}`);
        // Skip this entire comment block
        i = commentEnd + 1;
        continue;
      }
    }
    
    // This is a regular line, keep it
    cleanLines.push(line);
    i++;
  }
  
  console.log(`  Found ${enumBlocks.length} enum blocks`);
  
  // Reconstruct file with enums at bottom
  if (enumBlocks.length > 0) {
    // Remove the last module.exports line if it exists
    while (cleanLines.length > 0 && (cleanLines[cleanLines.length - 1].trim() === '' || cleanLines[cleanLines.length - 1].includes('module.exports'))) {
      cleanLines.pop();
    }
    
    const newContent = [
      ...cleanLines,
      '',
      '// === ENUMS SECTION - All enums moved to bottom ===',
      '',
      ...enumBlocks,
      '',
      'module.exports = $root;'
    ].join('\n');
    
    fs.writeFileSync(filepath, newContent);
    console.log(`  ✓ Moved ${enumBlocks.length} enum(s) to bottom in ${filename}`);
  } else {
    console.log(`  - No enums found in ${filename}`);
  }
});

console.log('=== Enum reorganization complete ===');
