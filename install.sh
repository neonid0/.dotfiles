#!/bin/bash
#
# neonid0 .dotfiles Bootstrap Script

# Stop on errors
set -e

# --- Configuration ---
# Your dotfiles directory
DOTFILES_DIR=~/.dotfiles

# --- Helper Functions ---
# Function to detect the Operating System
get_os() {
    case "$(uname -s)" in
    Linux*) echo "Linux" ;;
    Darwin*) echo "macOS" ;;
    *) echo "Unknown" ;;
    esac
}

# Folder stowing with interactive whiptail menu
stow_interactive() {
    local STOW_DIR="$1"
    local MENU_TITLE="$2"

    echo "Gathering packages from $STOW_DIR..."
    cd "$DOTFILES_DIR/$STOW_DIR"

    # --- Build the package list for whiptail ---
    # Format: "tag" "description" "ON/OFF"
    local PACKAGES=()
    for pkg in *; do
        # Only add if it's a directory and not hidden
        if [ -d "$pkg" ] && [[ ! "$pkg" == .* ]]; then
            PACKAGES+=("$pkg" "Stow $pkg package" "ON")
        fi
    done

    # --- Show the checklist menu ---
    # Returns a string like: "git" "nvim" "tmux"
    local CHOICES
    CHOICES=$(whiptail --title "$MENU_TITLE" --checklist \
        "Use SPACE to select/deselect packages. Press ENTER when done." 20 78 12 \
        "${PACKAGES[@]}" 3>&1 1>&2 2>&3)

    # Exit if user pressed Cancel
    if [ $? -ne 0 ]; then
        echo "Cancelled."
        cd "$DOTFILES_DIR" # Go back to root
        return 1
    fi

    # --- Stow the selected packages ---
    if [ -z "$CHOICES" ]; then
        echo "No packages selected."
    else
        # This is a safe way to turn the string "git" "nvim" into an array
        local CHOSEN_PACKAGES
        eval "CHOSEN_PACKAGES=($CHOICES)"

        echo "Stowing selected packages from $STOW_DIR..."
        for pkg in "${CHOSEN_PACKAGES[@]}"; do
            echo "  -> Stowing $pkg"
            stow -R -t ~ "$pkg"
        done
    fi

    cd "$DOTFILES_DIR" # Go back to root
}

install_rustup() {
    if ! command -v cargo &>/dev/null; then
        echo "Installing Rust (rustup)..."
        # -y flag accepts all defaults
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

        # Manually add cargo to the PATH for THIS script session
        export PATH="$HOME/.cargo/bin:$PATH"
        echo "Rust installed."
    else
        echo "Rust (cargo) is already installed. Skipping."
    fi
}

install_node() {
    if ! command -v nvm &>/dev/null; then
        echo "Installing NVM (Node Version Manager)..."

        # Download and install nvm:
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

        # in lieu of restarting the shell
        \. "$HOME/.nvm/nvm.sh"

        # Download and install Node.js:
        nvm install 24

        # Verify the Node.js version:
        node -v # Should print "v24.11.0".

        # Verify npm version:
        npm -v # Should print "11.6.1".

        echo "NVM and Node.js installed."
    else
        echo "NVM is already installed. Skipping."
    fi
}

install_i3lock_color() {
    if ! command -v i3lock-color &>/dev/null; then
        echo "Installing i3lock-color from source..."

        # i3lock-color dependencies
        sudo apt install whiptail autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev imagemagick

        # Clone the repository
        git clone https://github.com/Raymo111/i3lock-color.git ~/Downloads/i3lock-color
        cd ~/Downloads/i3lock-color
        ./install-i3lock-color.sh

        echo "i3lock-color installed."
    else
        echo "i3lock-color is already installed. Skipping."
    fi
}

install_nerd_fonts() {
    echo "Checking for Caskaydia Cove Nerd Font..."

    if [ "$OS" == "Linux" ]; then
        local FONT_DIR="$HOME/.local/share/fonts"
        local CHECK_FILE="$FONT_DIR/CaskaydiaCoveNerdFont-Regular.ttf"

        if [ ! -f "$CHECK_FILE" ]; then
            echo "Installing Caskaydia Cove Nerd Font (Linux)..."

            # Define font details
            local FONT_VERSION="v3.2.1"
            local FONT_NAME="CaskaydiaCove"
            local DOWNLOAD_URL="https://github.com/ryanoasis/nerd-fonts/releases/download/$FONT_VERSION/$FONT_NAME.zip"
            local TEMP_ZIP="/tmp/$FONT_NAME.zip"

            mkdir -p "$FONT_DIR"

            echo "Downloading from $DOWNLOAD_URL..."
            curl -L "$DOWNLOAD_URL" -o "$TEMP_ZIP"

            unzip -o "$TEMP_ZIP" "*.ttf" -d "$FONT_DIR"

            rm "$TEMP_ZIP"

            echo "Updating font cache..."
            fc-cache -f -v
            echo "Font installed."
        else
            echo "Caskaydia Cove Nerd Font already installed. Skipping."
        fi
    fi
}

OS=$(get_os)
echo "Running on $OS..."

echo "Initializing/updating Git submodules..."
git submodule update --init --recursive # it is safe to run this multiple times

# --- Package Installation ---
# Install essential packages (stow, zsh, nvim, tmux)
if [ "$OS" == "macOS" ]; then
    echo "Installing packages with Homebrew..."

    # Check for Homebrew, install if not found
    if ! command -v brew &>/dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install stow zsh neovim tmux git gh neofetch curl

elif [ "$OS" == "Linux" ]; then
    echo "Installing packages with apt..."

    # Assumes Ubuntu/Debian. Add logic for other package managers if needed.
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y stow zsh neovim tmux i3 git gh neofetch curl wget build-essential feh rofi bluez blueman maim xclip xbacklight pavucontrol python3-pip python3.12-venv pipx dconf-editor cloudflare-warp scrot fzf ripgrep i3lock apt-transport-https ca-certificates software-properties-common picom btop gawk bat

    # optional: install backup tools & samba for file sharing
    # sudo apt install samba timeshift deja-dup -y
fi

install_i3lock_color
install_rustup
install_node
install_nerd_fonts

# --- Symlinking (Stowing) ---
echo "Stowing common dotfiles..."
stow_interactive "common" "Select Common Dotfiles to Stow"

# Stow OS-specific packages
if [ "$OS" == "macOS" ]; then
    echo "Stowing macOS dotfiles..."
    cd $DOTFILES_DIR/macos
    stow -R -t ~ *

elif [ "$OS" == "Linux" ]; then
    echo "Stowing Linux dotfiles..."
    stow_interactive "linux" "Select Linux Dotfiles to Stow"

    # --- Add Executable Permission to Scripts ---
    echo "Setting executable permissions for i3 scripts..."
    I3_SCRIPTS_DIR="$DOTFILES_DIR/linux/i3/.config/i3/scripts"
    if [ -d "$I3_SCRIPTS_DIR" ]; then
        find "$I3_SCRIPTS_DIR" -type f -name "*.sh" -exec chmod +x {} \;
    else
        echo "i3 scripts directory not found. Skipping permission setup."
    fi

    # --- Add Executable Permission to Rofi Scripts ---
    echo "Setting executable permissions for Rofi scripts..."
    ROFI_SCRIPTS_DIR="$DOTFILES_DIR/linux/rofi/.config/rofi"
    if [ -d "$ROFI_SCRIPTS_DIR" ]; then
        find "$ROFI_SCRIPTS_DIR" -type f -name "*.sh" -exec chmod +x {} \;
    else
        echo "Rofi scripts directory not found. Skipping permission setup."
    fi

    # --- Gnome Terminal Carbonfox Theme Setup ---
    echo "Applying Carbonfox GNOME Terminal theme..."
    GNOME_PKG_DIR="$DOTFILES_DIR/linux/gnome-shell"
    if [ -d "$GNOME_PKG_DIR" ]; then
        bash "$GNOME_PKG_DIR/carbonfox.sh"
    else
        echo "GNOME package directory not found. Skipping Carbonfox theme setup."
    fi

    # --- MCPHub Setup for Neovim ---
    echo "Installing MCPHub globally via npm..."
    npm install -g mcp-hub@latest

    # --- Oh My Zsh Setup ---
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."

        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh is already installed. Skipping."
    fi

    # --- PowerLevel10k Font Setup ---
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
        echo "Installing PowerLevel10k theme for Oh My Zsh..."

        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

        echo "PowerLevel10k installed."
    else
        echo "PowerLevel10k is already installed. Skipping."
    fi

    # You can uncomment and modify the following section to
    # Enable systemd user services if needed.
    #
    # --- Bluetooth Auto-Connect Setup ---
    # SYSTEMD_PKG_DIR="$DOTFILES_DIR/linux/systemd-user"
    #
    # if [ -d "$SYSTEMD_PKG_DIR" ]; then
    #     echo "Activating systemd user services..."
    #
    #     systemd --user daemon-reload
    #
    #     find "$SYSTEMD_PKG_DIR" -type f \( -name "*.service" -o -name "*.timer" \) -print0 | while IFS= read -r -d '' unit_path; do
    #         unit_name=$(basename "$unit_path")
    #         echo "Enabling and starting $unit_name"
    #
    #         systemd --user enable --now "$unit_name"
    #     done
    # fi
    # --- End of new section ---
fi

echo "Dotfiles setup complete!"

# --- Final Steps ---
# (Optional) Change default shell to zsh
if [ "$OS" == "macOS" ]; then
    if ! grep -q "/usr/local/bin/zsh" /etc/shells; then
        echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
    fi
    chsh -s /usr/local/bin/zsh
else
    if ! grep -q "/usr/bin/zsh" /etc/shells; then
        echo "/usr/bin/zsh" | sudo tee -a /etc/shells
    fi
    chsh -s /usr/bin/zsh
fi

echo "Please log out and log back in for shell changes to take effect."
