# Claude Code Development Framework - Complete Documentation Index

> **Version:** 1.1.0 | **NPM Package:** create-jezweb-ai-app | **Repository:** [claude-code-framework](https://github.com/jezweb/claude-code-framework.git)

## 🚀 Quick Navigation

[**Getting Started**](#getting-started) | [**Session Management**](#session-management) | [**Best Practices**](#best-practices) | [**Commands**](#commands) | [**Scripts**](#scripts) | [**Templates**](#templates) | [**Configuration**](#configuration) | [**Examples**](#examples)

---

## 📋 Table of Contents

1. [Project Overview](#project-overview)
2. [Getting Started](#getting-started)
3. [Session Management](#session-management)
4. [Best Practices](#best-practices)
5. [Commands Reference](#commands-reference)
6. [Scripts & Tools](#scripts--tools)
7. [Templates & Guides](#templates--guides)
8. [Configuration](#configuration)
9. [Hooks & Integrations](#hooks--integrations)
10. [Examples & Tests](#examples--tests)
11. [Workflows](#workflows)
12. [Troubleshooting](#troubleshooting)

---

## Project Overview

The **Claude Code Development Framework** is a comprehensive toolkit for enhancing productivity with Claude Code (Anthropic's AI coding assistant). It addresses common challenges like conversation limits, standardization, and workflow automation.

### 🎯 Core Features

- **🔄 Session Management**: Intelligent conversation tracking with seamless handovers
- **📚 Best Practices Library**: Guidelines for 15+ technologies
- **🤖 Automation Tools**: JIRA integration and task processing
- **🎨 Customization**: Team-specific configurations
- **🔊 Audio Hooks**: Unique feedback system for operations
- **📦 NPM Distribution**: Easy setup via `npx create-jezweb-ai-app`

### 📁 Project Structure

```
claude_code_stuffs/
├── .claude/                    # Framework core
│   ├── best_practices/         # Technology guidelines (15 docs)
│   ├── commands/               # Command references (5 docs)
│   ├── config/                 # Team configurations
│   ├── guides/                 # How-to guides (2 docs)
│   ├── hooks/                  # Audio & notifications
│   ├── session/                # Session state
│   └── templates/              # Document templates (8 docs)
├── scripts/                    # Automation scripts (7 scripts)
├── tasks/                      # JIRA task management
├── test/                       # Example implementations
└── [Core Files]                # README, CLAUDE.md, package.json
```

---

## Getting Started

### 🚀 Installation Options

#### Option 1: NPM Package (Recommended)
```bash
# Create full application with boilerplate
npx create-jezweb-ai-app my-project

# Or just the framework
npx create-jezweb-ai-app my-project --framework-only
```

#### Option 2: Direct Clone
```bash
git clone https://github.com/jezweb/claude-code-framework.git
cd claude-code-framework
./scripts/customize-framework.sh
```

### 📋 Initial Setup

1. **Customize for Your Team**
   ```bash
   ./scripts/customize-framework.sh
   ```

2. **Install Development Tools**
   ```bash
   ./scripts/setup-dev-env.sh
   ```

3. **Start Your First Session**
   ```
   <Health-Check>
   ```

### 📖 Essential Documentation

- **[Main Guidelines](CLAUDE.md)** - Core development principles
- **[Project README](README.md)** - Quick start and overview
- **[Project Index](PROJECT_INDEX.md)** - Navigation guide

---

## Session Management

### 🎯 Overview

The session management system prevents Claude's conversation limit issues through intelligent monitoring and handover documentation.

### 📊 Health Indicators

| Status | Messages | Action |
|--------|----------|---------|
| 🟢 **Healthy** | 0-30 | Continue normally |
| 🟡 **Approaching** | 31-45 | Plan for handover |
| 🔴 **Handover** | 46+ | Generate handover immediately |

### 🛠 Commands

#### Session Control
- `<Health-Check>` - Check current session health
- `<Handover01>` - Generate handover documentation
- `<Session-Metrics>` - View detailed statistics

#### Mode Switching
- `MODE: DEBUG` - Detailed troubleshooting
- `MODE: BUILD` - Feature implementation
- `MODE: REVIEW` - Code review
- `MODE: LEARN` - Educational mode
- `MODE: RAPID` - Quick responses

#### Scope Setting
- `SCOPE: MICRO` - 1-5 lines
- `SCOPE: SMALL` - 5-20 lines
- `SCOPE: MEDIUM` - 20-50 lines
- `SCOPE: LARGE` - 50+ lines
- `SCOPE: EPIC` - Multi-file changes

### 📁 Related Files
- **[Session Management Guide](.claude/guides/session-management-guide.md)**
- **[Health Check Command](.claude/commands/health-check.md)**
- **[Handover Template](.claude/templates/handover-template.md)**

---

## Best Practices

### 🎯 Technology Coverage

The framework includes comprehensive best practices for 15+ technologies:

#### Frontend Development
- **[Angular](.claude/best_practices/angular-best-practices.md)** - Components, RxJS, testing
- **[Vue.js](.claude/best_practices/vuejs-best-practices.md)** - Composition API, Vuex

#### Backend Development
- **[Node.js](.claude/best_practices/nodejs-best-practices.md)** - Express, async, security
- **[Python](.claude/best_practices/python-best-practices.md)** - PEP 8, Django/Flask
- **[PHP](.claude/best_practices/php-best-practices.md)** - PSR standards, Laravel
- **[Java](.claude/best_practices/java-best-practices.md)** - Spring Boot, patterns

#### Infrastructure & DevOps
- **[Docker](.claude/best_practices/docker-best-practices.md)** - Containers, security
- **[Database](.claude/best_practices/database-best-practices.md)** - SQL/NoSQL design
- **[API Design](.claude/best_practices/api-design-best-practices.md)** - REST, OpenAPI

#### Quality & Security
- **[Security](.claude/best_practices/security-best-practices.md)** - OWASP compliance
- **[Logging & Monitoring](.claude/best_practices/logging-monitoring-best-practices.md)** - Observability
- **[Refactoring](.claude/best_practices/refactoring.md)** - Clean code

#### Integration
- **[MCP Tools](.claude/best_practices/mcp-best-practices.md)** - Model Context Protocol
- **[Full Stack](.claude/best_practices/full-stack-integration-best-practices.md)** - Frontend-backend
- **[ApostropheCMS](.claude/best_practices/apostrophe-best-practices.md)** - CMS patterns

### 🛠 Customization

Best practices can be customized for your team:
- Run `./scripts/customize-framework.sh` for guided setup
- See **[Customization Guide](.claude/guides/customization-guide.md)**
- Validate with `./scripts/validate-best-practices.sh`

---

## Commands Reference

### 📋 Available Commands

#### Development Commands
- **[JIRA Integration](.claude/commands/jira.md)** - Task management
- **[Documentation](.claude/commands/document.md)** - Generate docs
- **[GitHub Issues](.claude/commands/fix-github-issues.md)** - Fix common issues
- **[Parallel Execution](.claude/commands/execute_parallel_agents.md)** - Run parallel agents

### 🔧 Command Usage

```bash
# JIRA task management
jira VCS-234

# Generate documentation
<Document>

# Fix GitHub issues
fix-github-issues

# Execute parallel agents
execute_parallel_agents --tasks task1,task2,task3
```

---

## Scripts & Tools

### 🚀 Automation Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| **customize-framework.sh** | Interactive team setup | `./scripts/customize-framework.sh` |
| **setup-dev-env.sh** | Install dev tools | `./scripts/setup-dev-env.sh` |
| **run_claude.sh** | Automated JIRA processing | `./scripts/run_claude.sh` |
| **validate-best-practices.sh** | Validate customizations | `./scripts/validate-best-practices.sh` |
| **add-mcp.sh** | Add MCP tools | `./scripts/add-mcp.sh` |
| **init-project.sh** | Initialize project | `./scripts/init-project.sh` |

### 📖 Script Features

#### run_claude.sh - Automated Task Processing
- **Intelligent Retry**: Max 3 attempts with different strategies
- **Stuck Detection**: MD5 hashing to detect loops
- **Model Limit Handling**: Graceful handover generation
- **Comprehensive Logging**: Color-coded status tracking

See **[Scripts README](scripts/README.md)** for detailed documentation.

---

## Templates & Guides

### 📝 Document Templates

#### Development Templates
- **[Task Specification](.claude/templates/task-spec-template.md)** - JIRA tasks
- **[Pull Request](.claude/templates/pull-request-template.md)** - PR descriptions
- **[Code Review](.claude/templates/code-review-checklist.md)** - Review standards

#### Team Templates
- **[Team Quick Reference](.claude/templates/team-quick-reference.md)** - One-page guide
- **[Migration Guide](.claude/templates/migration-guide-template.md)** - Framework migration
- **[Custom Best Practice](.claude/templates/custom-best-practice-template.md)** - New practices
- **[Best Practice Addendum](.claude/templates/best-practice-addendum-template.md)** - Extend practices

### 📚 Guides

- **[Customization Guide](.claude/guides/customization-guide.md)** - Team customization
- **[Session Management Guide](.claude/guides/session-management-guide.md)** - Session handling

---

## Configuration

### ⚙️ Team Configuration

Configuration files in `.claude/config/`:

| File | Purpose |
|------|---------|
| **team-config.yaml** | Team size, tech stack, standards |
| **workflow-config.yaml** | Branching, PR requirements |
| **config-schema.yaml** | Configuration validation |
| **default-config.yaml** | Base configuration |

### 📁 Example Configurations

Pre-built configurations available:
- Startup teams
- Enterprise organizations
- Open source projects

### 🔧 Loading Configuration

```bash
# Load configuration
source .claude/config/load-config.sh

# Validate configuration
./scripts/validate-best-practices.sh
```

---

## Hooks & Integrations

### 🔊 Audio Hooks System

Unique audio feedback system in `.claude/hooks/`:

#### Features
- **Sound Effects**: Operation feedback
- **Tool Hooks**: Pre/post execution
- **TTS Integration**: ElevenLabs, OpenAI, pyttsx3
- **LLM Support**: Anthropic and OpenAI

#### Configuration
See **[Hooks README](.claude/hooks/README.md)** for setup instructions.

### 🤖 MCP Integration

Model Context Protocol tools:
- Browser automation
- Puppeteer integration
- API testing

See **[MCP Best Practices](.claude/best_practices/mcp-best-practices.md)**.

---

## Examples & Tests

### 📂 Test Directory

Example implementations in `test/`:
- **nodejs-optimization-blog-article.md** - Optimization guide
- **claude-optimized-manual.md** - Framework manual
- **nodejs-multithreading-guide.md** - Threading guide

### 🧪 Testing Approach

1. **TDD Workflow**: Write tests first
2. **Unit Testing**: Component isolation
3. **Integration Testing**: System verification
4. **E2E Testing**: User workflows

---

## Workflows

### 🔄 Standard Development Flow

```mermaid
graph LR
    A[Health Check] --> B[Load Task]
    B --> C[Create Plan]
    C --> D[Implement]
    D --> E[Test]
    E --> F[Lint]
    F --> G[Commit]
    G --> H[Update JIRA]
```

### 📋 Task Management

1. **Initialize Session**
   ```
   <Health-Check>
   jira VCS-234
   ```

2. **Development**
   ```
   git checkout -b VCS-234
   # implement changes
   ```

3. **Quality Checks**
   ```
   npm run lint
   npm test
   ```

4. **Commit & Push**
   ```
   git commit -m "VCS-234: Feature complete"
   git push origin VCS-234
   ```

---

## Troubleshooting

### 🚨 Common Issues

#### Session Limits
- **Problem**: Approaching conversation limit
- **Solution**: Use `<Handover01>` to generate documentation

#### Script Errors
- **Problem**: "declare: not found"
- **Solution**: Use `bash` instead of `sh`

#### No Tasks Found
- **Problem**: run_claude.sh finds no tasks
- **Solution**: Ensure proper task structure in `tasks/` directory

### 📞 Support

- Check issue tracker on GitHub
- Review documentation thoroughly
- Use `<Health-Check>` for session diagnostics

---

## 📊 Quick Reference Card

### Essential Commands
```bash
# Setup
npx create-jezweb-ai-app my-project
./scripts/customize-framework.sh

# Session Management
<Health-Check>
<Handover01>
MODE: BUILD
SCOPE: LARGE

# Development
jira VCS-234
git checkout -b VCS-234
npm run lint
git commit -m "VCS-234: Done"
```

### Best Practices
✅ Always start with health check  
✅ Use appropriate mode for task  
✅ Track changes in session files  
✅ Generate handover at limits  
❌ Never commit secrets  
❌ Don't skip testing  
❌ Avoid console.log in production  

---

*Framework Version: 1.1.0 | Last Updated: December 2024*