# Dotfiles Quick Reference

## Common Commands

```bash
# Installation & Setup
make install              # Full installation
make test-dry-run        # Test before installing

# Daily Usage
make sync                # Sync configs to repo
make update              # Pull latest changes
make status              # Check git status

# Testing
make test                # Run all tests
make test-deps           # Check dependencies

# Maintenance
make clean               # Remove temp files
make unstow              # Remove symlinks
```

## Directory Structure Quick Reference

```
~/.dotfiles/
├── common/              # Linux + macOS
│   ├── nvim/           # ~/.config/nvim
│   ├── tmux/           # ~/.tmux.conf, ~/.tmux/
│   ├── zsh/            # ~/.zshrc
│   ├── p10k/           # ~/.p10k.zsh
│   ├── kitty/          # ~/.config/kitty
│   ├── fastfetch/      # ~/.config/fastfetch
│   ├── neofetch/       # ~/.config/neofetch
│   └── git/            # ~/.config/git
├── linux/
│   ├── i3/             # ~/.config/i3
│   ├── rofi/           # ~/.config/rofi
│   ├── i3status/       # ~/.config/i3status
│   └── ...
└── mac/
    ├── aerospace/      # ~/.config/aerospace
    └── ...
```

## Rofi Keybindings

| Key | Action |
|-----|--------|
| `Ctrl+j` | Move down |
| `Ctrl+k` | Move up |
| `Ctrl+l` | Accept/Launch |
| `Ctrl+f` | Page down |
| `Ctrl+b` | Page up |
| `Ctrl+g` | Jump to first |
| `Ctrl+Shift+g` | Jump to last |
| `Ctrl+c` / `Esc` | Cancel |

## Git Workflow

```bash
# After modifying configs
make sync                # Sync to dotfiles
cd ~/.dotfiles
git add -A
git commit -m "Update X config"
git push

# Pull updates
make update
```

## Manual Stow Commands

```bash
# Stow specific package
cd ~/.dotfiles/common
stow -R -t ~ nvim        # Restow nvim

# Remove package
stow -D -t ~ tmux        # Remove tmux symlinks

# Check what would happen
stow -n -v -t ~ zsh      # Dry run
```

## Troubleshooting

### Stow conflicts
```bash
make unstow              # Remove all symlinks
make install             # Reinstall
```

### Missing dependencies
```bash
make test-deps           # Check what's missing
```

### Submodule issues
```bash
git submodule update --init --recursive
```

### Git LFS issues
```bash
# Install Git LFS
sudo apt install git-lfs    # Linux
brew install git-lfs        # macOS

# Initialize and pull LFS files
git lfs install
git lfs pull
```

## Post-Install Checklist

- [ ] Log out and back in (zsh default shell)
- [ ] Run `p10k configure` on first zsh launch
- [ ] Set Git credentials
- [ ] Select Carbonfox in GNOME Terminal (if applicable)
- [ ] Add Bluetooth MAC to i3 scripts (if applicable)

## File Locations After Install

```
~/.config/nvim/          # Neovim config (symlink)
~/.config/i3/            # i3 config (symlink)
~/.config/rofi/          # Rofi config (symlink)
~/.zshrc                 # Zsh config (symlink)
~/.tmux.conf             # Tmux config (symlink)
~/.p10k.zsh              # PowerLevel10k (symlink)
```
