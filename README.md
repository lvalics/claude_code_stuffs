# Claude Code Development Framework

A comprehensive development framework and best practices collection for working with Claude Code on various technology stacks.

## Overview

This repository contains structured guidelines, best practices, and tools for efficient software development with Claude Code. It provides technology-specific guidance, workflow automation, and quality assurance processes.

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
│   │   └── security-best-practices.md
│   ├── commands/
│   │   ├── jira.md
│   │   ├── fix-github-issues.md
│   └── templates/          # Project templates
│       ├── code-review-checklist.md
│       ├── pull-request-template.md
│       └── task-spec-template.md
├── claude_code_changes/    # Session change tracking
├── scripts/                # Utility scripts
│   └── setup-dev-env.sh   # Development environment setup
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

3. **Review the main guidelines:**
   - Read `CLAUDE.md` for core development principles
   - Check relevant technology-specific guides in `.claude/best_practises/`

## Key Features

### 🛠 Technology-Specific Best Practices

Comprehensive guides for:
- **Frontend**: Angular, JavaScript/TypeScript
- **Backend**: Node.js, Python, PHP, Java
- **Infrastructure**: Docker, Database (SQL/NoSQL)
- **API Development**: RESTful APIs, OpenAPI/Swagger
- **CMS**: ApostropheCMS
- **Security**: OWASP compliance, authentication, encryption
- **Monitoring**: Logging strategies, performance monitoring

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

### 📊 Logging & Monitoring

Environment-specific logging strategies:
- **Development**: Verbose console and file logging
- **Production**: Error-only logging with monitoring integration

## Usage Guide

### Customizing Best Practices

The best practices files in `.claude/best_practices/` provide comprehensive defaults based on industry standards. However, these files are meant to be customized to match your team's specific workflows and requirements. Feel free to edit these files to:
- Add project-specific conventions
- Modify guidelines to match your team's practices
- Include company-specific requirements
- Remove sections that don't apply to your use case

### Working on a New Task

1. **Send to Claude a prompt like**
   ```
   Please retrieve the task from Jira MCP with the ID TASK-123 and proceed to create documentation for it.
   ```

2. **Create implementation:**
   ```
   Create implementation from TASK-123
   ```

3. **Track your changes:**
   - Claude Code automatically creates session files in `claude_code_changes/`
   - Format: `claude_changes_YYYY-MM-DD_HH-MM.txt`

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