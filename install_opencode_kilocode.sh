#!/bin/bash

# Kilocode Plugin Installer for macOS
# Automatický instalační skript pro OpenCode Kilocode plugin

set -e  # Exit on any error

# Check for help parameter
if [[ "$1" == "help" ]] || [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    echo "🚀 Kilocode Plugin Installer"
    echo "============================"
    echo "Usage: $0 [force]"
    echo ""
    echo "Options:"
    echo "  force     Force re-download all plugin files (overwrites existing)"
    echo "  help      Show this help message"
    echo ""
    echo "Description:"
    echo "  Downloads and installs the Kilocode plugin for OpenCode from GitHub."
    echo "  Automatically configures opencode.json to include the plugin."
    echo ""
    echo "GitHub Repository: https://github.com/nykadamec/opencode_kilocode"
    echo ""
    exit 0
fi

echo "🚀 Kilocode Plugin Installer"
echo "============================"
echo "GitHub Repository: https://github.com/nykadamec/opencode_kilocode"
echo ""

# Define paths
OPENCODE_DIR="$HOME/.config/opencode"
PLUGIN_DIR="$OPENCODE_DIR/plugin/kilocode"
CONFIG_FILE="$OPENCODE_DIR/opencode.json"
PLUGIN_ENTRY="./plugin/kilocode/plugin_kilocode.ts"

# GitHub URLs for plugin files
GITHUB_BASE_URL="https://raw.githubusercontent.com/nykadamec/opencode_kilocode/refs/heads/main"
PLUGIN_FILE_URL="$GITHUB_BASE_URL/plugin_kilocode.ts"
MODELS_FILE_URL="$GITHUB_BASE_URL/models_kilocode.ts"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to check if OpenCode is installed
check_opencode_installation() {
    print_status "Checking OpenCode installation..."
    
    # Check if opencode command is available
    if command -v opencode &> /dev/null; then
        local version=$(opencode --version 2>/dev/null || echo "unknown")
        print_success "OpenCode found: $version"
        return 0
    fi
    
    # Check common installation paths on macOS
    local opencode_paths=(
        "/Applications/OpenCode.app/Contents/MacOS/opencode"
        "/usr/local/bin/opencode"
        "$HOME/.local/bin/opencode"
        "/opt/homebrew/bin/opencode"
    )
    
    for path in "${opencode_paths[@]}"; do
        if [[ -x "$path" ]]; then
            print_success "OpenCode found at: $path"
            return 0
        fi
    done
    
    # Check if OpenCode.app exists in Applications
    if [[ -d "/Applications/OpenCode.app" ]]; then
        print_success "OpenCode.app found in Applications"
        return 0
    fi
    
    # Check if we can find opencode via npm global packages
    if command -v npm &> /dev/null; then
        local npm_global=$(npm list -g --depth=0 2>/dev/null | grep opencode || echo "")
        if [[ -n "$npm_global" ]]; then
            print_success "OpenCode found via npm: $npm_global"
            return 0
        fi
    fi
    
    # OpenCode not found
    print_error "OpenCode is not installed!"
    print_status "Please install OpenCode first:"
    echo "  • Download from: https://opencode.ai"
    echo "  • Or install via npm: npm install -g @opencode-ai/cli"
    echo "  • Or install via Homebrew (if available)"
    echo ""
    read -p "Do you want to continue anyway? (y/N): " -n 1 -r
    echo ""
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_status "Installation cancelled."
        exit 1
    fi
    
    print_warning "Continuing without OpenCode verification..."
}

# Check if we're in the right directory
if [[ ! -d "$OPENCODE_DIR" ]]; then
    print_error "OpenCode directory not found at $OPENCODE_DIR"
    print_status "Creating OpenCode directory..."
    mkdir -p "$OPENCODE_DIR"
fi

cd "$OPENCODE_DIR"

# Check system requirements
check_system_requirements() {
    print_status "Checking system requirements..."
    
    # Check Node.js
    if command -v node &> /dev/null; then
        local node_version=$(node --version 2>/dev/null || echo "unknown")
        print_success "Node.js found: $node_version"
    else
        print_error "Node.js is not installed!"
        print_status "OpenCode requires Node.js. Please install it first:"
        echo "  • Download from: https://nodejs.org"
        echo "  • Or install via Homebrew: brew install node"
        exit 1
    fi
    
    # Check npm
    if command -v npm &> /dev/null; then
        local npm_version=$(npm --version 2>/dev/null || echo "unknown")
        print_success "npm found: $npm_version"
    else
        print_warning "npm not found (usually comes with Node.js)"
    fi
}

# Check system requirements first
check_system_requirements

# Check if OpenCode is installed
check_opencode_installation

# Create plugin directory if it doesn't exist
print_status "Creating plugin directory structure..."
mkdir -p "$PLUGIN_DIR"

# Download plugin files from GitHub
download_plugin_files() {
    local force_download="$1"
    
    # Check if files already exist and we're not forcing download
    if [[ "$force_download" != "force" ]] && [[ -f "$PLUGIN_DIR/plugin_kilocode.ts" ]] && [[ -f "$PLUGIN_DIR/models_kilocode.ts" ]]; then
        print_warning "Plugin files already exist. Use './install_kilocode.sh force' to re-download."
        return 0
    fi
    
    print_status "Downloading plugin files from GitHub..."
    
    # Check if curl is available
    if ! command -v curl &> /dev/null; then
        print_error "curl is not installed. Please install curl first."
        exit 1
    fi
    
    # Download plugin_kilocode.ts
    print_status "Downloading plugin_kilocode.ts..."
    if curl -fsSL "$PLUGIN_FILE_URL" -o "$PLUGIN_DIR/plugin_kilocode.ts"; then
        print_success "Downloaded plugin_kilocode.ts"
    else
        print_error "Failed to download plugin_kilocode.ts"
        print_error "URL: $PLUGIN_FILE_URL"
        exit 1
    fi
    
    # Download models_kilocode.ts
    print_status "Downloading models_kilocode.ts..."
    if curl -fsSL "$MODELS_FILE_URL" -o "$PLUGIN_DIR/models_kilocode.ts"; then
        print_success "Downloaded models_kilocode.ts"
    else
        print_error "Failed to download models_kilocode.ts"
        print_error "URL: $MODELS_FILE_URL"
        exit 1
    fi
    
    print_success "All plugin files downloaded successfully"
}

# Check for force parameter
FORCE_DOWNLOAD=""
if [[ "$1" == "force" ]]; then
    FORCE_DOWNLOAD="force"
    print_warning "Force download enabled - will re-download all files"
fi

# Download the plugin files
download_plugin_files "$FORCE_DOWNLOAD"

# Verify plugin files exist after download
if [[ ! -f "$PLUGIN_DIR/plugin_kilocode.ts" ]] || [[ ! -f "$PLUGIN_DIR/models_kilocode.ts" ]]; then
    print_error "Plugin files verification failed after download"
    exit 1
fi

print_success "Plugin files verified"

# Backup existing config if it exists
if [[ -f "$CONFIG_FILE" ]]; then
    print_status "Backing up existing opencode.json..."
    cp "$CONFIG_FILE" "${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    print_success "Backup created: ${CONFIG_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
fi

# Function to update opencode.json
update_config() {
    print_status "Updating opencode.json configuration..."
    
    # Check if config file exists
    if [[ ! -f "$CONFIG_FILE" ]]; then
        print_status "Creating new opencode.json..."
        cat > "$CONFIG_FILE" << EOF
{
  "\$schema": "https://opencode.ai/config.json",
  "plugin": [
    "$PLUGIN_ENTRY"
  ]
}
EOF
        print_success "Created new opencode.json with kilocode plugin"
        return
    fi
    
    # Check if file is valid JSON
    if ! jq empty "$CONFIG_FILE" 2>/dev/null; then
        print_error "Invalid JSON in opencode.json"
        exit 1
    fi
    
    # Check if plugin already exists in config
    if jq -e --arg plugin "$PLUGIN_ENTRY" '.plugin[]? | select(. == $plugin)' "$CONFIG_FILE" >/dev/null 2>&1; then
        print_warning "Kilocode plugin is already configured in opencode.json"
        return
    fi
    
    # Check if plugin array exists
    if jq -e '.plugin' "$CONFIG_FILE" >/dev/null 2>&1; then
        print_status "Adding kilocode plugin to existing plugin array..."
        # Add to existing plugin array
        jq --arg plugin "$PLUGIN_ENTRY" '.plugin += [$plugin]' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    else
        print_status "Creating plugin array and adding kilocode plugin..."
        # Create plugin array and add our plugin
        jq --arg plugin "$PLUGIN_ENTRY" '. + {"plugin": [$plugin]}' "$CONFIG_FILE" > "${CONFIG_FILE}.tmp" && mv "${CONFIG_FILE}.tmp" "$CONFIG_FILE"
    fi
    
    print_success "Successfully added kilocode plugin to opencode.json"
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    print_warning "jq is not installed. Installing via Homebrew..."
    if command -v brew &> /dev/null; then
        brew install jq
        print_success "jq installed successfully"
    else
        print_error "Homebrew not found. Please install jq manually:"
        echo "  brew install jq"
        echo "  or download from: https://stedolan.github.io/jq/"
        exit 1
    fi
fi

# Update configuration
update_config

# Verify the configuration
print_status "Verifying configuration..."
if jq -e --arg plugin "$PLUGIN_ENTRY" '.plugin[]? | select(. == $plugin)' "$CONFIG_FILE" >/dev/null 2>&1; then
    print_success "Configuration verified successfully"
else
    print_error "Configuration verification failed"
    exit 1
fi

# Display final configuration
print_status "Current plugin configuration:"
jq '.plugin' "$CONFIG_FILE" 2>/dev/null || echo "Could not display plugin configuration"

echo ""
print_success "🎉 Kilocode plugin installation completed!"
echo ""
print_status "Plugin location: $PLUGIN_DIR"
print_status "Configuration: $CONFIG_FILE"
echo ""
print_warning "IMPORTANT: Don't forget to set your API key!"
echo "  export KILOCODE_API_KEY='your_api_key_here'"
echo "  or add it to your ~/.zshrc or ~/.bashrc"
echo ""
print_status "Get your API key from: https://app.kilocode.ai/profile"
echo ""
print_status "You can now restart OpenCode to use the Kilocode plugin."

# Optional: Set executable permissions on plugin files
chmod +x "$PLUGIN_DIR"/*.ts 2>/dev/null || true

echo ""
print_success "Installation script completed successfully! 🚀"
