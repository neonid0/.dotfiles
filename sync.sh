#!/bin/bash

# Dotfiles sync script
# Syncs local config files to the dotfiles repository

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Syncing dotfiles ===${NC}\n"

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS_DIR="linux"
    COMMON_CONFIGS=(
        "nvim:.config/nvim"
        "tmux:.tmux.conf"
        "zsh:.zshrc"
        "p10k:.p10k.zsh"
        "kitty:.config/kitty"
        "fastfetch:.config/fastfetch"
        "neofetch:.config/neofetch"
    )
    LINUX_CONFIGS=(
        "rofi:.config/rofi"
        "i3:.config/i3"
        "i3status:.config/i3status"
    )
elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS_DIR="mac"
    COMMON_CONFIGS=(
        "nvim:.config/nvim"
        "tmux:.tmux.conf"
        "zsh:.zshrc"
        "p10k:.p10k.zsh"
        "kitty:.config/kitty"
        "fastfetch:.config/fastfetch"
        "neofetch:.config/neofetch"
    )
    MAC_CONFIGS=(
        "aerospace:.config/aerospace"
        "alacritty:.config/alacritty"
        "karabiner:.config/karabiner"
        "linearmouse:.config/linearmouse"
        "skhd:.config/skhd"
        "yabai:.config/yabai"
        "zellij:.config/zellij"
    )
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Function to sync config
sync_config() {
    local name=$1
    local source_path=$2
    local dest_base=$3
    
    if [[ ! -e "$HOME/$source_path" ]]; then
        echo -e "⚠️  Skipping $name: source not found at ~/$source_path"
        return
    fi
    
    local dest_dir="$dest_base/$name"
    
    # Create parent directory structure
    if [[ "$source_path" == .config/* ]]; then
        mkdir -p "$dest_dir/.config"
        local config_name="${source_path#.config/}"
        rsync -av --delete "$HOME/$source_path/" "$dest_dir/.config/$config_name/"
    else
        mkdir -p "$dest_dir"
        if [[ -d "$HOME/$source_path" ]]; then
            rsync -av --delete "$HOME/$source_path/" "$dest_dir/$source_path/"
        else
            rsync -av "$HOME/$source_path" "$dest_dir/$source_path"
        fi
    fi
    
    echo -e "${GREEN}✓${NC} Synced $name"
}

# Function to sync a git submodule config (e.g. nvim)
# Initializes the submodule, rsyncs files into it, and commits changes
sync_submodule() {
    local name=$1
    local source_path=$2
    local submodule_path=$3   # relative path inside DOTFILES_DIR

    if [[ ! -e "$HOME/$source_path" ]]; then
        echo -e "⚠️  Skipping $name submodule: source not found at ~/$source_path"
        return
    fi

    local submodule_dir="$DOTFILES_DIR/$submodule_path"

    # Ensure submodule is checked out (creates .git file in working dir)
    git -C "$DOTFILES_DIR" submodule update --init "$submodule_path" 2>/dev/null
    # Make sure we're on the default branch, not detached HEAD
    git -C "$submodule_dir" checkout main 2>/dev/null || git -C "$submodule_dir" checkout master 2>/dev/null

    # Rsync local config into submodule, preserving .git metadata
    rsync -av --delete --exclude='.git' "$HOME/$source_path/" "$submodule_dir/"

    # Commit and push any changes inside the submodule
    if ! git -C "$submodule_dir" diff --quiet || ! git -C "$submodule_dir" diff --cached --quiet; then
        git -C "$submodule_dir" add -A
        git -C "$submodule_dir" commit -m "sync: update $name config from local"
        git -C "$submodule_dir" push
        echo -e "${GREEN}✓${NC} Pushed $name changes to submodule remote"
    else
        echo -e "${GREEN}✓${NC} $name submodule already up to date"
    fi
}

# Sync common configs
echo -e "${BLUE}Syncing common configs...${NC}"
for config in "${COMMON_CONFIGS[@]}"; do
    IFS=':' read -r name path <<< "$config"
    if [[ "$name" == "nvim" ]]; then
        sync_submodule "$name" "$path" "common/nvim/.config/nvim"
    else
        sync_config "$name" "$path" "$DOTFILES_DIR/common"
    fi
done

# Sync OS-specific configs
if [[ "$OS_DIR" == "linux" ]]; then
    echo -e "\n${BLUE}Syncing Linux-specific configs...${NC}"
    for config in "${LINUX_CONFIGS[@]}"; do
        IFS=':' read -r name path <<< "$config"
        sync_config "$name" "$path" "$DOTFILES_DIR/linux"
    done
elif [[ "$OS_DIR" == "mac" ]]; then
    echo -e "\n${BLUE}Syncing macOS-specific configs...${NC}"
    for config in "${MAC_CONFIGS[@]}"; do
        IFS=':' read -r name path <<< "$config"
        sync_config "$name" "$path" "$DOTFILES_DIR/mac"
    done
fi

echo -e "\n${BLUE}=== Sync complete ===${NC}"
echo -e "\nRun 'cd ~/.dotfiles && git status' to see changes"
echo -e "To push nvim config: git -C ~/.dotfiles/common/nvim/.config/nvim push && cd ~/.dotfiles && git add common/nvim/.config/nvim && git commit -m 'chore: update nvim submodule' && git push"
