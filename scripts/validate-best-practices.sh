#!/bin/bash

# Best Practices Validation Script
# Validates custom best practices files for structure, formatting, and completeness

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
CLAUDE_DIR=".claude"
BEST_PRACTICES_DIR="$CLAUDE_DIR/best_practices"
CONFIG_DIR="$CLAUDE_DIR/config"
VALIDATION_LOG="$CLAUDE_DIR/validation-report.md"
TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
ERRORS=0
WARNINGS=0

# Ensure we're in the right directory
if [ ! -d "$CLAUDE_DIR" ]; then
    echo -e "${RED}Error: Not in a Claude Code project directory${NC}"
    echo "Please run this script from the root of your project"
    exit 1
fi

echo -e "${BLUE}╔════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║         Best Practices Validation Tool                 ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════╝${NC}"
echo

# Initialize validation report
cat > "$VALIDATION_LOG" << EOF
# Best Practices Validation Report

Generated: $TIMESTAMP

## Summary

EOF

# Function to check file structure
check_file_structure() {
    local file="$1"
    local filename=$(basename "$file")
    
    echo -e "\n${YELLOW}Checking structure of $filename...${NC}"
    
    # Check for required sections
    local required_sections=(
        "## Overview"
        "## Code Style"
        "## Testing"
        "## Security"
    )
    
    for section in "${required_sections[@]}"; do
        if ! grep -q "^$section" "$file"; then
            echo -e "${RED}✗ Missing required section: $section${NC}"
            ((ERRORS++))
            echo "- **ERROR**: Missing section '$section' in $filename" >> "$VALIDATION_LOG"
        else
            echo -e "${GREEN}✓ Found section: $section${NC}"
        fi
    done
}

# Function to check customization markers
check_customization_markers() {
    local file="$1"
    local filename=$(basename "$file")
    
    echo -e "\n${YELLOW}Checking customization markers in $filename...${NC}"
    
    # Check if file has customizations
    if grep -q "\[CUSTOMIZED:" "$file"; then
        echo -e "${BLUE}ℹ File contains customizations${NC}"
        
        # Extract customization details
        local customizations=$(grep -n "\[CUSTOMIZED:" "$file")
        
        while IFS= read -r line; do
            local line_num=$(echo "$line" | cut -d: -f1)
            local content=$(echo "$line" | cut -d: -f2-)
            
            # Check if customization has team name
            if [[ ! "$content" =~ \[CUSTOMIZED:\ .+\] ]]; then
                echo -e "${RED}✗ Invalid customization marker at line $line_num${NC}"
                ((ERRORS++))
                echo "- **ERROR**: Invalid customization marker at line $line_num in $filename" >> "$VALIDATION_LOG"
            else
                # Extract team name
                local team_name=$(echo "$content" | sed -n 's/.*\[CUSTOMIZED: \(.*\)\].*/\1/p')
                echo -e "${GREEN}✓ Valid customization for team: $team_name (line $line_num)${NC}"
            fi
            
            # Check for explanation comment
            local next_line=$((line_num + 1))
            if ! sed -n "${next_line}p" "$file" | grep -q "<!--"; then
                echo -e "${YELLOW}⚠ Warning: No explanation comment after customization at line $line_num${NC}"
                ((WARNINGS++))
                echo "- **WARNING**: No explanation for customization at line $line_num in $filename" >> "$VALIDATION_LOG"
            fi
        done <<< "$customizations"
    fi
}

# Function to check markdown formatting
check_markdown_formatting() {
    local file="$1"
    local filename=$(basename "$file")
    
    echo -e "\n${YELLOW}Checking markdown formatting in $filename...${NC}"
    
    # Check for proper heading hierarchy
    local prev_level=0
    local line_num=0
    
    while IFS= read -r line; do
        ((line_num++))
        if [[ "$line" =~ ^#+ ]]; then
            local level=$(echo "$line" | grep -o '^#*' | wc -c)
            ((level--))  # Adjust for wc counting
            
            if [[ $level -gt $((prev_level + 1)) ]] && [[ $prev_level -ne 0 ]]; then
                echo -e "${YELLOW}⚠ Warning: Heading hierarchy skip at line $line_num${NC}"
                ((WARNINGS++))
                echo "- **WARNING**: Heading hierarchy issue at line $line_num in $filename" >> "$VALIDATION_LOG"
            fi
            
            prev_level=$level
        fi
    done < "$file"
    
    # Check for code blocks
    if grep -q '```' "$file"; then
        local open_blocks=$(grep -c '^```' "$file")
        if ((open_blocks % 2 != 0)); then
            echo -e "${RED}✗ Unclosed code block detected${NC}"
            ((ERRORS++))
            echo "- **ERROR**: Unclosed code block in $filename" >> "$VALIDATION_LOG"
        else
            echo -e "${GREEN}✓ Code blocks properly closed${NC}"
        fi
    fi
    
    # Check line length (warn if > 120 chars)
    local long_lines=$(awk 'length > 120 {print NR}' "$file" | head -5)
    if [ -n "$long_lines" ]; then
        echo -e "${YELLOW}⚠ Warning: Long lines detected (>120 chars) at lines: $(echo $long_lines | tr '\n' ', ')${NC}"
        ((WARNINGS++))
        echo "- **WARNING**: Long lines in $filename at: $(echo $long_lines | tr '\n' ', ')" >> "$VALIDATION_LOG"
    fi
}

# Function to check consistency with config
check_config_consistency() {
    local file="$1"
    local filename=$(basename "$file")
    
    if [ -f "$CONFIG_DIR/team-config.yaml" ]; then
        echo -e "\n${YELLOW}Checking consistency with team config...${NC}"
        
        # Extract team name from config
        local config_team=$(grep "name:" "$CONFIG_DIR/team-config.yaml" | head -1 | sed 's/.*name:[ ]*"\(.*\)"/\1/')
        
        # Check if customizations match team name
        if grep -q "\[CUSTOMIZED:" "$file"; then
            if ! grep -q "\[CUSTOMIZED: $config_team\]" "$file"; then
                echo -e "${YELLOW}⚠ Warning: Customization team name doesn't match config${NC}"
                ((WARNINGS++))
                echo "- **WARNING**: Team name mismatch in $filename customizations" >> "$VALIDATION_LOG"
            fi
        fi
    fi
}

# Function to validate YAML files
validate_yaml() {
    local file="$1"
    local filename=$(basename "$file")
    
    echo -e "\n${YELLOW}Validating YAML file: $filename...${NC}"
    
    # Basic YAML validation (check for common issues)
    # Check for tabs (YAML doesn't allow tabs)
    if grep -q $'\t' "$file"; then
        echo -e "${RED}✗ YAML file contains tabs (use spaces)${NC}"
        ((ERRORS++))
        echo "- **ERROR**: Tabs found in YAML file $filename" >> "$VALIDATION_LOG"
    fi
    
    # Check for consistent indentation
    local indent_issues=$(awk '/^[[:space:]]+[^[:space:]]/ {
        match($0, /^[[:space:]]*/);
        indent = RLENGTH;
        if (indent % 2 != 0) print NR;
    }' "$file" | head -5)
    
    if [ -n "$indent_issues" ]; then
        echo -e "${YELLOW}⚠ Warning: Inconsistent indentation at lines: $(echo $indent_issues | tr '\n' ', ')${NC}"
        ((WARNINGS++))
        echo "- **WARNING**: Indentation issues in $filename at: $(echo $indent_issues | tr '\n' ', ')" >> "$VALIDATION_LOG"
    fi
    
    # Check for duplicate keys at the same level
    # This is a simplified check and may not catch all cases
    local duplicate_keys=$(awk -F: '/^[[:space:]]*[^#].*:/ {
        gsub(/^[[:space:]]+/, "", $1);
        count[$1]++;
        if (count[$1] > 1) print $1;
    }' "$file" | sort -u)
    
    if [ -n "$duplicate_keys" ]; then
        echo -e "${RED}✗ Possible duplicate keys detected: $duplicate_keys${NC}"
        ((ERRORS++))
        echo "- **ERROR**: Possible duplicate keys in $filename: $duplicate_keys" >> "$VALIDATION_LOG"
    else
        echo -e "${GREEN}✓ No obvious YAML syntax errors${NC}"
    fi
}

# Main validation loop
echo -e "${BLUE}Validating best practices files...${NC}"

# Validate markdown files
for file in "$BEST_PRACTICES_DIR"/*.md; do
    if [ -f "$file" ]; then
        echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
        echo -e "${BLUE}Validating: $(basename "$file")${NC}"
        echo -e "${BLUE}═══════════════════════════════════════${NC}"
        
        check_file_structure "$file"
        check_customization_markers "$file"
        check_markdown_formatting "$file"
        check_config_consistency "$file"
    fi
done

# Validate configuration files
echo -e "\n${BLUE}Validating configuration files...${NC}"

for file in "$CONFIG_DIR"/*.yaml "$CONFIG_DIR"/*.yml; do
    if [ -f "$file" ] && [[ ! "$file" =~ examples/ ]]; then
        echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
        echo -e "${BLUE}Validating: $(basename "$file")${NC}"
        echo -e "${BLUE}═══════════════════════════════════════${NC}"
        
        validate_yaml "$file"
    fi
done

# Final report
echo -e "\n${BLUE}═══════════════════════════════════════${NC}"
echo -e "${BLUE}Validation Summary${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"

# Update validation report
cat >> "$VALIDATION_LOG" << EOF

## Results

- **Total Errors**: $ERRORS
- **Total Warnings**: $WARNINGS
- **Status**: $([ $ERRORS -eq 0 ] && echo "✅ PASSED" || echo "❌ FAILED")

## Recommendations

EOF

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}✅ All validations passed!${NC}"
    echo "All best practices files are properly formatted and structured." >> "$VALIDATION_LOG"
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠ Validation passed with $WARNINGS warning(s)${NC}"
    echo "Review the warnings above to improve documentation quality." >> "$VALIDATION_LOG"
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
    echo "Fix the errors listed above before proceeding." >> "$VALIDATION_LOG"
fi

echo -e "\nDetailed report saved to: ${BLUE}$VALIDATION_LOG${NC}"

# Exit with error code if there were errors
[ $ERRORS -eq 0 ] || exit 1