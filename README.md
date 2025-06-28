# Claude Code Development Framework

A comprehensive development framework and best practices collection for working with Claude Code on various technology stacks.

## Overview

This repository contains structured guidelines, best practices, and tools for efficient software development with Claude Code. It provides technology-specific guidance, workflow automation, and quality assurance processes.

### 🚀 New: Session Management System

The framework now includes an intelligent session management system that:
- **Prevents conversation limit issues** with health monitoring (🟢 Healthy → 🟡 Approaching → 🔴 Handover)
- **Enables seamless handovers** between Claude sessions
- **Tracks work context** including mode, scope, and task progress
- **Integrates with existing workflow** for continuous development

Try it: Start any conversation with `<Health-Check>` to see session status!

## Directory Structure

```
.
├── .claude/
│   ├── best_practices/  # Technology-specific best practices
│   │   ├── angular-best-practices.md
│   │   ├── api-design-best-practices.md
│   │   ├── apostrophe-best-practices.md
│   │   ├── database-best-practices.md
│   │   ├── docker-best-practices.md
│   │   ├── java-best-practices.md
│   │   ├── logging-monitoring-best-practices.md
│   │   ├── nodejs-best-practices.md
│   │   ├── php-best-practices.md
│   │   ├── python-best-practices.md
│   │   ├── security-best-practices.md
│   │   └── mcp-best-practices.md
│   │   └── vuejs-best-practices.md
│   │   └── full-stack-integration-best-practices.md
│   ├── commands/
│   │   ├── jira.md
│   │   ├── fix-github-issues.md
│   │   ├── document.md
│   │   └── health-check.md         # Session health monitoring
│   ├── config/             # Team configurations
│   │   ├── examples/       # Example configurations
│   │   ├── config-schema.yaml
│   │   ├── default-config.yaml
│   │   └── load-config.sh
│   ├── guides/             # How-to guides
│   │   ├── customization-guide.md
│   │   └── session-management-guide.md
│   ├── session/            # Session state management
│   │   └── current-session.yaml
│   └── templates/          # Project templates
│       ├── code-review-checklist.md
│       ├── pull-request-template.md
│       ├── task-spec-template.md
│       ├── custom-best-practice-template.md
│       ├── best-practice-addendum-template.md
│       ├── team-quick-reference.md
│       ├── migration-guide-template.md
│       └── handover-template.md    # Session handover documentation
├── claude_code_changes/    # Session change tracking
├── scripts/                # Utility scripts
│   ├── setup-dev-env.sh   # Development environment setup
│   ├── customize-framework.sh  # Interactive customization tool
│   └── validate-best-practices.sh  # Validation tool for customizations
├── tasks/                  # Task specifications and implementations
│   └── specs/             # Task specification documents
├── CLAUDE.md              # Main Claude Code guidelines
└── README.md              # This file
```

## Quick Start

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd claude_code_stuffs
   ```

2. **Set up development environment:**
This only applies if it is a new project and fits with your workflow.
   ```bash
   ./scripts/setup-dev-env.sh
   ```

3. **Customize for your team (optional but recommended):**
   ```bash
   ./scripts/customize-framework.sh
   ```

4. **Review the main guidelines:**
   - Read `CLAUDE.md` for core development principles
   - Check relevant technology-specific guides in `.claude/best_practises/`

## Key Features

### 🎯 Session Management System

- **Health Monitoring**: Automatic tracking of conversation length with visual indicators
- **Smart Handovers**: Generate comprehensive handover documents when approaching limits
- **Mode Switching**: DEBUG, BUILD, REVIEW, LEARN, RAPID modes for different contexts
- **Scope Tracking**: MICRO to EPIC classifications for work complexity
- **Command Triggers**: `<Health-Check>`, `<Handover01>`, mode/scope commands
- **State Persistence**: Maintains context across sessions in `.claude/session/`

### 🛠 Technology-Specific Best Practices

Comprehensive guides for:
- **Frontend**: Angular, JavaScript/TypeScript
- **Backend**: Node.js, Python, PHP, Java
- **Infrastructure**: Docker, Database (SQL/NoSQL)
- **API Development**: RESTful APIs, OpenAPI/Swagger
- **CMS**: ApostropheCMS
- **Security**: OWASP compliance, authentication, encryption
- **Monitoring**: Logging strategies, performance monitoring
- **MCP Tools**: Model Context Protocol, version management, tool integration

### 📋 Workflow Management

- **JIRA Integration**: Structured task management
- **Git Workflow**: Branch naming, commit conventions
- **Change Tracking**: Automatic session documentation
- **Test-Driven Development**: TDD methodology and practices

### 🔒 Security & Quality

- **Security Best Practices**: OWASP Top 10 compliance checklist
- **Code Quality**: Linting, testing, and review processes
- **API Security**: Authentication, rate limiting, CORS
- **Database Security**: Query parameterization, encryption

### ⚙️ Team Configuration

- **Config Directory**: `.claude/config/` stores all team-specific settings
- **Example Configs**: Pre-built configurations for startups, enterprises, and open source
- **Config Schema**: Validation schema for configuration files
- **Config Loader**: Shell script to load configurations as environment variables

### 📄 Customization Templates

- **Best Practice Template**: Create new technology-specific best practices
- **Addendum Template**: Add team customizations without modifying originals
- **Quick Reference**: One-page team reference guide
- **Migration Guide**: Template for teams transitioning from other frameworks

### 📊 Logging & Monitoring

Environment-specific logging strategies:
- **Development**: Verbose console and file logging
- **Production**: Error-only logging with monitoring integration

## Usage Guide

### Customizing Best Practices

The best practices files in `.claude/best_practices/` provide comprehensive defaults based on industry standards. However, these files are meant to be customized to match your team's specific workflows and requirements. 

**🚀 Quick Start**: Run `./scripts/customize-framework.sh` for an interactive setup that customizes practices based on your team's needs.

**📖 Manual Customization**: See the [Customization Guide](.claude/guides/customization-guide.md) for detailed instructions.

**✅ Validate Customizations**: Run `./scripts/validate-best-practices.sh` to check your customizations for errors and consistency.

Feel free to edit these files to:
- Add project-specific conventions
- Modify guidelines to match your team's practices
- Include company-specific requirements
- Remove sections that don't apply to your use case

### Session Management

When working with Claude Code, the session management system helps prevent conversation limit issues:

1. **Start with a health check:**
   ```
   <Health-Check>
   ```
   This shows your session status and sets appropriate mode/scope.

2. **Monitor session health:**
   - 🟢 Healthy (0-30 messages): Continue normally
   - 🟡 Approaching (31-45 messages): Plan for handover
   - 🔴 Handover Now (46+ messages): Generate handover immediately

3. **Switch modes as needed:**
   ```
   MODE: DEBUG      # For troubleshooting
   MODE: BUILD      # For implementation
   MODE: REVIEW     # For code review
   MODE: RAPID      # For quick responses
   ```

4. **Generate handover when needed:**
   ```
   <Handover01>
   ```
   This creates a comprehensive handover document for the next session.

For detailed information, see the [Session Management Guide](.claude/guides/session-management-guide.md).

### Working on a New Task

1. **Start with session initialization:**
   ```
   <Health-Check>
   Please retrieve the task from Jira MCP with the ID TASK-123 and proceed to create documentation for it.
   ```

2. **Create implementation:**
   ```
   Create implementation from TASK-123
   ```

3. **Track your changes:**
   - Claude Code automatically creates session files in `claude_code_changes/`
   - Format: `claude_changes_YYYY-MM-DD_HH-MM.txt`
   - Session state tracked in `.claude/session/current-session.yaml`

4. **Test your code in real-world cases**
   ```
   Do your usual testing. Since I recommend always having a separate branch for each task, you can easily view the changes using Git Diff in any visual editor. This allows you to see what needs testing, what has been affected, and to apply your programming skills accordingly. Of course, test it and code it until it works.
   ```

5. **Linting and retest**
   ```
   Sometimes linting modifies files, so you will need to review the changes and retest your code.
   ```

6. **Commit**
   ```
   Commit your changes, push them, and create a pull request (PR) in Git, or merge directly into the develop/main branch (depending on your workflow). You can also request a version tag if needed. Use any Git commands you typically work with.
   ```

6. **Create Jira Comment/Change status**
   ```
   Ask Claude to add a comment summarizing the work you’ve done. You can also ask to log the time spent or change the task status so it moves to QA for review.
   ```

## Best Practices Summary

### Git Commits
- Only commit when explicitly requested
- Use clear, descriptive commit messages
- Include task IDs in branch names

### Code Quality
- Run linters before committing
- Write tests before implementation (TDD)
- Document API endpoints
- Follow technology-specific conventions

### Security
- Never commit secrets or credentials
- Use environment variables for configuration
- Implement proper authentication and authorization
- Follow OWASP guidelines

### Logging
- Development: Console + error logs for debugging
- Production: No console output unless configured
- Use structured logging with appropriate levels
- Include request IDs for tracing

## Contributing

1. Follow the established patterns in existing files
2. Update relevant documentation when adding features
3. Test all changes thoroughly
4. Create pull requests with detailed descriptions

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OpenAPI Specification](https://swagger.io/specification/)

## License

[Your License Here]

---

For questions or issues, please refer to the project's issue tracker or contact the development team.
