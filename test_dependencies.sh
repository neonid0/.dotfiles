#!/bin/bash
# Test each installation function in install.sh

set -e

DOTFILES_DIR=~/.dotfiles
RESULTS=()

echo "=== Testing install.sh Installation Functions ==="
echo

# Test 1: Check if rustup installation works
test_rustup() {
    echo "Test 1: Checking Rust/Cargo installation..."
    if command -v cargo &>/dev/null; then
        local VERSION=$(cargo --version 2>&1)
        echo "  ✓ Rust is installed: $VERSION"
        RESULTS+=("PASS: Rust")
        return 0
    else
        echo "  ✗ Rust/Cargo not found"
        RESULTS+=("FAIL: Rust")
        return 1
    fi
}

# Test 2: Check if NVM/Node installation works
test_node() {
    echo "Test 2: Checking NVM/Node installation..."
    
    # NVM is a shell function, need to source it
    if [ -s "$HOME/.nvm/nvm.sh" ]; then
        \. "$HOME/.nvm/nvm.sh"
        
        if command -v nvm &>/dev/null; then
            local NVM_VERSION=$(nvm --version 2>&1)
            echo "  ✓ NVM is installed: $NVM_VERSION"
            
            if command -v node &>/dev/null; then
                local NODE_VERSION=$(node --version 2>&1)
                echo "  ✓ Node is installed: $NODE_VERSION"
                RESULTS+=("PASS: Node")
                return 0
            else
                echo "  ⚠ NVM installed but Node not found"
                RESULTS+=("WARN: Node")
                return 1
            fi
        fi
    else
        echo "  ✗ NVM not found"
        RESULTS+=("FAIL: NVM")
        return 1
    fi
}

# Test 3: Check i3lock-color
test_i3lock() {
    echo "Test 3: Checking i3lock-color installation..."
    if command -v i3lock &>/dev/null; then
        # Check if it's the color version
        if i3lock --version 2>&1 | grep -q "color"; then
            local VERSION=$(i3lock --version 2>&1 | head -1)
            echo "  ✓ i3lock-color is installed: $VERSION"
            RESULTS+=("PASS: i3lock-color")
            return 0
        else
            echo "  ⚠ i3lock found but not color version"
            RESULTS+=("WARN: i3lock (not color)")
            return 1
        fi
    else
        echo "  ✗ i3lock-color not found"
        RESULTS+=("FAIL: i3lock-color")
        return 1
    fi
}

# Test 4: Check Nerd Font
test_nerd_font() {
    echo "Test 4: Checking Nerd Font installation..."
    local FONT_DIR="$HOME/.local/share/fonts"
    local CHECK_FILE="$FONT_DIR/CaskaydiaCoveNerdFont-Regular.ttf"
    
    if [ -f "$CHECK_FILE" ]; then
        echo "  ✓ Caskaydia Cove Nerd Font is installed"
        RESULTS+=("PASS: Nerd Font")
        return 0
    else
        echo "  ✗ Caskaydia Cove Nerd Font not found"
        RESULTS+=("FAIL: Nerd Font")
        return 1
    fi
}

# Test 5: Check required system packages
test_system_packages() {
    echo "Test 5: Checking system packages..."
    local MISSING=()
    local REQUIRED=(stow zsh neovim tmux i3 git gh neofetch curl wget build-essential feh rofi)
    
    for pkg in "${REQUIRED[@]}"; do
        if ! command -v $pkg &>/dev/null && ! dpkg -l | grep -q "^ii  $pkg"; then
            MISSING+=("$pkg")
        fi
    done
    
    if [ ${#MISSING[@]} -eq 0 ]; then
        echo "  ✓ All required system packages installed"
        RESULTS+=("PASS: System packages")
        return 0
    else
        echo "  ✗ Missing packages: ${MISSING[*]}"
        RESULTS+=("FAIL: System packages (${MISSING[*]})")
        return 1
    fi
}

# Test 6: Check Oh My Zsh
test_oh_my_zsh() {
    echo "Test 6: Checking Oh My Zsh installation..."
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "  ✓ Oh My Zsh is installed"
        RESULTS+=("PASS: Oh My Zsh")
        return 0
    else
        echo "  ✗ Oh My Zsh not found"
        RESULTS+=("FAIL: Oh My Zsh")
        return 1
    fi
}

# Test 7: Check PowerLevel10k
test_powerlevel10k() {
    echo "Test 7: Checking PowerLevel10k theme..."
    local P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
    
    if [ -d "$P10K_DIR" ]; then
        echo "  ✓ PowerLevel10k is installed"
        RESULTS+=("PASS: PowerLevel10k")
        return 0
    else
        echo "  ✗ PowerLevel10k not found"
        RESULTS+=("FAIL: PowerLevel10k")
        return 1
    fi
}

# Test 8: Check MCPHub
test_mcphub() {
    echo "Test 8: Checking MCPHub installation..."
    if command -v mcp-hub &>/dev/null || npm list -g mcp-hub &>/dev/null; then
        echo "  ✓ MCPHub is installed"
        RESULTS+=("PASS: MCPHub")
        return 0
    else
        echo "  ✗ MCPHub not found"
        RESULTS+=("FAIL: MCPHub")
        return 1
    fi
}

# Run all tests
echo "Running tests..."
echo
test_rustup || true
test_node || true
test_i3lock || true
test_nerd_font || true
test_system_packages || true
test_oh_my_zsh || true
test_powerlevel10k || true
test_mcphub || true

# Summary
echo
echo "=== Test Summary ==="
for result in "${RESULTS[@]}"; do
    echo "$result"
done

echo
echo "=== Test Complete ==="
