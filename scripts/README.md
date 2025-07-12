# Scripts

## Quick Start

### 1. Customize Framework
Configure your team's technology stack and preferences:
```bash
# Node.js version (preferred when using npx)
node ./scripts/customize-framework.js

# Or bash version (for direct execution)
./scripts/customize-framework.sh
```

### 2. Setup Development Environment
Install and configure tools for your selected technologies:
```bash
./scripts/setup-dev-env.sh
```

## Script Descriptions

- **customize-framework.sh** - Interactive setup for team configuration, technology selection, and coding standards (bash version)
- **customize-framework.js** - Node.js version of the customization script using @inquirer/prompts for better npx compatibility
- **setup-dev-env.sh** - Installs development tools and dependencies based on detected technologies
- **add-mcp.sh** - Adds MCP (Model Context Protocol) tools to your project
- **validate-best-practices.sh** - Validates your project against configured best practices
- **run_claude.sh** - Automated JIRA task processing with intelligent retry and session management

## Recommended Order
1. Run `customize-framework.sh` first to configure your team setup
2. Run `setup-dev-env.sh` to install the necessary development tools
3. Use other scripts as needed for your specific workflow

## run_claude.sh - Automated JIRA Task Processing

### Overview
This script automates the processing of JIRA tasks through Claude CLI, with intelligent retry logic, stuck detection, and session management. It's designed to handle model limits gracefully and create handover documents for seamless task continuation.

### Prerequisites
- Claude CLI installed and configured
- Bash shell (not sh)
- JIRA tasks properly structured in the `tasks/` directory

### Task Directory Structure
```
tasks/
├── TASK-123/
│   ├── TASK-123-specs.md      # Required: Task specifications
│   ├── TASK-123-IMPLEMENTATION.md  # Created by Claude
│   ├── .completed              # Flag file when task is done
│   ├── .blocked                # Flag file when task is blocked
│   └── .progress               # Progress tracking file
└── TASK-456/
    └── TASK-456-specs.md
```

### Usage
```bash
# Make the script executable (first time only)
chmod +x scripts/run_claude.sh

# Run the script
./scripts/run_claude.sh
# or
bash scripts/run_claude.sh
```

### Features

#### 1. Intelligent Retry Logic
- Maximum 3 attempts per task before marking as blocked
- Different approach on each retry:
  - Attempt 1: Standard implementation workflow
  - Attempt 2: Break down into smaller steps
  - Attempt 3: Minimal implementation focusing on core requirements

#### 2. Stuck Detection
- Detects when Claude is stuck in loops using MD5 hashing
- Identifies common stuck patterns (planning without action)
- Waits 30 seconds before retry when stuck

#### 3. Model Limit Handling
- Detects rate limits and stops gracefully
- Creates handover documents for session continuation
- No automatic switching to Sonnet - preserves context

#### 4. Session Management
- Creates handover documents in `.claude/session/`
- Tracks progress and attempts per task
- Provides clear next steps for continuation

#### 5. Comprehensive Logging
- Task-specific logs in `logs/` directory
- Color-coded output for easy status tracking
- Detailed summary at completion

### Configuration
Edit these variables in the script:
```bash
MAX_ITERATIONS=20         # Max total iterations (default: 20)
MAX_RETRIES_PER_TASK=3   # Max attempts per task (default: 3)
DELAY_BETWEEN_RUNS=5     # Seconds between runs (default: 5)
DELAY_AFTER_STUCK=30     # Seconds to wait when stuck (default: 30)
```

### Output Directories
- `logs/` - Individual task attempt logs
- `claude_code_changes/` - Change documentation
- `.claude/session/` - Handover documents

### Handover Documents
When the script stops due to limits or stuck tasks, it creates detailed handover documents:
```markdown
# Handover Document for Task TASK-123
## Session Summary
- Date, iterations, reason for stopping
- Current status and progress
## Recommendations for Next Session
- Specific guidance based on stop reason
## Next Steps
- Command to continue from handover
```

### Status Indicators
- 🟢 **Completed** - Task successfully finished
- 🟡 **Pending** - Task in progress or waiting
- 🔴 **Blocked** - Task failed after max retries
- ⚠️ **Stuck** - Task not making progress

### Troubleshooting

#### "declare: not found" error
Use `bash` instead of `sh`:
```bash
bash scripts/run_claude.sh
```

#### No tasks found
Ensure tasks exist in the correct structure:
```bash
mkdir -p tasks/TASK-123
echo "# Task specs" > tasks/TASK-123/TASK-123-specs.md
```

#### Tasks getting stuck
- Check the `.blocked` file for specific issues
- Review logs in `logs/` directory
- Consider breaking complex tasks into subtasks

### Best Practices
1. Keep tasks focused and well-defined
2. Run in batches of 5-10 tasks to avoid limits
3. Review handover documents before continuing sessions
4. Monitor `.blocked` files for recurring issues
5. Use health checks to track session state