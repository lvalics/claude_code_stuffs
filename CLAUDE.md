# Claude Code Development Guidelines

## Session Management System

### Health Check Protocol
When starting ANY conversation, immediately perform a health check to establish session state:
1. Check for existing session state in `.claude/session/current-session.yaml`
2. Initialize or update session health tracking
3. Set appropriate mode based on task type
4. Track scope of work (MICRO/SMALL/MEDIUM/LARGE/EPIC)

### Session Health Indicators
- 🟢 **Healthy** (0-30 messages): Normal operation
- 🟡 **Approaching** (31-45 messages): Plan for handover
- 🔴 **Handover Now** (46+ messages): Immediate handover required

### Command Triggers
- `<Health-Check>` - Display current session health and metrics
- `<Handover01>` - Generate handover document for session continuity
- `<Session-Metrics>` - View detailed session statistics
- `MODE: [DEBUG|BUILD|REVIEW|LEARN|RAPID]` - Switch response mode
- `SCOPE: [MICRO|SMALL|MEDIUM|LARGE|EPIC]` - Set work complexity

### Automatic Behaviors
1. **On Session Start**: Run health check, load previous state if exists
2. **Every 10 Messages**: Background health check with warnings
3. **On Mode Switch**: Update session state and load mode-specific guidelines
4. **On Health Warning**: Suggest natural breakpoints for handover

### Session State Management
Session state is stored in `.claude/session/current-session.yaml` and includes:
- Health status and message count
- Current mode and scope
- Active task (JIRA ID, phase, progress)
- Context (current file, branch, etc.)

When health reaches 🟡, proactively:
1. Complete current logical unit of work
2. Update todo list with completed items
3. Prepare handover documentation
4. Save all session state for seamless resume

## Team Configuration

When starting a session, check for team-specific configuration files in `.claude/config/`:
- **team-config.yaml** - Contains team size, project type, technology stack, and coding standards
- **workflow-config.yaml** - Defines branching strategy, PR requirements, and deployment settings
- **customization-summary.md** - Summary of all team customizations

If these files don't exist, inform the user:
```
No team configuration found. To customize Claude Code for your team:
Run: ./scripts/customize-framework.sh
Or copy .claude/config/default-config.yaml to team-config.yaml and edit manually.
```

These configurations provide context about the team's specific workflows and should be considered when making suggestions or implementing features.

## Technology-Specific Agents

When working on projects/tasks, load the appropriate technology-specific agent file. These agents provide specialized knowledge and guidance for each technology stack. Each agent has specific color-coded indicators for different aspects of development.

**For detailed instructions on customizing agents, see: `.claude/guides/customization-guide.md`**

### Language Agents
- 🟢 **Node.js Agent**: `.claude/agents/nodejs-best-practices.md`
- 🐍 **Python Agent**: `.claude/agents/python-best-practices.md`
- 🐘 **PHP Agent**: `.claude/agents/php-best-practices.md`
- ☕ **Java Agent**: `.claude/agents/java-best-practices.md`

### Framework Agents
- 🅰️ **Angular Agent**: `.claude/agents/angular-best-practices.md`
- 🟦 **Vue.js Agent**: `.claude/agents/vuejs-best-practices.md`
- 🏛️ **ApostropheCMS Agent**: `.claude/agents/apostrophe-best-practices.md`

### Infrastructure & Architecture Agents
- 🐳 **Docker Agent**: `.claude/agents/docker-best-practices.md`
- 🔌 **API Design Agent**: `.claude/agents/api-design-best-practices.md`
- 🗄️ **Database Agent**: `.claude/agents/database-best-practices.md`
- 🛡️ **Security Agent**: `.claude/agents/security-best-practices.md`
- 📊 **Logging & Monitoring Agent**: `.claude/agents/logging-monitoring-best-practices.md`

### Integration Agents
- 🔧 **MCP Tools Agent**: `.claude/agents/mcp-best-practices.md`
- 🌐 **Full-Stack Integration Agent**: `.claude/agents/full-stack-integration-best-practices.md`
- ♻️ **Refactoring Agent**: `.claude/agents/refactoring.md`

## JIRA Integration

- Use `.claude/commands/jira.md` for JIRA task management
- When a task number is provided (e.g., `jira VCT234`), pass it as an argument

## Git Workflow

1. **Branch Creation**: Always create a branch with the format `{TASK-ID}` (e.g., `VCS-234`) based on the task identifier
2. **Committing**: Only commit when explicitly requested. When committing:
   - Include clear commit messages explaining the changes
   - Update relevant READMEs or changelogs with implementation details

## Implementation Process

1. **Session Initialization** (ALWAYS FIRST):
   - Perform health check to establish session state
   - Load or create session in `.claude/session/current-session.yaml`
   - Set initial mode based on task type (bug fix = DEBUG, new feature = BUILD)
   - If resuming, load handover documentation

2. **Load Team Configuration**: Check `.claude/config/team-config.yaml` and `.claude/config/workflow-config.yaml` to understand team preferences. If not found, use defaults but suggest running `./scripts/customize-framework.sh`

3. **Read Task Specifications**: Always start by reading `/tasks/{{JIRA_TASK_ID}}/{{JIRA_TASK_ID}}-specs.md`

4. **Create Implementation Plan**: Create `/tasks/{{JIRA_TASK_ID}}/{{JIRA_TASK_ID}}-IMPLEMENTATION.md` for review and approval
   - Include session breakpoints for LARGE/EPIC scopes
   - Plan natural handover points between major components

5. **Track Changes**: 
   - Create `claude_code_changes/` directory if it doesn't exist
   - For each session, create `claude_changes_{YYYY-MM-DD_HH-MM}.txt`
   - Begin the file with the current Git branch name and TaskID if exist
   - Document all changes made during the session
   - Update session state after significant milestones

## Test-Driven Development (TDD)

1. **Test Structure**: Use the `tests/` folder to maintain organized test files
2. **Test Creation Process**:
   - Write tests based on expected input/output pairs
   - Request clarification on test details when needed
   - Run tests to confirm they fail before implementing
3. **Implementation**:
   - Only write implementation code after tests are created
   - Do not modify tests during implementation
   - Continue until all tests pass
   - Use subagents when needed for complex tasks
4. **Interface Testing**:
   - Use Browser MCP for interface testing
   - Capture screenshots with Puppeteer MCP server

## Design Development

- Implement designs according to provided mockups
- Take screenshots using Puppeteer MCP server
- Iterate until the implementation matches the design mockup

## Code Quality Checks

1. Run the lint command for the project
2. Create a Markdown checklist of all errors with:
   - Filename
   - Line number
   - Error description
3. Fix issues systematically:
   - Address one issue at a time
   - Verify each fix before proceeding
   - Check off completed items in the checklist

## Respecting Team Preferences

When team configuration files exist in `.claude/config/`:
- Use the specified indentation style (spaces vs tabs, 2 vs 4 spaces)
- Follow the team's naming conventions (camelCase, snake_case, etc.)
- Respect maximum line length settings
- Apply the team's testing approach and coverage requirements
- Follow the configured branching strategy and PR review process
- Consider industry-specific requirements (healthcare, finance, etc.)

## API Development

- Follow OpenAPI/Swagger specifications in `.claude/best_practices/api-design-best-practices.md`
- Implement RESTful best practices
- Document all endpoints with request/response examples

## Database Design

- Reference `.claude/best_practices/database-best-practices.md` for SQL/NoSQL guidelines
- Follow migration strategies and naming conventions
- Implement proper indexing and query optimization

## Security Implementation

- Follow OWASP compliance checklist in `.claude/best_practices/security-best-practices.md`
- Integrate security scanning into CI/CD pipeline
- Implement proper authentication and authorization

## Logging and Monitoring

- Follow standards in `.claude/best_practices/logging-monitoring-best-practices.md`
- Environment-specific logging:
  - **Development**: Console and error log output for debugging
  - **Production**: No console output, only error logs unless explicitly configured
- Set up performance monitoring and alerting