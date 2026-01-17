#!/bin/bash
# Dry-run test for install.sh - simulates installation without making changes

DOTFILES_DIR=~/.dotfiles

echo "=== Dry-Run Test for install.sh ==="
echo "This test simulates the installation process without making actual changes."
echo

# Simulate OS detection
get_os() {
    case "$(uname -s)" in
    Linux*) echo "Linux" ;;
    Darwin*) echo "macOS" ;;
    *) echo "Unknown" ;;
    esac
}

OS=$(get_os)
echo "✓ Detected OS: $OS"
echo

# Test Git submodules
echo "Testing Git submodules..."
cd "$DOTFILES_DIR"
if git submodule status | grep -q "^-"; then
    echo "  ⚠ Some submodules are not initialized"
else
    echo "  ✓ Submodules are initialized"
fi
echo

# Test package installation checks
echo "Testing package availability..."
PACKAGES=(stow zsh neovim tmux git gh neofetch curl)
MISSING=()

for pkg in "${PACKAGES[@]}"; do
    if command -v $pkg &>/dev/null; then
        echo "  ✓ $pkg"
    else
        echo "  ✗ $pkg (missing)"
        MISSING+=("$pkg")
    fi
done

if [ ${#MISSING[@]} -gt 0 ]; then
    echo "  Missing packages: ${MISSING[*]}"
    echo "  Would install: ${MISSING[*]}"
fi
echo

# Test custom installation functions
echo "Testing custom installations..."

# Rust/Cargo
if command -v cargo &>/dev/null; then
    echo "  ✓ Rust/Cargo already installed: $(cargo --version | head -1)"
else
    echo "  → Would install Rust/Cargo"
fi

# NVM/Node
if [ -s "$HOME/.nvm/nvm.sh" ]; then
    \. "$HOME/.nvm/nvm.sh"
    if command -v node &>/dev/null; then
        echo "  ✓ Node already installed: $(node --version)"
    else
        echo "  → Would install Node.js via NVM"
    fi
else
    echo "  → Would install NVM and Node.js"
fi

# i3lock-color (Linux only)
if [ "$OS" == "Linux" ]; then
    if command -v i3lock-color &>/dev/null; then
        echo "  ✓ i3lock-color already installed"
    else
        echo "  → Would install i3lock-color from source"
    fi
fi

# Nerd Fonts
if [ -f "$HOME/.local/share/fonts/CaskaydiaCoveNerdFont-Regular.ttf" ]; then
    echo "  ✓ Nerd Font already installed"
else
    echo "  → Would install Caskaydia Cove Nerd Font"
fi
echo

# Test stow packages
echo "Testing stow packages..."
cd "$DOTFILES_DIR/common"
echo "Common packages available:"
for pkg in *; do
    if [ -d "$pkg" ]; then
        echo "  - $pkg"
    fi
done

if [ "$OS" == "Linux" ]; then
    cd "$DOTFILES_DIR/linux"
    echo "Linux packages available:"
    for pkg in *; do
        if [ -d "$pkg" ]; then
            echo "  - $pkg"
        fi
    done
elif [ "$OS" == "macOS" ]; then
    cd "$DOTFILES_DIR/mac"
    echo "macOS packages available:"
    for pkg in *; do
        if [ -d "$pkg" ]; then
            echo "  - $pkg"
        fi
    done
fi
echo

# Test script permissions
if [ "$OS" == "Linux" ]; then
    echo "Testing script directories..."
    if [ -d "$HOME/.config/i3/scripts" ]; then
        echo "  ✓ i3 scripts directory exists"
        SCRIPT_COUNT=$(find "$HOME/.config/i3/scripts" -name "*.sh" 2>/dev/null | wc -l)
        echo "    Found $SCRIPT_COUNT shell scripts"
    else
        echo "  → i3 scripts directory not found (will be created after stowing)"
    fi
    
    if [ -d "$HOME/.config/rofi" ]; then
        echo "  ✓ Rofi directory exists"
        SCRIPT_COUNT=$(find "$HOME/.config/rofi" -name "*.sh" 2>/dev/null | wc -l)
        echo "    Found $SCRIPT_COUNT shell scripts"
    else
        echo "  → Rofi directory not found (will be created after stowing)"
    fi
fi
echo

# Test Oh My Zsh
echo "Testing Oh My Zsh installation..."
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "  ✓ Oh My Zsh is installed"
    
    if [ -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "  ✓ PowerLevel10k is installed"
    else
        echo "  → Would install PowerLevel10k theme"
    fi
else
    echo "  → Would install Oh My Zsh and PowerLevel10k"
fi
echo

# Test MCPHub
echo "Testing MCPHub..."
if command -v npm &>/dev/null; then
    if npm list -g mcp-hub &>/dev/null; then
        echo "  ✓ MCPHub is installed"
    else
        echo "  → Would install MCPHub via npm"
    fi
else
    echo "  ⚠ npm not available, MCPHub requires Node.js"
fi
echo

# Final check
echo "=== Dry-Run Complete ==="
echo "The actual install.sh would:"
echo "1. Initialize git submodules"
echo "2. Install missing system packages"
echo "3. Install Rust, Node.js, i3lock-color, and Nerd Fonts (if missing)"
echo "4. Interactively stow dotfiles from common/ and $OS/"
echo "5. Set up Oh My Zsh and PowerLevel10k"
echo "6. Install MCPHub for Neovim"
echo "7. Change default shell to zsh"
echo
echo "To run the actual installation: ~/.dotfiles/install.sh"
