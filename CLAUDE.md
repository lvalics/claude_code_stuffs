# Claude Code Development Guidelines

## Technology-Specific Best Practices

When working on projects/tasks, load the appropriate technology-specific best practices file. These files provide comprehensive defaults but can and should be customized to match your team's specific workflows, coding standards, and project requirements.
- **Node.js**: `.claude/best_practices/nodejs-best-practices.md`
- **Python**: `.claude/best_practices/python-best-practices.md`
- **PHP**: `.claude/best_practices/php-best-practices.md`
- **Java**: `.claude/best_practices/java-best-practices.md`
- **Angular**: `.claude/best_practices/angular-best-practices.md`
- **ApostropheCMS**: `.claude/best_practices/apostrophe-best-practices.md`
- **Docker**: `.claude/best_practices/docker-best-practices.md`
- **API Design**: `.claude/best_practices/api-design-best-practices.md`
- **Database**: `.claude/best_practices/database-best-practices.md`
- **Security**: `.claude/best_practices/security-best-practices.md`
- **Logging & Monitoring**: `.claude/best_practices/logging-monitoring-best-practices.md`

## JIRA Integration

- Use `.claude/commands/jira.md` for JIRA task management
- When a task number is provided (e.g., `jira VCT234`), pass it as an argument

## Git Workflow

1. **Branch Creation**: Always create a branch with the format `{TASK-ID}` (e.g., `VCS-234`) based on the task identifier
2. **Committing**: Only commit when explicitly requested. When committing:
   - Include clear commit messages explaining the changes
   - Update relevant READMEs or changelogs with implementation details

## Implementation Process

1. **Read Task Specifications**: Always start by reading `/tasks/{{JIRA_TASK_ID}}/{{JIRA_TASK_ID}}-specs.md`
2. **Create Implementation Plan**: Create `/tasks/{{JIRA_TASK_ID}}/{{JIRA_TASK_ID}}-IMPLEMENTATION.md` for review and approval
3. **Track Changes**: 
   - Create `claude_code_changes/` directory if it doesn't exist
   - For each session, create `claude_changes_{YYYY-MM-DD_HH-MM}.txt`
   - Begin the file with the current Git branch name and TaskID if exist.
   - Document all changes made during the session

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