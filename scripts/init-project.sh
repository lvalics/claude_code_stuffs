#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# --- Parse Arguments ---
FRAMEWORK_ONLY=false
QUICK_SETUP=false

for arg in "$@"; do
    case $arg in
        --framework-only)
            FRAMEWORK_ONLY=true
            ;;
        --quick)
            QUICK_SETUP=true
            ;;
    esac
done

# Check environment variables as fallback
[ "$FRAMEWORK_ONLY" = "1" ] && FRAMEWORK_ONLY=true
[ "$QUICK_SETUP" = "1" ] && QUICK_SETUP=true

# --- Color Codes ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

if [ "$FRAMEWORK_ONLY" = true ]; then
    echo -e "${BLUE}🔧 Adding Claude Code Framework to existing project...${NC}"
else
    echo -e "${BLUE}🚀 Starting Jezweb AI App Initialization...${NC}"
fi

# --- Clone the Boilerplate (skip if framework-only) ---
if [ "$FRAMEWORK_ONLY" = false ]; then
    BOILERPLATE_REPO="https://github.com/jezweb/ai-app-boilerplate.git"
    echo -e "${YELLOW}Cloning the AI App Boilerplate from ${BOILERPLATE_REPO}...${NC}"
    # Clone into a temporary directory first
    git clone --depth 1 "$BOILERPLATE_REPO" temp_boilerplate
    # Move contents to the current directory
    mv temp_boilerplate/* .
    [ -d temp_boilerplate/.github ] && mv temp_boilerplate/.github .
    [ -f temp_boilerplate/.gitignore ] && mv temp_boilerplate/.gitignore .
    rm -rf temp_boilerplate
fi

# --- Clone the Framework ---
FRAMEWORK_REPO="https://github.com/jezweb/claude-code-framework.git"
echo -e "${YELLOW}Cloning the Claude Code Framework for setup...${NC}"
git clone --depth 1 "$FRAMEWORK_REPO" temp_framework
# Copy the .claude directory and scripts into our new project
mv temp_framework/.claude .
mv temp_framework/scripts .
rm -rf temp_framework

echo -e "${GREEN}✔ Project files and framework are in place.${NC}"

# --- Run Customization and Setup ---
echo -e "${YELLOW}Running framework customization...${NC}"

# Build customization command with flags
CUSTOMIZE_ARGS=""
[ "$QUICK_SETUP" = true ] && CUSTOMIZE_ARGS="$CUSTOMIZE_ARGS --quick"

# Check if Node.js version exists and use it preferentially
if [ -f "./scripts/customize-framework.js" ]; then
    chmod +x ./scripts/customize-framework.js
    # Install dependencies if package.json exists
    if [ -f "./package.json" ]; then
        echo -e "${YELLOW}Installing dependencies...${NC}"
        npm install --silent
    fi
    node ./scripts/customize-framework.js $CUSTOMIZE_ARGS
elif [ -f "./scripts/customize-framework.sh" ]; then
    chmod +x ./scripts/customize-framework.sh
    ./scripts/customize-framework.sh
else
    echo -e "${RED}Error: No customization script found!${NC}"
    exit 1
fi

echo -e "${YELLOW}Running development environment setup...${NC}"
chmod +x ./scripts/setup-dev-env.sh
./scripts/setup-dev-env.sh

# --- Finalize Git Repository (skip if framework-only) ---
if [ "$FRAMEWORK_ONLY" = false ]; then
    echo -e "${YELLOW}Initializing new Git repository...${NC}"
    rm -rf .git # Remove the boilerplate's git history
    git init
    git add .
    git commit -m "Initial commit: Scaffolded new Jezweb AI App"
    
    echo -e "\n${GREEN}🎉 Success! Your new Jezweb AI application is ready.${NC}"
    
    # Copy .env files from examples
    if [ -f "backend/.env.example" ] && [ ! -f "backend/.env" ]; then
        cp backend/.env.example backend/.env
        echo -e "${GREEN}✓ Created backend/.env from backend/.env.example${NC}"
    fi
    
    echo -e "\nNext steps:"
    echo -e "1. Navigate to your project directory: ${BLUE}cd $(basename $(pwd))${NC}"
    echo -e "2. Review and update the .env files if needed"
    echo -e "3. Start the application: ${BLUE}docker-compose up --build${NC}"
else
    echo -e "\n${GREEN}🎉 Success! Claude Code Framework has been added to your project.${NC}"
    echo -e "\nThe following have been added:"
    echo -e "• ${BLUE}.claude/${NC} - Best practices and guides"
    echo -e "• ${BLUE}scripts/${NC} - Development and automation scripts"
    echo -e "\nNext steps:"
    echo -e "1. Review your customizations in ${BLUE}.claude/config/${NC}"
    echo -e "2. Check the best practices for your technologies in ${BLUE}.claude/best_practices/${NC}"
    echo -e "3. Run ${BLUE}./scripts/validate-best-practices.sh${NC} to check your code"
fi
