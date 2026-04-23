#!/usr/bin/env bash
set -euo pipefail

# Simple test script for Bevy Test App setup

GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "Testing Bevy Test App setup..."
echo

# Test 1: Check required files
echo "1. Checking required files..."
required_files=("setup.sh" "Cargo.toml" "src/main.rs" "web-demo.html" "README.md" ".devcontainer/devcontainer.json")
missing=()
for file in "${required_files[@]}"; do
    if [[ ! -f "$file" ]]; then
        missing+=("$file")
    fi
done

if [[ ${#missing[@]} -eq 0 ]]; then
    echo -e "${GREEN}✓ All required files present${NC}"
else
    echo -e "${RED}✗ Missing files: ${missing[*]}${NC}"
    exit 1
fi

# Test 2: Check setup.sh is executable
echo "2. Checking setup.sh permissions..."
if [[ -x "setup.sh" ]]; then
    echo -e "${GREEN}✓ setup.sh is executable${NC}"
else
    echo -e "${RED}✗ setup.sh is not executable${NC}"
    exit 1
fi

# Test 3: Check Cargo.toml is valid
echo "3. Checking Cargo.toml..."
if cargo check --quiet 2>/dev/null; then
    echo -e "${GREEN}✓ Cargo.toml is valid${NC}"
else
    echo -e "${RED}✗ Cargo.toml has issues${NC}"
    exit 1
fi

# Test 4: Check devcontainer has postCreateCommand
echo "4. Checking devcontainer configuration..."
if grep -q "postCreateCommand" .devcontainer/devcontainer.json; then
    echo -e "${GREEN}✓ devcontainer has postCreateCommand${NC}"
else
    echo -e "${RED}✗ devcontainer missing postCreateCommand${NC}"
    exit 1
fi

echo
echo -e "${GREEN}🎉 All tests passed! The codebase is ready.${NC}"
echo
echo "To start the app in a new codespace:"
echo "  ./setup.sh"
echo
echo "This will automatically set up everything and start the web demo."