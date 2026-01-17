#!/bin/bash
# Test script for install.sh - runs checks without actually installing

set -e

DOTFILES_DIR=~/.dotfiles

echo "=== Testing Install Script ==="
echo

# Test 1: Check directory structure
echo "Test 1: Checking directory structure..."
if [ -d "$DOTFILES_DIR/common" ]; then
    echo "  ✓ common/ exists"
else
    echo "  ✗ common/ missing"
fi

if [ -d "$DOTFILES_DIR/linux" ]; then
    echo "  ✓ linux/ exists"
else
    echo "  ✗ linux/ missing"
fi

if [ -d "$DOTFILES_DIR/mac" ]; then
    echo "  ✓ mac/ exists"
else
    echo "  ✗ mac/ missing"
fi

# Test 2: Check common packages structure
echo
echo "Test 2: Checking common packages structure..."
cd "$DOTFILES_DIR/common"
for pkg in *; do
    if [ -d "$pkg" ]; then
        # Check if stow package is valid (has files to link)
        if find "$pkg" -maxdepth 2 -type f | grep -q .; then
            echo "  ✓ $pkg - valid stow package"
        else
            echo "  ⚠ $pkg - empty or invalid"
        fi
    fi
done

# Test 3: Check linux packages structure
echo
echo "Test 3: Checking linux packages structure..."
cd "$DOTFILES_DIR/linux"
for pkg in *; do
    if [ -d "$pkg" ]; then
        if find "$pkg" -maxdepth 2 -type f | grep -q .; then
            echo "  ✓ $pkg - valid stow package"
        else
            echo "  ⚠ $pkg - empty or invalid"
        fi
    fi
done

# Test 4: Test stow dry-run on a sample package
echo
echo "Test 4: Testing stow dry-run on nvim..."
cd "$DOTFILES_DIR/common"
if stow -n -t ~ nvim 2>&1 | grep -q "CONFLICT"; then
    echo "  ⚠ nvim has conflicts (normal if already installed)"
else
    echo "  ✓ nvim can be stowed"
fi

# Test 5: Check for required commands
echo
echo "Test 5: Checking for required commands..."
for cmd in stow git curl; do
    if command -v $cmd &>/dev/null; then
        echo "  ✓ $cmd found"
    else
        echo "  ✗ $cmd not found"
    fi
done

# Test 6: Validate whiptail availability
echo
echo "Test 6: Checking whiptail (for interactive menu)..."
if command -v whiptail &>/dev/null; then
    echo "  ✓ whiptail found"
else
    echo "  ⚠ whiptail not found - interactive mode won't work"
fi

echo
echo "=== Test Complete ==="
