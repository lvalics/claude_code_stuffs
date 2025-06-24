#!/bin/bash

# Configuration Loader
# This script loads team configuration and exports it as environment variables

CONFIG_DIR="$(dirname "$0")"
TEAM_CONFIG="$CONFIG_DIR/team-config.yaml"
WORKFLOW_CONFIG="$CONFIG_DIR/workflow-config.yaml"

# Check if configuration files exist
if [ ! -f "$TEAM_CONFIG" ]; then
    echo "Warning: team-config.yaml not found. Run ./scripts/customize-framework.sh to create it."
    exit 1
fi

# Function to parse YAML and export as env vars
parse_yaml() {
    local prefix=$2
    local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
    sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
    awk -F$fs '{
        indent = length($1)/2;
        vname[indent] = $2;
        for (i in vname) {if (i > indent) {delete vname[i]}}
        if (length($3) > 0) {
            vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
            printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
        }
    }'
}

# Load team configuration
echo "Loading team configuration..."
eval $(parse_yaml "$TEAM_CONFIG" "CLAUDE_")

# Load workflow configuration if it exists
if [ -f "$WORKFLOW_CONFIG" ]; then
    echo "Loading workflow configuration..."
    eval $(parse_yaml "$WORKFLOW_CONFIG" "CLAUDE_WORKFLOW_")
fi

# Export commonly used variables
export CLAUDE_TEAM_NAME="${CLAUDE_team_name}"
export CLAUDE_TEAM_SIZE="${CLAUDE_team_size}"
export CLAUDE_PROJECT_TYPE="${CLAUDE_project_type}"
export CLAUDE_PROJECT_INDUSTRY="${CLAUDE_project_industry}"

# Display loaded configuration
echo "Configuration loaded:"
echo "  Team: $CLAUDE_TEAM_NAME"
echo "  Size: $CLAUDE_TEAM_SIZE"
echo "  Project: $CLAUDE_PROJECT_TYPE"
echo "  Industry: $CLAUDE_PROJECT_INDUSTRY"

# Make configuration available to child processes
export CLAUDE_CONFIG_LOADED=true