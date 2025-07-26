# Claude Code Development Framework - Project Documentation Index

> A comprehensive index of all documentation, guides, and resources in the Claude Code Development Framework

## 📚 Table of Contents

1. [Overview](#overview)
2. [Core Documentation](#core-documentation)
3. [Best Practices Library](#best-practices-library)
4. [Guides & Tutorials](#guides--tutorials)
5. [Commands Reference](#commands-reference)
6. [Templates Collection](#templates-collection)
7. [Scripts & Tools](#scripts--tools)
8. [Configuration](#configuration)
9. [Session Management](#session-management)
10. [Quick Reference](#quick-reference)

---

## Overview

The Claude Code Development Framework is a comprehensive collection of best practices, tools, and guidelines for efficient software development with Claude Code. It provides:

- 🎯 **Session Management System** - Prevents conversation limits with intelligent handovers
- 🛠 **Technology-Specific Best Practices** - Covering 15+ technologies
- 📋 **Workflow Automation** - JIRA integration, Git workflows, and change tracking
- 🔒 **Security & Quality Standards** - OWASP compliance and code quality tools
- ⚙️ **Team Customization** - Configurable for different team sizes and workflows

## Core Documentation

### Main Guidelines
- **[README.md](README.md)** - Project overview and quick start guide
- **[CLAUDE.md](CLAUDE.md)** - Core Claude Code development guidelines and session management

### Directory Structure
```
claude_code_stuffs/
├── .claude/               # Framework core files
│   ├── best_practices/    # Technology guides
│   ├── commands/          # Command references
│   ├── config/           # Team configurations
│   ├── guides/           # How-to guides
│   ├── hooks/            # Git hooks
│   ├── session/          # Session state
│   └── templates/        # Document templates
├── scripts/              # Utility scripts
├── tasks/               # Task management
└── test/                # Test resources
```

## Best Practices Library

### Frontend Technologies
- **[Angular Best Practices](.claude/best_practices/angular-best-practices.md)** - Component architecture, RxJS, testing
- **[Vue.js Best Practices](.claude/best_practices/vuejs-best-practices.md)** - Composition API, Vuex, optimization

### Backend Technologies
- **[Node.js Best Practices](.claude/best_practices/nodejs-best-practices.md)** - Express, async patterns, security
- **[Python Best Practices](.claude/best_practices/python-best-practices.md)** - PEP 8, Django/Flask, testing
- **[PHP Best Practices](.claude/best_practices/php-best-practices.md)** - PSR standards, Laravel, security
- **[Java Best Practices](.claude/best_practices/java-best-practices.md)** - Spring Boot, design patterns, testing

### Infrastructure & DevOps
- **[Docker Best Practices](.claude/best_practices/docker-best-practices.md)** - Containerization, optimization, security
- **[Database Best Practices](.claude/best_practices/database-best-practices.md)** - SQL/NoSQL, migrations, optimization
- **[API Design Best Practices](.claude/best_practices/api-design-best-practices.md)** - RESTful design, OpenAPI, versioning

### Security & Quality
- **[Security Best Practices](.claude/best_practices/security-best-practices.md)** - OWASP Top 10, authentication, encryption
- **[Logging & Monitoring](.claude/best_practices/logging-monitoring-best-practices.md)** - Structured logging, metrics, alerting
- **[Refactoring Guide](.claude/best_practices/refactoring.md)** - Clean code principles, patterns

### Integration & Tools
- **[MCP Best Practices](.claude/best_practices/mcp-best-practices.md)** - Model Context Protocol integration
- **[Full Stack Integration](.claude/best_practices/full-stack-integration-best-practices.md)** - Frontend-backend coordination
- **[ApostropheCMS Best Practices](.claude/best_practices/apostrophe-best-practices.md)** - CMS development patterns

## Guides & Tutorials

### Getting Started
1. **[Customization Guide](.claude/guides/customization-guide.md)** - How to customize the framework for your team
2. **[Session Management Guide](.claude/guides/session-management-guide.md)** - Managing Claude sessions effectively

### Setup & Configuration
- Run `./scripts/customize-framework.sh` for interactive setup
- Use `./scripts/setup-dev-env.sh` to install development tools
- Validate customizations with `./scripts/validate-best-practices.sh`

## Commands Reference

### Session Management Commands
- **[Health Check](.claude/commands/health-check.md)** - `<Health-Check>` - Monitor session health
- **Handover** - `<Handover01>` - Generate handover documentation
- **Session Metrics** - `<Session-Metrics>` - View detailed statistics

### Development Commands
- **[JIRA Integration](.claude/commands/jira.md)** - Task management and workflow
- **[Documentation](.claude/commands/document.md)** - Generate project documentation
- **[GitHub Issues](.claude/commands/fix-github-issues.md)** - Fix common GitHub issues
- **[Parallel Execution](.claude/commands/execute_parallel_agents.md)** - Run parallel agents

### Mode Switching
- `MODE: DEBUG` - Detailed troubleshooting
- `MODE: BUILD` - Feature implementation
- `MODE: REVIEW` - Code review
- `MODE: LEARN` - Educational explanations
- `MODE: RAPID` - Quick responses

### Scope Setting
- `SCOPE: MICRO` - 1-5 lines
- `SCOPE: SMALL` - 5-20 lines
- `SCOPE: MEDIUM` - 20-50 lines
- `SCOPE: LARGE` - 50+ lines
- `SCOPE: EPIC` - Multi-file changes

## Templates Collection

### Development Templates
- **[Task Specification](.claude/templates/task-spec-template.md)** - JIRA task documentation
- **[Pull Request](.claude/templates/pull-request-template.md)** - PR descriptions
- **[Code Review Checklist](.claude/templates/code-review-checklist.md)** - Review standards

### Team Templates
- **[Team Quick Reference](.claude/templates/team-quick-reference.md)** - One-page team guide
- **[Migration Guide](.claude/templates/migration-guide-template.md)** - Framework migration
- **[Custom Best Practice](.claude/templates/custom-best-practice-template.md)** - Create new practices
- **[Best Practice Addendum](.claude/templates/best-practice-addendum-template.md)** - Extend existing practices

### Session Templates
- **[Handover Template](.claude/templates/handover-template.md)** - Session continuation documentation

## Scripts & Tools

### Setup Scripts
- **[customize-framework.sh](scripts/customize-framework.sh)** - Interactive team configuration
- **[setup-dev-env.sh](scripts/setup-dev-env.sh)** - Development environment setup
- **[validate-best-practices.sh](scripts/validate-best-practices.sh)** - Validate customizations

### Automation Scripts
- **[run_claude.sh](scripts/run_claude.sh)** - Automated JIRA task processing with retry logic
- **[add-mcp.sh](scripts/add-mcp.sh)** - Add MCP tools to project

### Script Documentation
- **[Scripts README](scripts/README.md)** - Detailed script usage and features

## Configuration

### Team Configuration
- **[Config Directory](.claude/config/)** - Team-specific settings
- **[Config Schema](.claude/config/config-schema.yaml)** - Configuration validation
- **[Default Config](.claude/config/default-config.yaml)** - Base configuration

### Example Configurations
- Startup teams
- Enterprise organizations
- Open source projects

## Session Management

### Key Features
- 🟢 **Healthy (0-30 messages)** - Normal operation
- 🟡 **Approaching (31-45)** - Plan for handover
- 🔴 **Handover (46+)** - Generate handover document

### Session Files
- `.claude/session/current-session.yaml` - Current session state
- `claude_code_changes/` - Change tracking per session

### Handover Process
1. Monitor health with `<Health-Check>`
2. Generate handover with `<Handover01>`
3. Resume with handover documentation

## Quick Reference

### Essential Commands
```bash
# Initial setup
./scripts/customize-framework.sh
./scripts/setup-dev-env.sh

# Session management
<Health-Check>
<Handover01>
MODE: BUILD
SCOPE: LARGE

# Development workflow
jira VCS-234
git checkout -b VCS-234
# ... make changes ...
git commit -m "VCS-234: Implementation complete"
```

### Best Practices Summary
- ✅ Always start with a health check
- ✅ Use appropriate mode for task type
- ✅ Track changes in session files
- ✅ Run linters before committing
- ✅ Generate handover at session limits
- ❌ Never commit secrets
- ❌ Don't skip testing
- ❌ Avoid console.log in production

### Workflow Overview
1. **Initialize** - Health check and load configuration
2. **Plan** - Create implementation plan from specs
3. **Implement** - Follow TDD and best practices
4. **Test** - Unit, integration, and E2E tests
5. **Lint** - Fix code quality issues
6. **Commit** - Clear messages with task IDs
7. **Document** - Update relevant documentation

---

## Contributing

1. Follow established patterns in existing files
2. Update documentation when adding features
3. Test all changes thoroughly
4. Create detailed pull requests

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/claude-code)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [OpenAPI Specification](https://swagger.io/specification/)

---

*Last updated: December 2024*
*Framework version: 1.0*