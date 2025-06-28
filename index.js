#!/usr/bin/env node

const { execSync } = require('child_process');
const path = require('path');
const fs = require('fs');

const projectName = process.argv[2];

if (!projectName) {
  console.error('Please specify the project directory:');
  console.log('  npx create-jezweb-ai-app <project-directory>');
  process.exit(1);
}

const projectPath = path.resolve(process.cwd(), projectName);

if (fs.existsSync(projectPath)) {
  console.error(`Error: Directory "${projectName}" already exists.`);
  process.exit(1);
}

console.log(`Creating a new Jezweb AI app in ${projectPath}...`);
fs.mkdirSync(projectPath);

// The magic happens here. We execute the shell script.
// We need to clone the framework repo to get the script.
const frameworkRepo = 'https://github.com/jezweb/claude-code-framework.git';
const tempFrameworkDir = path.join(projectPath, 'temp_framework_setup');

try {
  console.log('Cloning the setup tool...');
  execSync(`git clone --depth 1 ${frameworkRepo} "${tempFrameworkDir}"`, { stdio: 'inherit' });
  
  const initScriptPath = path.join(tempFrameworkDir, 'scripts', 'init-project.sh');
  
  // Make the script executable and run it within the new project directory
  execSync(`chmod +x "${initScriptPath}" && cd "${projectPath}" && "${initScriptPath}"`, { stdio: 'inherit' });

} catch (error) {
  console.error('Failed to create the project.');
  console.error(error);
} finally {
  // Clean up the temporary setup directory
  if (fs.existsSync(tempFrameworkDir)) {
    fs.rmSync(tempFrameworkDir, { recursive: true, force: true });
  }
}
