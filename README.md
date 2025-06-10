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
   ```bash
   ./scripts/setup-dev-env.sh
   ```

3. **Review the main guidelines:**
   - Read `CLAUDE.md` for core development principles
   - Check relevant technology-specific guides in `.claude/commands/`

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

### Working on a New Task

1. **Create a task branch:**
   ```bash
   git checkout -b TASK-123
   ```

2. **Read task specifications:**
   ```
   /tasks/TASK-123/TASK-123-specs.md
   ```

3. **Create implementation plan:**
   ```
   /tasks/TASK-123/TASK-123-IMPLEMENTATION.md
   ```

4. **Track your changes:**
   - Claude Code automatically creates session files in `claude_code_changes/`
   - Format: `claude_changes_YYYY-MM-DD_HH-MM.txt`

### Technology-Specific Development

When starting work on a project, load the appropriate best practices:

```bash
# For Node.js projects
cat .claude/commands/nodejs-best-practices.md

# For API development
cat .claude/commands/api-design-best-practices.md

# For database work
cat .claude/commands/database-best-practices.md
```

### Security Implementation

1. Review security checklist:
   ```bash
   cat .claude/commands/security-best-practices.md
   ```

2. Run security audits:
   ```bash
   npm audit  # For Node.js projects
   ```

3. Implement security headers and authentication per guidelines

### Database Development

1. Follow naming conventions in `.claude/commands/database-best-practices.md`
2. Create migrations with up/down scripts
3. Implement proper indexing and query optimization
4. Use connection pooling and monitoring

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