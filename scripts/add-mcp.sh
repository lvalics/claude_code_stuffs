#!/bin/bash

# Setup Claude MCP servers interactively
echo "Claude MCP Server Installer"
echo "Current directory: $(pwd)"
echo ""

# Store the script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Change to parent directory (project root)
cd "$SCRIPT_DIR/.." || {
    echo "Error: Could not change to parent directory"
    exit 1
}

echo "Changed to project root: $(pwd)"
echo ""

# Function to install context7
install_context7() {
    echo "Installing context7 MCP server..."
    claude mcp add context7 -- npx -y @upstash/context7-mcp
}

# Function to install puppeteer
install_puppeteer() {
    echo "Installing puppeteer MCP server..."
    claude mcp add puppeteer -- npx -y @modelcontextprotocol/server-puppeteer
}

# Function to install supabase
install_supabase() {
    echo -n "Enter your Supabase access token: "
    read -s access_token
    echo ""
    echo "Installing supabase MCP server..."
    claude mcp add supabase -- npx -y @supabase/mcp-server-supabase@latest --access-token "$access_token"
}

# Function to install digitalocean
install_digitalocean() {
    echo -n "Enter your DigitalOcean API token: "
    read -s api_token
    echo ""
    echo "Installing digitalocean MCP server..."
    claude mcp add digitalocean -- env DIGITALOCEAN_API_TOKEN="$api_token" npx @digitalocean/mcp
}

# Function to install shopify
install_shopify() {
    echo "Installing shopify-dev MCP server..."
    claude mcp add shopify-dev-mcp -- npx -y @shopify/dev-mcp@latest
}

# Function to install upstash
install_upstash() {
    echo -n "Enter your Upstash email: "
    read email
    echo -n "Enter your Upstash token: "
    read -s token
    echo ""
    echo "Installing upstash MCP server..."
    claude mcp add upstash -- npx -y @upstash/mcp-server run "$email" "$token"
}

# Function to install atlassian
install_atlassian() {
    echo "Installing mcp-atlassian server..."
    claude mcp add mcp-atlassian -- npx mcp-remote https://mcp.atlassian.com/v1/sse
}

# Function to install playwright
install_playwright() {
    echo "Installing playwright MCP server..."
    claude mcp add playwright -- npx @playwright/mcp@latest
}

# Function to install github
install_github() {
    echo -n "Enter your GitHub personal access token: "
    read -s github_token
    echo ""
    echo "Installing github MCP server..."
    claude mcp add github -- docker run -i --rm -e GITHUB_PERSONAL_ACCESS_TOKEN="$github_token" mcp/github
}

# Function to install cloudflare-observability
install_cloudflare_observability() {
    echo "Installing cloudflare-observability MCP server..."
    claude mcp add cloudflare-observability -- npx mcp-remote https://observability.mcp.cloudflare.com/sse
}

# Function to install cloudflare-bindings
install_cloudflare_bindings() {
    echo "Installing cloudflare-bindings MCP server..."
    claude mcp add cloudflare-bindings -- npx mcp-remote https://bindings.mcp.cloudflare.com/sse
}

# Function to install snap-happy
install_snap_happy() {
    echo "Installing snap-happy screenshot tool..."
    claude mcp add snap-happy npx @mariozechner/snap-happy
    echo "snap-happy installed globally!"
}

# Function to install magic
install_magic() {
    echo "Installing magic MCP server..."
    claude mcp add magic npx @21st-dev/magic@latest
    echo "magic installed successfully!"
}

# Function to install sequential-thinking
install_sequential_thinking() {
    echo "Installing sequential-thinking MCP server..."
    claude mcp add sequential-thinking npx @modelcontextprotocol/server-sequential-thinking
    echo "sequential-thinking installed successfully!"
}

# Interactive menu
echo "Select MCP servers to install (separate multiple with spaces):"
echo "1) context7"
echo "2) puppeteer"
echo "3) supabase (requires access token)"
echo "4) digitalocean (requires API token)"
echo "5) shopify-dev"
echo "6) upstash (requires email and token)"
echo "7) atlassian"
echo "8) playwright"
echo "9) github (requires personal access token)"
echo "10) cloudflare-observability"
echo "11) cloudflare-bindings"
echo "12) snap-happy (screenshot tool)"
echo "13) magic"
echo "14) sequential-thinking"
echo ""
echo -n "Enter your choices (e.g., 1 2 3): "
read choices

echo ""

# Process selections
for choice in $choices; do
    case $choice in
        1)
            install_context7
            ;;
        2)
            install_puppeteer
            ;;
        3)
            install_supabase
            ;;
        4)
            install_digitalocean
            ;;
        5)
            install_shopify
            ;;
        6)
            install_upstash
            ;;
        7)
            install_atlassian
            ;;
        8)
            install_playwright
            ;;
        9)
            install_github
            ;;
        10)
            install_cloudflare_observability
            ;;
        11)
            install_cloudflare_bindings
            ;;
        12)
            install_snap_happy
            ;;
        13)
            install_magic
            ;;
        14)
            install_sequential_thinking
            ;;
        *)
            echo "Invalid choice: $choice"
            ;;
    esac
done

echo ""
echo "MCP server installation complete!"

# Return to the script directory
cd "$SCRIPT_DIR" || {
    echo "Warning: Could not return to script directory"
}

echo "Returned to script directory: $(pwd)"