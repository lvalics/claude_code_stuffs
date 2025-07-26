# create-jezweb-ai-app

[![npm version](https://img.shields.io/npm/v/create-jezweb-ai-app.svg)](https://www.npmjs.com/package/create-jezweb-ai-app)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

> A powerful CLI scaffolding tool that creates full-stack AI applications using the Jezweb boilerplate and integrates the Claude Code Development Framework for efficient AI-assisted development.

## 🎯 Overview

`create-jezweb-ai-app` serves two primary purposes:

1. **🚀 Create New AI Applications** - Scaffold a complete full-stack AI application with Vue.js frontend and FastAPI backend
2. **🛠️ Add Claude Code Framework** - Integrate the comprehensive Claude Code development framework into existing projects

This tool combines modern web development practices with AI-assisted workflows, providing teams with a structured approach to building AI-powered applications.

## ✨ Key Features

### 🏗️ Full-Stack AI Scaffolding
- **Frontend**: Vue.js with modern composition API
- **Backend**: FastAPI with async Python
- **Database**: PostgreSQL with SQLAlchemy ORM
- **Authentication**: JWT-based auth system
- **AI Integration**: OpenAI API integration ready

### 🤖 Claude Code Development Framework

The integrated framework provides:

#### 🎯 **Session Management System**
- **Health Monitoring**: Track conversation length with visual indicators (🟢 → 🟡 → 🔴)
- **Smart Handovers**: Generate comprehensive documentation when approaching Claude's limits
- **Mode Switching**: DEBUG, BUILD, REVIEW, LEARN, RAPID modes for different contexts
- **State Persistence**: Maintain context across Claude sessions

#### 🛠️ **Technology Best Practices** (15+ Guides)
- **Frontend**: Angular, Vue.js, React patterns
- **Backend**: Node.js, Python, PHP, Java
- **Infrastructure**: Docker, Database, API Design
- **Quality**: Security, Testing, Monitoring

#### 📋 **Workflow Automation**
- **JIRA Integration**: Automated task management
- **Git Workflows**: Branch naming, commit conventions
- **Change Tracking**: Automatic session documentation
- **TDD Support**: Test-driven development methodology

#### ⚙️ **Team Customization**
- **Configurable Standards**: Coding styles, naming conventions
- **Industry Compliance**: Healthcare, finance, e-commerce presets
- **Team Size Optimization**: From startups to enterprises

## 📦 Installation

### Global Installation (Recommended)
```bash
npm install -g create-jezweb-ai-app
```

### Direct Usage (Without Installation)
```bash
npx create-jezweb-ai-app my-ai-project
```

## 🚀 Quick Start

### Create a New AI Application
```bash
# Interactive mode (recommended)
create-jezweb-ai-app

# Quick mode with project name
create-jezweb-ai-app my-ai-app --quick

# You'll be prompted for:
# - Project name
# - Project description
# - Author name
# - Python version (3.8, 3.9, 3.10, 3.11)
```

### Add Framework to Existing Project
```bash
# From your project root
create-jezweb-ai-app --framework-only

# This will:
# 1. Add the .claude/ directory with all framework files
# 2. Create necessary configuration files
# 3. Set up session management
# 4. Install development tools
```

## 📁 Project Structure

### New AI Application Structure
```
my-ai-app/
├── frontend/              # Vue.js application
│   ├── src/
│   │   ├── components/   # Vue components
│   │   ├── views/       # Page components
│   │   ├── stores/      # Pinia stores
│   │   ├── api/         # API client
│   │   └── main.js      # App entry point
│   └── package.json
├── backend/              # FastAPI application
│   ├── app/
│   │   ├── api/         # API routes
│   │   ├── models/      # Database models
│   │   ├── services/    # Business logic
│   │   └── main.py      # FastAPI app
│   └── requirements.txt
├── .claude/              # Claude Code Framework
├── docker-compose.yml    # Container orchestration
└── README.md            # Project documentation
```

### Claude Code Framework Structure
```
.claude/
├── best_practices/       # Technology-specific guides
│   ├── nodejs-best-practices.md
│   ├── python-best-practices.md
│   ├── vuejs-best-practices.md
│   └── [13 more guides...]
├── commands/            # Command references
│   ├── jira.md         # JIRA integration
│   ├── health-check.md # Session management
│   └── document.md     # Documentation generation
├── config/             # Team configurations
│   ├── team-config.yaml
│   └── examples/       # Preset configurations
├── guides/             # How-to guides
├── session/            # Session state management
└── templates/          # Document templates
```

## 💡 Usage Examples

### 1. Starting a New Feature
```bash
# Initialize session
<Health-Check>

# Get JIRA task
jira TASK-123

# Create feature branch
git checkout -b TASK-123

# Switch to BUILD mode
MODE: BUILD
SCOPE: LARGE

# Start implementation...
```

### 2. Session Handover
```bash
# Check session health
<Health-Check>
# Output: 🟡 Approaching Limit (42/50 messages)

# Generate handover document
<Handover01>
# Creates comprehensive documentation for next session
```

### 3. Customizing for Your Team
```bash
# Run interactive customization
./scripts/customize-framework.sh

# Select your:
# - Team size (startup/small/medium/large/enterprise)
# - Project type (web app/API/mobile/desktop/embedded)
# - Primary language
# - Industry requirements
# - Coding standards
```

## 🔧 Configuration

### Team Configuration (`team-config.yaml`)
```yaml
team:
  size: medium
  project_type: web_application
  
development:
  primary_language: python
  frameworks:
    - fastapi
    - vuejs
  
standards:
  indentation: spaces
  indent_size: 4
  line_length: 100
  naming_convention: snake_case
```

### Session Configuration
The framework automatically manages session state in `.claude/session/current-session.yaml`:
```yaml
health: healthy
message_count: 15
mode: BUILD
scope: LARGE
current_task:
  jira_id: TASK-123
  phase: implementation
  progress: 60
```

## 🎯 Modes and Scopes

### Response Modes
- **DEBUG** 🐛: Detailed troubleshooting with extensive logging
- **BUILD** 🏗️: Implementation mode with focus on code generation
- **REVIEW** 👀: Code review mode with quality focus
- **LEARN** 📚: Educational mode with detailed explanations
- **RAPID** ⚡: Quick response mode for simple queries

### Work Scopes
- **MICRO**: 1-5 lines of code
- **SMALL**: 5-20 lines of code
- **MEDIUM**: 20-50 lines of code
- **LARGE**: 50+ lines or multiple files
- **EPIC**: Major features or system-wide changes

## 🛡️ Security Features

- **OWASP Compliance**: Built-in security checklist
- **Authentication**: JWT-based auth system included
- **Environment Variables**: Secure configuration management
- **Input Validation**: Automatic sanitization
- **Rate Limiting**: API protection included

## 📚 Documentation

### Generated Documentation
- **README.md**: Project overview
- **API Documentation**: OpenAPI/Swagger specs
- **Development Guide**: Setup and contribution guidelines
- **Deployment Guide**: Production deployment instructions

### Framework Documentation
- **[PROJECT_INDEX.md](PROJECT_INDEX.md)**: Complete documentation index
- **[Customization Guide](.claude/guides/customization-guide.md)**: Team customization
- **[Session Management Guide](.claude/guides/session-management-guide.md)**: Session handling

## 🔄 Workflow Integration

### JIRA Integration
```bash
# Fetch task details
jira TASK-123

# Create implementation plan
Create implementation plan for TASK-123

# Update task status
Update TASK-123 status to In Progress
```

### Git Workflow
```bash
# Create feature branch
git checkout -b TASK-123

# Make changes...

# Commit with task ID
git commit -m "TASK-123: Add user authentication"

# Create PR
Create pull request for TASK-123
```

## 🧪 Testing

The framework supports comprehensive testing:

### Test-Driven Development
1. Write tests first based on requirements
2. Run tests to confirm they fail
3. Implement code to pass tests
4. Refactor while keeping tests green

### Testing Tools
- **Unit Tests**: Jest (Frontend), Pytest (Backend)
- **Integration Tests**: API testing included
- **E2E Tests**: Playwright support
- **Coverage**: Minimum 80% enforced

## 🚀 Deployment

### Development
```bash
# Using Docker Compose
docker-compose up

# Manual setup
cd frontend && npm install && npm run dev
cd backend && pip install -r requirements.txt && uvicorn app.main:app --reload
```

### Production
```bash
# Build containers
docker-compose -f docker-compose.prod.yml build

# Deploy
docker-compose -f docker-compose.prod.yml up -d
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Follow the coding standards in `.claude/best_practices/`
4. Write tests for your changes
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to the branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Built by the [Jezweb](https://github.com/jezweb) team
- Powered by [Claude](https://www.anthropic.com/claude) from Anthropic
- Inspired by modern full-stack development practices

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/jezweb/claude-code-framework/issues)
- **Documentation**: [Wiki](https://github.com/jezweb/claude-code-framework/wiki)
- **Community**: [Discussions](https://github.com/jezweb/claude-code-framework/discussions)

---

**Happy coding with AI assistance! 🚀🤖**

*Last updated: December 2024 | Version: 1.1.0*