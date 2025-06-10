#!/bin/bash

# Development Environment Setup Script
# This script sets up the development environment for all supported technologies

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Functions
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Detect OS
detect_os() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        OS="windows"
    else
        OS="unknown"
    fi
    echo $OS
}

OS=$(detect_os)
print_status "Detected OS: $OS"

# Check and install prerequisites
print_status "Checking prerequisites..."

# Check Git
if ! command_exists git; then
    print_error "Git is not installed. Please install Git first."
    exit 1
else
    print_status "Git is installed: $(git --version)"
fi

# Check Node.js and npm
if ! command_exists node; then
    print_warning "Node.js is not installed."
    read -p "Do you want to install Node.js? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OS" == "macos" ]]; then
            brew install node
        elif [[ "$OS" == "linux" ]]; then
            curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
            sudo apt-get install -y nodejs
        else
            print_error "Please install Node.js manually from https://nodejs.org/"
            exit 1
        fi
    fi
else
    print_status "Node.js is installed: $(node --version)"
    print_status "npm is installed: $(npm --version)"
fi

# Check Python
if ! command_exists python3; then
    print_warning "Python 3 is not installed."
    read -p "Do you want to install Python 3? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OS" == "macos" ]]; then
            brew install python3
        elif [[ "$OS" == "linux" ]]; then
            sudo apt-get update
            sudo apt-get install -y python3 python3-pip python3-venv
        else
            print_error "Please install Python 3 manually from https://python.org/"
            exit 1
        fi
    fi
else
    print_status "Python is installed: $(python3 --version)"
fi

# Check PHP
if ! command_exists php; then
    print_warning "PHP is not installed."
    read -p "Do you want to install PHP? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OS" == "macos" ]]; then
            brew install php
        elif [[ "$OS" == "linux" ]]; then
            sudo apt-get update
            sudo apt-get install -y php php-cli php-mbstring php-xml php-curl php-zip
        else
            print_error "Please install PHP manually"
            exit 1
        fi
    fi
else
    print_status "PHP is installed: $(php --version | head -n 1)"
fi

# Check Composer
if ! command_exists composer; then
    print_warning "Composer is not installed."
    read -p "Do you want to install Composer? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
        php composer-setup.php
        php -r "unlink('composer-setup.php');"
        sudo mv composer.phar /usr/local/bin/composer
    fi
else
    print_status "Composer is installed: $(composer --version | head -n 1)"
fi

# Check Java
if ! command_exists java; then
    print_warning "Java is not installed."
    print_status "Please install Java 17 or later manually if needed for your project"
else
    print_status "Java is installed: $(java -version 2>&1 | head -n 1)"
fi

# Check Docker
if ! command_exists docker; then
    print_warning "Docker is not installed."
    print_status "Please install Docker manually from https://docker.com if needed"
else
    print_status "Docker is installed: $(docker --version)"
fi

# Install global npm packages
print_status "Installing global npm packages..."
npm_packages=(
    "@angular/cli"
    "typescript"
    "nodemon"
    "eslint"
    "prettier"
)

for package in "${npm_packages[@]}"; do
    if npm list -g "$package" >/dev/null 2>&1; then
        print_status "$package is already installed globally"
    else
        print_status "Installing $package..."
        npm install -g "$package"
    fi
done

# Create project structure
print_status "Setting up project structure..."

# Create necessary directories if they don't exist
directories=(
    "claude_code_changes"
    "tasks"
    "tasks/specs"
    "tests"
    "docs"
    "scripts"
    ".claude/commands"
    ".claude/templates"
)

for dir in "${directories[@]}"; do
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_status "Created directory: $dir"
    fi
done

# Create .env.example if it doesn't exist
if [ ! -f .env.example ]; then
    cat > .env.example << 'EOF'
# Application
APP_NAME="My Application"
APP_ENV=local
APP_DEBUG=true
APP_URL=http://localhost

# Database
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=myapp
DB_USERNAME=root
DB_PASSWORD=

# MongoDB (for ApostropheCMS)
MONGODB_URI=mongodb://localhost:27017/myproject

# Session
SESSION_SECRET=your-secret-key-here

# API Keys
API_KEY=
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=

# Mail
MAIL_MAILER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=
MAIL_PASSWORD=
EOF
    print_status "Created .env.example file"
fi

# Create README.md if it doesn't exist
if [ ! -f README.md ]; then
    cat > README.md << 'EOF'
# Project Name

## Overview
Brief description of your project.

## Technologies Used
- Node.js
- Python
- PHP
- Java
- Docker
- Angular
- ApostropheCMS

## Getting Started

### Prerequisites
Run the setup script to install all prerequisites:
```bash
./scripts/setup-dev-env.sh
```

### Installation
1. Clone the repository
2. Copy `.env.example` to `.env` and configure
3. Install dependencies based on your technology stack

### Development
Refer to the technology-specific best practices in `.claude/commands/`

## Documentation
See the `docs/` directory for detailed documentation.

## Contributing
Please read the contributing guidelines before submitting PRs.

## License
[License Type]
EOF
    print_status "Created README.md file"
fi

# Set up Git hooks
print_status "Setting up Git hooks..."
if [ -d .git ]; then
    # Pre-commit hook
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for code quality

# Run linters based on changed files
files=$(git diff --cached --name-only --diff-filter=ACM)

# JavaScript/TypeScript files
js_files=$(echo "$files" | grep -E '\.(js|ts|jsx|tsx)$' || true)
if [ -n "$js_files" ]; then
    echo "Running ESLint..."
    npx eslint $js_files
fi

# Python files
py_files=$(echo "$files" | grep -E '\.py$' || true)
if [ -n "$py_files" ]; then
    echo "Running Python linters..."
    if command -v flake8 >/dev/null 2>&1; then
        flake8 $py_files
    fi
fi

# PHP files
php_files=$(echo "$files" | grep -E '\.php$' || true)
if [ -n "$php_files" ]; then
    echo "Running PHP linters..."
    if command -v phpcs >/dev/null 2>&1; then
        phpcs $php_files
    fi
fi
EOF
    chmod +x .git/hooks/pre-commit
    print_status "Git hooks configured"
else
    print_warning "Not a Git repository. Skipping Git hooks setup."
fi

# Final setup steps
print_status "Creating VS Code settings..."
mkdir -p .vscode
cat > .vscode/settings.json << 'EOF'
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "python.formatting.provider": "black",
  "[php]": {
    "editor.defaultFormatter": "bmewburn.vscode-intelephense-client"
  },
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true,
    "**/node_modules": true,
    "**/__pycache__": true,
    "**/.pytest_cache": true
  }
}
EOF

print_status "Setup complete!"
print_status "Next steps:"
echo "1. Copy .env.example to .env and configure your environment variables"
echo "2. Install project-specific dependencies"
echo "3. Refer to .claude/commands/ for technology-specific best practices"
echo "4. Check README.md for project-specific instructions"