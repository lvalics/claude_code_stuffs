#!/usr/bin/env node

const { execSync, spawn } = require('child_process');
const path = require('path');
const fs = require('fs');

// Parse command line arguments
const args = process.argv.slice(2);
const flags = args.filter(arg => arg.startsWith('--'));
const projectName = args.find(arg => !arg.startsWith('--'));

const isFrameworkOnly = flags.includes('--framework-only');
const isQuickSetup = flags.includes('--quick');

if (!projectName) {
  console.error('Please specify the project directory:');
  console.log('  npx create-jezweb-ai-app <project-directory>');
  console.log('\nOptions:');
  console.log('  --quick           Quick setup with AI App defaults');
  console.log('  --framework-only  Only add Claude Code framework to existing project');
  console.log('\nExamples:');
  console.log('  npx create-jezweb-ai-app my-app');
  console.log('  npx create-jezweb-ai-app my-app --quick');
  console.log('  npx create-jezweb-ai-app . --framework-only');
  process.exit(1);
}

const projectPath = path.resolve(process.cwd(), projectName);

if (!isFrameworkOnly) {
  if (fs.existsSync(projectPath)) {
    console.error(`Error: Directory "${projectName}" already exists.`);
    process.exit(1);
  }
  console.log(`Creating a new Jezweb AI app in ${projectPath}...`);
  fs.mkdirSync(projectPath);
} else {
  if (!fs.existsSync(projectPath)) {
    console.error(`Error: Directory "${projectName}" does not exist.`);
    console.error('--framework-only flag requires an existing project directory.');
    process.exit(1);
  }
  console.log(`Adding Claude Code framework to existing project in ${projectPath}...`);
}

// The magic happens here. We execute the shell script.
// We need to clone the framework repo to get the script.
const frameworkRepo = 'https://github.com/jezweb/claude-code-framework.git';
const tempFrameworkDir = path.join(projectPath, 'temp_framework_setup');

try {
  console.log('Cloning the setup tool...');
  execSync(`git clone --depth 1 ${frameworkRepo} "${tempFrameworkDir}"`, { 
    stdio: 'inherit'
  });
  
  const initScriptPath = path.join(tempFrameworkDir, 'scripts', 'init-project.sh');
  
  // Make the script executable
  execSync(`chmod +x "${initScriptPath}"`, { stdio: 'inherit' });
  
  // Build script arguments
  const scriptArgs = [initScriptPath];
  if (isFrameworkOnly) scriptArgs.push('--framework-only');
  if (isQuickSetup) scriptArgs.push('--quick');
  
  // Run the init script using spawn for better interactive support
  const initProcess = spawn('bash', scriptArgs, {
    cwd: projectPath,
    stdio: ['inherit', 'inherit', 'inherit'],
    shell: true,
    env: {
      ...process.env,
      FORCE_COLOR: '1',
      NPM_CONFIG_COLOR: 'always',
      FRAMEWORK_ONLY: isFrameworkOnly ? '1' : '0',
      QUICK_SETUP: isQuickSetup ? '1' : '0'
    }
  });
  
  initProcess.on('close', (code) => {
    // Clean up the temporary setup directory
    if (fs.existsSync(tempFrameworkDir)) {
      fs.rmSync(tempFrameworkDir, { recursive: true, force: true });
    }
    
    if (code !== 0) {
      console.error(`\nSetup process exited with code ${code}`);
      process.exit(code);
    }
  });
  
  initProcess.on('error', (error) => {
    console.error('Failed to create the project.');
    console.error(error);
    
    // Clean up the temporary setup directory
    if (fs.existsSync(tempFrameworkDir)) {
      fs.rmSync(tempFrameworkDir, { recursive: true, force: true });
    }
    
    process.exit(1);
  });

} catch (error) {
  console.error('Failed to create the project.');
  console.error(error);
  
  // Clean up the temporary setup directory
  if (fs.existsSync(tempFrameworkDir)) {
    fs.rmSync(tempFrameworkDir, { recursive: true, force: true });
  }
}
