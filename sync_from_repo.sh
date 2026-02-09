#!/bin/bash

# Dotfiles sync-from-repo script
# Syncs dotfiles repository to local config files

DOTFILES_DIR="$HOME/.dotfiles"
CONFIG_DIR="$HOME/.config"

# Color output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Syncing from dotfiles repo to local ===${NC}\n"

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
        "skhd:.config/skhd"
    )
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Function to sync config from repo to local
sync_from_repo() {
    local name=$1
    local dest_path=$2
    local source_base=$3
    
    local source_dir="$source_base/$name"
    
    if [[ ! -e "$source_dir" ]]; then
        echo -e "⚠️  Skipping $name: not found in repo at $source_dir"
        return
    fi
    
    # Handle .config/* paths
    if [[ "$dest_path" == .config/* ]]; then
        local config_name="${dest_path#.config/}"
        local source_config="$source_dir/.config/$config_name"
        local dest_config="$HOME/.config/$config_name"
        
        if [[ -e "$source_config" ]]; then
            mkdir -p "$HOME/.config"
            rsync -av --delete "$source_config/" "$dest_config/"
            echo -e "${GREEN}✓${NC} Synced $name to ~/.config/$config_name"
        fi
    else
        local source_file="$source_dir/$dest_path"
        local dest_file="$HOME/$dest_path"
        
        if [[ -e "$source_file" ]]; then
            mkdir -p "$(dirname "$dest_file")"
            if [[ -d "$source_file" ]]; then
                rsync -av --delete "$source_file/" "$dest_file/"
            else
                rsync -av "$source_file" "$dest_file"
            fi
            echo -e "${GREEN}✓${NC} Synced $name to ~/$dest_path"
        fi
    fi
}

# Sync common configs
echo -e "${BLUE}Syncing common configs...${NC}"
for config in "${COMMON_CONFIGS[@]}"; do
    IFS=':' read -r name path <<< "$config"
    sync_from_repo "$name" "$path" "$DOTFILES_DIR/common"
done

# Sync OS-specific configs
if [[ "$OS_DIR" == "linux" ]]; then
    echo -e "\n${BLUE}Syncing Linux-specific configs...${NC}"
    for config in "${LINUX_CONFIGS[@]}"; do
        IFS=':' read -r name path <<< "$config"
        sync_from_repo "$name" "$path" "$DOTFILES_DIR/linux"
    done
elif [[ "$OS_DIR" == "mac" ]]; then
    echo -e "\n${BLUE}Syncing macOS-specific configs...${NC}"
    for config in "${MAC_CONFIGS[@]}"; do
        IFS=':' read -r name path <<< "$config"
        sync_from_repo "$name" "$path" "$DOTFILES_DIR/mac"
    done
fi

echo -e "\n${BLUE}=== Sync from repo complete ===${NC}"
echo -e "${YELLOW}⚠️  Your local config files have been updated from the repository${NC}"
