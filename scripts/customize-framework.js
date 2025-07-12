#!/usr/bin/env node

const readline = require('readline');
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

// ANSI color codes
const colors = {
  RED: '\x1b[0;31m',
  GREEN: '\x1b[0;32m',
  YELLOW: '\x1b[1;33m',
  BLUE: '\x1b[0;34m',
  NC: '\x1b[0m' // No Color
};

// Configuration
const CLAUDE_DIR = '.claude';
const BEST_PRACTICES_DIR = path.join(CLAUDE_DIR, 'best_practices');
const CONFIG_DIR = path.join(CLAUDE_DIR, 'config');
const CUSTOMIZATION_LOG = path.join(CLAUDE_DIR, 'customization-log.md');
const TIMESTAMP = new Date().toISOString().replace('T', ' ').substring(0, 19);

// Parse command line arguments
const args = process.argv.slice(2);
const isQuickSetup = args.includes('--quick');

// Create readline interface
const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Helper function to ask questions
const question = (prompt) => new Promise((resolve) => {
  rl.question(prompt, resolve);
});

// Helper function for yes/no questions
const promptYesNo = async (prompt) => {
  while (true) {
    const answer = await question(`${prompt} (y/n): `);
    if (answer.toLowerCase() === 'y' || answer.toLowerCase() === 'yes') return true;
    if (answer.toLowerCase() === 'n' || answer.toLowerCase() === 'no') return false;
    console.log('Please answer yes (y) or no (n).');
  }
};

// Helper function for multiple choice questions
const promptChoice = async (prompt, options) => {
  console.log(prompt);
  options.forEach((option, index) => {
    console.log(`  ${index + 1}. ${option}`);
  });
  
  while (true) {
    const choice = await question(`Enter your choice (1-${options.length}): `);
    const choiceNum = parseInt(choice);
    if (choiceNum >= 1 && choiceNum <= options.length) {
      return options[choiceNum - 1];
    }
    console.log(`Invalid choice. Please enter a number between 1 and ${options.length}.`);
  }
};

// Quick setup defaults
const quickSetupDefaults = {
  teamSize: 'Solo developer',
  projectType: 'Full-stack application',
  industry: 'General/Other',
  technologies: ['Node.js', 'Python', 'Vue', 'Docker'],
  indentStyle: '2 spaces',
  maxLineLength: '80',
  namingConvention: 'camelCase',
  testFramework: 'Traditional (tests after code)',
  codeCoverage: '80',
  branching: 'feature/TASK-ID',
  prReviews: 'No reviews needed'
};

// Main function
async function main() {
  // Check if we're in the right directory
  if (!fs.existsSync(CLAUDE_DIR)) {
    console.error(`${colors.RED}Error: Not in a Claude Code project directory${colors.NC}`);
    console.log('Please run this script from the root of your project');
    process.exit(1);
  }

  // Create config directory if it doesn't exist
  if (!fs.existsSync(CONFIG_DIR)) {
    fs.mkdirSync(CONFIG_DIR, { recursive: true });
  }

  console.log(`${colors.BLUE}╔════════════════════════════════════════════════════════╗${colors.NC}`);
  console.log(`${colors.BLUE}║        Claude Code Framework Customization Tool        ║${colors.NC}`);
  console.log(`${colors.BLUE}╚════════════════════════════════════════════════════════╝${colors.NC}`);
  console.log();

  if (isQuickSetup) {
    console.log(`${colors.GREEN}🚀 Quick Setup Mode - Using AI App defaults${colors.NC}`);
    console.log();
  }

  // Gather team information
  let teamName = '';
  let teamSize, projectType, industry;

  if (isQuickSetup) {
    console.log(`${colors.YELLOW}Let's get started!${colors.NC}`);
    console.log();
    
    while (!teamName) {
      teamName = await question('Enter your team/project name: ');
      if (!teamName) {
        console.log(`${colors.RED}Team name cannot be empty${colors.NC}`);
      }
    }
    
    // Use defaults for quick setup
    teamSize = quickSetupDefaults.teamSize;
    projectType = quickSetupDefaults.projectType;
    industry = quickSetupDefaults.industry;
    
    console.log(`\n${colors.GREEN}Using quick setup defaults:${colors.NC}`);
    console.log(`• Team size: ${teamSize}`);
    console.log(`• Project type: ${projectType}`);
    console.log(`• Industry: ${industry}`);
    console.log(`• Technologies: ${quickSetupDefaults.technologies.join(', ')}`);
    console.log();
  } else {
    console.log(`${colors.YELLOW}Let's start by gathering some information about your team:${colors.NC}`);
    console.log(`${colors.BLUE}This information helps tailor best practices and recommendations to your needs.${colors.NC}`);
    console.log();
    
    while (!teamName) {
      teamName = await question('Enter your team/project name: ');
      if (!teamName) {
        console.log(`${colors.RED}Team name cannot be empty${colors.NC}`);
      }
    }

    console.log(`\n${colors.BLUE}Team size affects:${colors.NC} Code review requirements, branching strategies, and collaboration tools`);
    teamSize = await promptChoice('What is your team size?', [
      'Solo developer',
      'Small team (2-5)',
      'Medium team (6-15)',
      'Large team (16+)'
    ]);

    console.log(`\n${colors.BLUE}Project type determines:${colors.NC} Architecture patterns, testing strategies, and deployment practices`);
    projectType = await promptChoice('What type of project are you working on?', [
      'Web application',
      'API/Microservices',
      'Mobile app',
      'Desktop application',
      'Library/Package',
      'Full-stack application'
    ]);

    console.log(`\n${colors.BLUE}Industry affects:${colors.NC} Security requirements, compliance needs, and best practice recommendations`);
    industry = await promptChoice('What industry/domain?', [
      'General/Other',
      'Finance/FinTech',
      'Healthcare',
      'E-commerce',
      'Education',
      'Gaming',
      'Enterprise'
    ]);
  }

  // Create team configuration
  console.log(`\n${colors.YELLOW}Creating team configuration...${colors.NC}`);

  const teamConfig = `# Team Configuration
# Generated by customization script on ${TIMESTAMP}

team:
  name: "${teamName}"
  size: "${teamSize}"
  
project:
  type: "${projectType}"
  industry: "${industry}"
  
customizations:
  created: "${TIMESTAMP}"
  script_version: "1.0"
`;

  fs.writeFileSync(path.join(CONFIG_DIR, 'team-config.yaml'), teamConfig);
  console.log(`${colors.GREEN}✓ Team configuration created${colors.NC}`);

  // Technology stack customization
  let technologies = [];
  
  if (isQuickSetup) {
    technologies = quickSetupDefaults.technologies;
  } else {
    console.log(`\n${colors.YELLOW}Which technologies does your team primarily use?${colors.NC}`);
    console.log(`${colors.BLUE}Select the technologies that will be used in this project.${colors.NC}`);
    console.log(`${colors.BLUE}This helps configure appropriate linters, formatters, and best practices.${colors.NC}`);
    console.log();
    
    const techDescriptions = {
      'Node.js': 'JavaScript runtime for backend development',
      'Python': 'For FastAPI backend, data processing, or AI/ML',
      'PHP': 'Server-side web development',
      'Java': 'Enterprise applications and Spring Boot',
      'Angular': 'TypeScript-based frontend framework',
      'React': 'JavaScript library for building UIs',
      'Vue': 'Progressive JavaScript framework (included in AI boilerplate)',
      'Docker': 'Container platform for deployment (recommended)',
      'Kubernetes': 'Container orchestration for scaling'
    };
    
    const techOptions = Object.keys(techDescriptions);

    for (const tech of techOptions) {
      console.log(`\n${colors.BLUE}${tech}:${colors.NC} ${techDescriptions[tech]}`);
      if (await promptYesNo(`Do you use ${tech}?`)) {
        technologies.push(tech);
      }
    }
  }

  // Append technologies to team config
  let techSection = '\ntechnologies:\n';
  technologies.forEach(tech => {
    techSection += `  - ${tech}\n`;
  });
  fs.appendFileSync(path.join(CONFIG_DIR, 'team-config.yaml'), techSection);

  // Coding standards customization
  let indentStyle, maxLineLength, namingConvention;
  
  if (isQuickSetup) {
    indentStyle = quickSetupDefaults.indentStyle;
    maxLineLength = quickSetupDefaults.maxLineLength;
    namingConvention = quickSetupDefaults.namingConvention;
  } else {
    console.log(`\n${colors.YELLOW}Let's customize your coding standards:${colors.NC}`);

    indentStyle = await promptChoice('Preferred indentation style?', [
      '2 spaces',
      '4 spaces',
      'Tabs'
    ]);

    const maxLineLengthInput = await question('Maximum line length (default 80, enter for default): ');
    maxLineLength = maxLineLengthInput || '80';

    namingConvention = await promptChoice('Variable naming convention?', [
      'camelCase',
      'snake_case',
      'PascalCase',
      'kebab-case'
    ]);
  }

  // Testing preferences
  let testFramework, codeCoverage;
  
  if (isQuickSetup) {
    testFramework = quickSetupDefaults.testFramework;
    codeCoverage = quickSetupDefaults.codeCoverage;
  } else {
    console.log(`\n${colors.YELLOW}Testing preferences:${colors.NC}`);

    testFramework = await promptChoice('Preferred testing approach?', [
      'TDD (Test-Driven Development)',
      'BDD (Behavior-Driven Development)',
      'Traditional (tests after code)',
      'Minimal testing'
    ]);

    const codeCoverageInput = await question('Minimum code coverage requirement (%, enter for 80): ');
    codeCoverage = codeCoverageInput || '80';
  }

  // Append coding standards to team config
  const codingStandardsSection = `
testing:
  approach: "${testFramework}"
  minimum_coverage: ${codeCoverage}
  
code_style:
  indentation: "${indentStyle}"
  max_line_length: ${maxLineLength}
  naming_convention: "${namingConvention}"
`;
  fs.appendFileSync(path.join(CONFIG_DIR, 'team-config.yaml'), codingStandardsSection);

  // Workflow customizations
  let branching, prReviews;
  
  if (isQuickSetup) {
    branching = quickSetupDefaults.branching;
    prReviews = quickSetupDefaults.prReviews;
  } else {
    console.log(`\n${colors.YELLOW}Workflow preferences:${colors.NC}`);

    if (await promptYesNo('Do you use Git Flow branching?')) {
      branching = 'gitflow';
    } else {
      branching = await promptChoice('Branch naming convention?', [
        'feature/TASK-ID',
        'TASK-ID',
        'feature/description',
        'custom'
      ]);
    }

    prReviews = await promptChoice('Pull request review requirements?', [
      'No reviews needed',
      '1 reviewer',
      '2 reviewers',
      'Team lead approval'
    ]);
  }

  // Create workflow configuration
  const workflowConfig = `# Workflow Configuration
# Generated by customization script on ${TIMESTAMP}

branching:
  strategy: "${branching}"
  
pull_requests:
  reviews_required: "${prReviews}"
  
deployment:
  environments: ["development", "staging", "production"]
`;
  fs.writeFileSync(path.join(CONFIG_DIR, 'workflow-config.yaml'), workflowConfig);

  // Summary report
  console.log(`\n${colors.BLUE}╔════════════════════════════════════════════════════════╗${colors.NC}`);
  console.log(`${colors.BLUE}║                 Customization Summary                  ║${colors.NC}`);
  console.log(`${colors.BLUE}╚════════════════════════════════════════════════════════╝${colors.NC}`);
  console.log();
  console.log(`${colors.GREEN}✓ Team configuration created${colors.NC}`);
  console.log(`${colors.GREEN}✓ Technology stack configured${colors.NC}`);
  console.log(`${colors.GREEN}✓ Coding standards customized${colors.NC}`);
  console.log(`${colors.GREEN}✓ Testing preferences set${colors.NC}`);
  console.log(`${colors.GREEN}✓ Workflow configuration created${colors.NC}`);
  console.log();
  console.log(`Configuration files created in: ${colors.BLUE}${CONFIG_DIR}/${colors.NC}`);
  console.log();
  console.log(`${colors.YELLOW}Next steps:${colors.NC}`);
  console.log('1. Review the customizations in the configuration files');
  console.log('2. Commit these changes to your repository');
  console.log('3. Share with your team for feedback');
  console.log();
  console.log(`${colors.GREEN}Customization complete!${colors.NC}`);

  // Create a summary file
  const summaryContent = `# Customization Summary for ${teamName}

Generated on: ${TIMESTAMP}

## Team Profile
- **Team Size**: ${teamSize}
- **Project Type**: ${projectType}
- **Industry**: ${industry}

## Technologies
${technologies.map(tech => `- ${tech}`).join('\n')}

## Coding Standards
- **Indentation**: ${indentStyle}
- **Max Line Length**: ${maxLineLength}
- **Naming Convention**: ${namingConvention}

## Testing
- **Approach**: ${testFramework}
- **Minimum Coverage**: ${codeCoverage}%

## Workflow
- **Branching Strategy**: ${branching}
- **PR Reviews**: ${prReviews}

## Next Steps
1. Review all customizations
2. Test with your team
3. Iterate as needed
`;
  fs.writeFileSync(path.join(CONFIG_DIR, 'customization-summary.md'), summaryContent);

  console.log();
  console.log(`${colors.BLUE}╔══════════════════════════════════════════════════════════╗${colors.NC}`);
  console.log(`${colors.BLUE}║                    Setup Development Environment         ║${colors.NC}`);
  console.log(`${colors.BLUE}╚══════════════════════════════════════════════════════════╝${colors.NC}`);
  console.log();
  
  let runSetup;
  if (isQuickSetup) {
    // In quick setup, default to yes
    console.log(`${colors.GREEN}✓ Running development environment setup automatically...${colors.NC}`);
    runSetup = true;
  } else {
    console.log(`${colors.YELLOW}Would you like to run the development environment setup now?${colors.NC}`);
    console.log();
    console.log(`${colors.GREEN}Why run setup-dev-env.sh?${colors.NC}`);
    console.log('• Automatically installs only the technologies you selected');
    console.log('• Configures development tools (linters, formatters, etc.)');
    console.log('• Sets up project structure and Git hooks');
    console.log('• Creates VS Code settings optimized for your tech stack');
    console.log('• Generates README.md with your specific technologies');
    console.log('• Saves time by avoiding manual installation of each tool');
    console.log();

    runSetup = await promptYesNo('Run setup-dev-env.sh now?');
  }

  if (runSetup) {
    console.log();
    console.log(`${colors.GREEN}Running development environment setup...${colors.NC}`);
    console.log();
    const setupScript = path.join('./scripts', 'setup-dev-env.sh');
    if (fs.existsSync(setupScript)) {
      try {
        execSync(`chmod +x "${setupScript}" && "${setupScript}"`, { stdio: 'inherit' });
      } catch (error) {
        console.error(`${colors.RED}Error running setup script:${colors.NC}`, error.message);
      }
    } else {
      console.error(`${colors.RED}Error: setup-dev-env.sh not found in ./scripts/${colors.NC}`);
      console.log('Please run it manually when available.');
    }
  } else {
    console.log();
    console.log(`${colors.YELLOW}You can run the setup later with:${colors.NC}`);
    console.log('./scripts/setup-dev-env.sh');
    console.log();
    console.log(`${colors.GREEN}This will install and configure only the technologies you selected.${colors.NC}`);
  }

  console.log(`\nSummary saved to: ${colors.BLUE}${CONFIG_DIR}/customization-summary.md${colors.NC}`);

  rl.close();
}

// Run the main function
main().catch(error => {
  console.error(`${colors.RED}Error:${colors.NC}`, error);
  rl.close();
  process.exit(1);
});