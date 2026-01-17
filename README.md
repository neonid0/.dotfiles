# neonid0's Dotfiles

Modern, well-organized dotfiles for Linux (Ubuntu/Debian) and macOS. Managed with **GNU Stow** and automated installation scripts.

[![Linux](https://img.shields.io/badge/Linux-Tested-success)]()
[![macOS](https://img.shields.io/badge/macOS-Compatible-blue)]()

---

## ✨ Features

- 🚀 **One-command installation** with interactive package selection
- 🔄 **Easy sync** between local configs and repository
- 🧪 **Comprehensive testing** before installation
- 📦 **Modular structure** with common and OS-specific configs
- 🎨 **Beautiful terminal** with PowerLevel10k and Nerd Fonts
- 🛠️ **Makefile** for convenient commands

---

## 🚀 Quick Start

### Installation

```bash
# Clone the repository (with submodules and LFS)
git lfs install
git clone --recursive https://github.com/neonid0/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Test before installing (recommended)
make test-dry-run

# Install everything
make install
```

### Using Makefile

The Makefile provides convenient shortcuts:

```bash
make help          # Show all available commands
make install       # Run full installation
make sync          # Sync local configs to repo
make update        # Pull latest changes
make test          # Run all tests
```

---

## 📦 What's Included?

### Core Tools
- **Editor**: Neovim (LazyVim configuration)
- **Shell**: Zsh + Oh My Zsh + PowerLevel10k
- **Terminal Multiplexer**: Tmux
- **Version Control**: Git + GitHub CLI

### Linux GUI (i3 Window Manager)
- **Window Manager**: i3-gaps
- **Compositor**: Picom
- **App Launcher**: Rofi (with vim keybindings)
- **Lock Screen**: i3lock-color
- **Wallpaper**: feh
- **Tools**: maim, xclip, xbacklight, pavucontrol

### Development
- **Languages**: Rust (rustup), Node.js (nvm)
- **Build Tools**: build-essential, python3-pip, pipx
- **Utilities**: fzf, ripgrep, bat, btop, neofetch, fastfetch

### Fonts & Themes
- **Font**: Caskaydia Cove Nerd Font
- **Terminal Theme**: Carbonfox (GNOME Terminal)
- **Editor Theme**: Multiple options (Monokai Pro, Tokyo Night, etc.)

---

## 📂 Repository Structure

```
~/.dotfiles/
├── common/           # Shared configs (Linux + macOS)
│   ├── nvim/         # Neovim config
│   ├── tmux/         # Tmux config
│   ├── zsh/          # Zsh config
│   ├── p10k/         # PowerLevel10k theme
│   ├── kitty/        # Kitty terminal
│   ├── fastfetch/    # Fastfetch config
│   ├── neofetch/     # Neofetch config
│   └── git/          # Git ignore patterns
├── linux/            # Linux-specific configs
│   ├── i3/           # i3 window manager
│   ├── rofi/         # Rofi launcher
│   ├── i3status/     # i3 status bar
│   ├── feh/          # Wallpaper setter
│   ├── gnome-shell/  # GNOME terminal theme
│   ├── systemd-user/ # User systemd services
│   └── xsession/     # X session config
├── mac/              # macOS-specific configs
│   ├── aerospace/    # Aerospace WM
│   ├── alacritty/    # Alacritty terminal
│   └── skhd/         # Hotkey daemon
├── install.sh        # Main installation script
├── sync.sh           # Sync local configs to repo
├── Makefile          # Convenient make commands
└── test_*.sh         # Testing scripts
```

---

## 🔧 Usage

### Syncing Configs

After modifying your local configs, sync them back to the repository:

```bash
make sync              # Sync all configs
cd ~/.dotfiles
git add -A
git commit -m "Update configs"
git push
```

### Updating Dotfiles

To pull the latest changes from the repository:

```bash
make update            # Pull + update submodules
```

### Stow Management

Manually manage symlinks with stow:

```bash
make stow-common       # Stow common packages
make stow-os           # Stow OS-specific packages
make unstow            # Remove all symlinks
```

Or use stow directly:

```bash
cd ~/.dotfiles/common
stow -R -t ~ nvim      # Restow nvim config
stow -D -t ~ tmux      # Remove tmux symlinks
```

---

## 🧪 Testing

Before making changes, test the setup:

```bash
make test              # Run all tests
make test-dry-run      # Simulate installation
make test-deps         # Check dependencies
make test-structure    # Validate repository structure
```

---

## ✏️ Post-Install Steps

1. **Restart your shell** or log out and back in for zsh to become default

2. **Configure PowerLevel10k** on first zsh launch:
   ```bash
   p10k configure
   ```

3. **GNOME Terminal** users: Select "Carbonfox" profile in terminal preferences

4. **Set up Git credentials**:
   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

5. **For i3 users**: Edit `~/.config/i3/scripts/btautostop.sh` and add your Bluetooth device MAC address

---

## 🎨 Rofi Customization

Rofi includes vim-style keybindings:

- **Ctrl+j/k**: Navigate up/down
- **Ctrl+l**: Accept/launch selected item
- **Ctrl+f/b**: Page down/up
- **Ctrl+g/Shift+g**: Jump to first/last item
- **Ctrl+c/Esc**: Cancel

Theme: `rounded-nord-dark` (from [rofi-themes-collection](https://github.com/newmanls/rofi-themes-collection))

---

## 🔄 Keeping Configs in Sync

The `sync.sh` script automatically syncs these configs:

**Common** (Linux + macOS):
- nvim, tmux, zsh, p10k, kitty, fastfetch, neofetch

**Linux-specific**:
- rofi, i3, i3status

**macOS-specific**:
- aerospace, alacritty, skhd

---

## 🛠️ Customization

### Adding New Configs

1. Create a new folder in `common/` or `linux/`/`mac/`
2. Add your config files with proper directory structure
3. Update `sync.sh` to include the new config
4. Run `make sync` to sync changes

### Modifying Existing Configs

1. Edit files in your home directory (e.g., `~/.config/nvim/`)
2. Run `make sync` to sync back to dotfiles
3. Commit and push changes

---

## 📝 Notes

- The installation script is **idempotent** - safe to run multiple times
- Requires **sudo** for system package installation
- **Cloudflare WARP** is optional and may not be in standard repos
- **i3lock-color** is compiled from source on Linux

---

## 🐛 Troubleshooting

### Installation fails

```bash
make test-dry-run      # Check what would be installed
make test-deps         # Verify dependencies
```

### Stow conflicts

```bash
make unstow            # Remove existing symlinks
make install           # Reinstall
```

### Git submodule issues

```bash
git submodule update --init --recursive
```

### Git LFS issues

```bash
# Install Git LFS if not already installed
sudo apt install git-lfs      # Linux
brew install git-lfs          # macOS

# Initialize and pull LFS files
git lfs install
git lfs pull
```

---

## 📦 Git LFS

This repository uses Git LFS (Large File Storage) to manage binary files efficiently:

- **Images**: `*.png`, `*.jpg`, `*.jpeg`, `*.gif`
- **Fonts**: `*.ttf`, `*.otf`

**First time setup:**
```bash
# Install Git LFS
sudo apt install git-lfs    # Linux
brew install git-lfs        # macOS

# Initialize LFS
git lfs install
```

LFS files are automatically pulled when you clone with `git lfs install` configured.

---

## 📄 License

These dotfiles are provided as-is. Feel free to use, modify, and distribute.

---

## 🙏 Acknowledgments

- [LazyVim](https://github.com/LazyVim/LazyVim) - Neovim configuration
- [Oh My Zsh](https://ohmyz.sh/) - Zsh framework
- [PowerLevel10k](https://github.com/romkatv/powerlevel10k) - Zsh theme
- [rofi-themes-collection](https://github.com/newmanls/rofi-themes-collection) - Rofi themes
- [i3lock-color](https://github.com/Raymo111/i3lock-color) - Lock screen
