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
    if [ "$(uname)" = "Linux" ]; then
        OS="linux"
    elif [ "$(uname)" = "Darwin" ]; then
        OS="macos"
    elif uname | grep -iq 'mingw\|cygwin\|msys'; then
        OS="windows"
    else
        OS="unknown"
    fi
    echo $OS
}

OS=$(detect_os)
print_status "Detected OS: $OS"

# Check for existing team configuration
detect_technologies() {
    local technologies=()
    
    # Check team-config.yaml for technology stack
    if [ -f ".claude/config/team-config.yaml" ]; then
        print_status "Found team configuration, detecting technologies..."
        # Extract technologies from YAML (basic grep approach)
        while IFS= read -r line; do
            if echo "$line" | grep -q "^  - "; then
                tech=$(echo "$line" | sed 's/^  - //' | tr -d '"' | tr '[:upper:]' '[:lower:]')
                technologies+=("$tech")
            fi
        done < <(sed -n '/^technologies:/,/^[a-zA-Z]/p' ".claude/config/team-config.yaml" | head -n -1)
    fi
    
    # Check customization summary for more details
    if [ -f ".claude/config/customization-summary.md" ]; then
        print_status "Found customization summary, extracting additional technology info..."
        # Extract technologies from markdown
        if grep -q "Technologies:" ".claude/config/customization-summary.md"; then
            while IFS= read -r line; do
                if echo "$line" | grep -q "^- "; then
                    tech=$(echo "$line" | sed 's/^- //' | tr '[:upper:]' '[:lower:]')
                    if [[ ! " ${technologies[@]} " =~ " ${tech} " ]]; then
                        technologies+=("$tech")
                    fi
                fi
            done < <(sed -n '/^## Technologies:/,/^## /p' ".claude/config/customization-summary.md" | grep "^- " || true)
        fi
    fi
    
    # Check package.json for Node.js/JavaScript
    if [ -f "package.json" ]; then
        if [[ ! " ${technologies[@]} " =~ " node.js " ]] && [[ ! " ${technologies[@]} " =~ " javascript " ]]; then
            technologies+=("node.js")
        fi
    fi
    
    # Check requirements.txt or setup.py for Python
    if [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
        if [[ ! " ${technologies[@]} " =~ " python " ]]; then
            technologies+=("python")
        fi
    fi
    
    # Check composer.json for PHP
    if [ -f "composer.json" ]; then
        if [[ ! " ${technologies[@]} " =~ " php " ]]; then
            technologies+=("php")
        fi
    fi
    
    # Check pom.xml or build.gradle for Java
    if [ -f "pom.xml" ] || [ -f "build.gradle" ] || [ -f "build.gradle.kts" ]; then
        if [[ ! " ${technologies[@]} " =~ " java " ]]; then
            technologies+=("java")
        fi
    fi
    
    # Check Dockerfile for Docker
    if [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ]; then
        if [[ ! " ${technologies[@]} " =~ " docker " ]]; then
            technologies+=("docker")
        fi
    fi
    
    # Check angular.json for Angular
    if [ -f "angular.json" ]; then
        if [[ ! " ${technologies[@]} " =~ " angular " ]]; then
            technologies+=("angular")
        fi
    fi
    
    echo "${technologies[@]}"
}

# Detect configured technologies
DETECTED_TECHNOLOGIES=($(detect_technologies))

if [ ${#DETECTED_TECHNOLOGIES[@]} -gt 0 ]; then
    print_status "Detected technologies: ${DETECTED_TECHNOLOGIES[*]}"
    print_status "Setting up environment for detected technologies only..."
else
    print_warning "No team configuration found. To customize your setup:"
    print_status "Run: ./scripts/customize-framework.sh"
    print_status "Setting up all supported technologies..."
fi

# Helper function to check if a technology should be installed
should_install_tech() {
    local tech="$1"
    # If no technologies detected, install everything
    if [ ${#DETECTED_TECHNOLOGIES[@]} -eq 0 ]; then
        return 0
    fi
    
    # Check if technology is in detected list
    for detected_tech in "${DETECTED_TECHNOLOGIES[@]}"; do
        if [[ "$detected_tech" == *"$tech"* ]] || [[ "$tech" == *"$detected_tech"* ]]; then
            return 0
        fi
    done
    return 1
}

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
if should_install_tech "node"; then
    if ! command_exists node; then
        print_warning "Node.js is not installed."
        printf "Do you want to install Node.js? (y/n) "
        read REPLY
        if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
            if [ "$OS" = "macos" ]; then
                brew install node
            elif [ "$OS" = "linux" ]; then
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
else
    print_status "Skipping Node.js installation (not in detected technologies)"
fi

# Check Python
if should_install_tech "python"; then
    if ! command_exists python3; then
        print_warning "Python 3 is not installed."
        printf "Do you want to install Python 3? (y/n) "
        read REPLY
        if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
            if [ "$OS" = "macos" ]; then
                brew install python3
            elif [ "$OS" = "linux" ]; then
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
else
    print_status "Skipping Python installation (not in detected technologies)"
fi

# Check PHP
if should_install_tech "php"; then
    if ! command_exists php; then
        print_warning "PHP is not installed."
        printf "Do you want to install PHP? (y/n) "
        read REPLY
        if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
            if [ "$OS" = "macos" ]; then
                brew install php
            elif [ "$OS" = "linux" ]; then
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

    # Check Composer (only if PHP is being installed)
    if ! command_exists composer; then
        print_warning "Composer is not installed."
        printf "Do you want to install Composer? (y/n) "
        read REPLY
        if [ "$REPLY" = "y" ] || [ "$REPLY" = "Y" ]; then
            php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
            php composer-setup.php
            php -r "unlink('composer-setup.php');"
            sudo mv composer.phar /usr/local/bin/composer
        fi
    else
        print_status "Composer is installed: $(composer --version | head -n 1)"
    fi
else
    print_status "Skipping PHP installation (not in detected technologies)"
fi

# Check Java
if should_install_tech "java"; then
    if ! command_exists java; then
        print_warning "Java is not installed."
        print_status "Please install Java 17 or later manually from https://adoptium.net/ if needed for your project"
    else
        print_status "Java is installed: $(java -version 2>&1 | head -n 1)"
    fi
else
    print_status "Skipping Java check (not in detected technologies)"
fi

# Check Docker
if should_install_tech "docker"; then
    if ! command_exists docker; then
        print_warning "Docker is not installed."
        print_status "Please install Docker manually from https://docker.com"
    else
        print_status "Docker is installed: $(docker --version)"
    fi
else
    print_status "Skipping Docker check (not in detected technologies)"
fi

# Install global npm packages (only if Node.js technologies are detected)
if should_install_tech "node" || should_install_tech "angular" || should_install_tech "javascript" || should_install_tech "typescript"; then
    if command_exists npm; then
        print_status "Installing global npm packages..."

        # Function to install npm package if not already installed
        install_npm_package() {
            package="$1"
            if npm list -g "$package" >/dev/null 2>&1; then
                print_status "$package is already installed globally"
            else
                print_status "Installing $package..."
                npm install -g "$package"
            fi
        }

        # Install packages based on detected technologies
        if should_install_tech "angular"; then
            install_npm_package "@angular/cli"
        fi
        
        if should_install_tech "node" || should_install_tech "javascript" || should_install_tech "typescript"; then
            install_npm_package "typescript"
            install_npm_package "nodemon"
            install_npm_package "eslint"
            install_npm_package "prettier"
        fi
    else
        print_warning "npm not available, skipping global package installation"
    fi
else
    print_status "Skipping npm global packages (no Node.js technologies detected)"
fi

# Create project structure
print_status "Setting up project structure..."

# Create necessary directories if they don't exist
create_directory() {
    dir="$1"
    if [ ! -d "$dir" ]; then
        mkdir -p "$dir"
        print_status "Created directory: $dir"
    fi
}

# Create directories one by one
create_directory "claude_code_changes"
create_directory "tasks"
create_directory "tasks/specs"
create_directory "tests"
create_directory "docs"
create_directory "scripts"
create_directory ".claude/commands"
create_directory ".claude/templates"
create_directory ".claude/session"

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
    # Generate technology list based on detected technologies
    TECH_LIST=""
    if [ ${#DETECTED_TECHNOLOGIES[@]} -gt 0 ]; then
        for tech in "${DETECTED_TECHNOLOGIES[@]}"; do
            # Capitalize first letter
            formatted_tech=$(echo "$tech" | sed 's/^./\U&/' | sed 's/\bnode.js\b/Node.js/I' | sed 's/\bphp\b/PHP/I')
            TECH_LIST="${TECH_LIST}- ${formatted_tech}\n"
        done
    else
        # Default to all technologies if none detected
        TECH_LIST="- Node.js\n- Python\n- PHP\n- Java\n- Docker\n- Angular\n- ApostropheCMS\n"
    fi

    cat > README.md << EOF
# Project Name

## Overview
Brief description of your project.

## Technologies Used
$(echo -e "$TECH_LIST")
## Getting Started

### Prerequisites
Run the setup script to install all prerequisites:
\`\`\`bash
./scripts/setup-dev-env.sh
\`\`\`

### Installation
1. Clone the repository
2. Copy \`.env.example\` to \`.env\` and configure
3. Install dependencies based on your technology stack

### Development
Refer to the technology-specific best practices in \`.claude/best_practices/\`

## Documentation
See the \`docs/\` directory for detailed documentation.

## Contributing
Please read the contributing guidelines before submitting PRs.

## License
[License Type]
EOF
    print_status "Created README.md file with detected technologies"
fi

# Set up Git hooks
print_status "Setting up Git hooks..."
if [ -d .git ]; then
    # Pre-commit hook - generate based on detected technologies
    cat > .git/hooks/pre-commit << 'EOF'
#!/bin/bash
# Pre-commit hook for code quality

# Run linters based on changed files
files=$(git diff --cached --name-only --diff-filter=ACM)
EOF

    # Add technology-specific linting rules
    if should_install_tech "node" || should_install_tech "javascript" || should_install_tech "typescript" || should_install_tech "angular"; then
        cat >> .git/hooks/pre-commit << 'EOF'

# JavaScript/TypeScript files
js_files=$(echo "$files" | grep -E '\.(js|ts|jsx|tsx)$' || true)
if [ -n "$js_files" ]; then
    echo "Running ESLint..."
    if command -v npx >/dev/null 2>&1; then
        npx eslint $js_files
    fi
fi
EOF
    fi

    if should_install_tech "python"; then
        cat >> .git/hooks/pre-commit << 'EOF'

# Python files
py_files=$(echo "$files" | grep -E '\.py$' || true)
if [ -n "$py_files" ]; then
    echo "Running Python linters..."
    if command -v flake8 >/dev/null 2>&1; then
        flake8 $py_files
    fi
    if command -v black >/dev/null 2>&1; then
        black --check $py_files
    fi
fi
EOF
    fi

    if should_install_tech "php"; then
        cat >> .git/hooks/pre-commit << 'EOF'

# PHP files
php_files=$(echo "$files" | grep -E '\.php$' || true)
if [ -n "$php_files" ]; then
    echo "Running PHP linters..."
    if command -v phpcs >/dev/null 2>&1; then
        phpcs $php_files
    fi
fi
EOF
    fi

    chmod +x .git/hooks/pre-commit
    print_status "Git hooks configured for detected technologies"
else
    print_warning "Not a Git repository. Skipping Git hooks setup."
fi

# Final setup steps
print_status "Creating VS Code settings..."
mkdir -p .vscode

# Generate VS Code settings based on detected technologies
echo '{' > .vscode/settings.json
echo '  "editor.formatOnSave": true,' >> .vscode/settings.json

# Add JavaScript/TypeScript specific settings
if should_install_tech "node" || should_install_tech "javascript" || should_install_tech "typescript" || should_install_tech "angular"; then
    cat >> .vscode/settings.json << 'EOF'
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "eslint.validate": [
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact"
  ],
EOF
fi

# Add Python specific settings
if should_install_tech "python"; then
    cat >> .vscode/settings.json << 'EOF'
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": true,
  "python.formatting.provider": "black",
EOF
fi

# Add PHP specific settings
if should_install_tech "php"; then
    cat >> .vscode/settings.json << 'EOF'
  "[php]": {
    "editor.defaultFormatter": "bmewburn.vscode-intelephense-client"
  },
EOF
fi

# Add common file exclusions
cat >> .vscode/settings.json << 'EOF'
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
print_status "Technologies configured: ${DETECTED_TECHNOLOGIES[*]:-All supported technologies}"
print_status "Next steps:"
echo "1. Copy .env.example to .env and configure your environment variables"
echo "2. Install project-specific dependencies for your technology stack"
if [ ${#DETECTED_TECHNOLOGIES[@]} -gt 0 ]; then
    echo "3. Refer to .claude/best_practices/ for your specific technologies:"
    for tech in "${DETECTED_TECHNOLOGIES[@]}"; do
        case "$tech" in
            "node.js"|"javascript"|"typescript") echo "   - .claude/best_practices/nodejs-best-practices.md" ;;
            "python") echo "   - .claude/best_practices/python-best-practices.md" ;;
            "php") echo "   - .claude/best_practices/php-best-practices.md" ;;
            "java") echo "   - .claude/best_practices/java-best-practices.md" ;;
            "angular") echo "   - .claude/best_practices/angular-best-practices.md" ;;
            "docker") echo "   - .claude/best_practices/docker-best-practices.md" ;;
        esac
    done
else
    echo "3. Refer to .claude/best_practices/ for technology-specific best practices"
fi
echo "4. Check README.md for project-specific instructions"