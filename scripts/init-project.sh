#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# --- Color Codes ---
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Starting Jezweb AI App Initialization...${NC}"

# --- Clone the Boilerplate ---
BOILERPLATE_REPO="https://github.com/jezweb/ai-app-boilerplate.git"
echo -e "${YELLOW}Cloning the AI App Boilerplate from ${BOILERPLATE_REPO}...${NC}"
# Clone into a temporary directory first
git clone --depth 1 "$BOILERPLATE_REPO" temp_boilerplate
# Move contents to the current directory
mv temp_boilerplate/* .
mv temp_boilerplate/.github .
mv temp_boilerplate/.gitignore .
rm -rf temp_boilerplate

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
chmod +x ./scripts/customize-framework.sh
./scripts/customize-framework.sh

echo -e "${YELLOW}Running development environment setup...${NC}"
chmod +x ./scripts/setup-dev-env.sh
./scripts/setup-dev-env.sh

# --- Finalize Git Repository ---
echo -e "${YELLOW}Initializing new Git repository...${NC}"
rm -rf .git # Remove the boilerplate's git history
git init
git add .
git commit -m "Initial commit: Scaffolded new Jezweb AI App"

echo -e "\n${GREEN}🎉 Success! Your new Jezweb AI application is ready.${NC}"
echo -e "Navigate to your project directory and run 'docker-compose up --build' to start."
