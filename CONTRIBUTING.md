# Contributing to Your Own Dotfiles

This guide helps you maintain and extend your dotfiles.

## Adding a New Config Package

### 1. Determine Package Location

- **Common** (works on both Linux and macOS): `common/`
- **Linux-only**: `linux/`
- **macOS-only**: `mac/`

### 2. Create Package Structure

The package should mirror your home directory structure:

```bash
# Example: Adding a new terminal emulator config
cd ~/.dotfiles/common
mkdir -p alacritty/.config/alacritty

# Copy your config
cp ~/.config/alacritty/alacritty.yml alacritty/.config/alacritty/
```

### 3. Update sync.sh

Add the new package to the appropriate array in `sync.sh`:

```bash
COMMON_CONFIGS=(
    "nvim:.config/nvim"
    "tmux:.tmux.conf"
    # ... existing configs
    "alacritty:.config/alacritty"  # Add this line
)
```

### 4. Test and Commit

```bash
# Test stowing
cd ~/.dotfiles/common
stow -n -v alacritty     # Dry run

# If looks good, sync and commit
make sync
git add -A
git commit -m "Add alacritty config"
git push
```

## Modifying Existing Configs

### Quick Workflow

```bash
# 1. Edit config in home directory
vim ~/.config/nvim/init.lua

# 2. Sync back to dotfiles
make sync

# 3. Commit changes
cd ~/.dotfiles
git add -A
git commit -m "Update nvim config: add new plugin"
git push
```

### Direct Editing (Alternative)

You can also edit directly in the dotfiles repo:

```bash
# 1. Edit in dotfiles
vim ~/.dotfiles/common/nvim/.config/nvim/init.lua

# 2. Restow to apply
cd ~/.dotfiles/common
stow -R nvim

# 3. Commit
cd ~/.dotfiles
git add -A
git commit -m "Update nvim config"
git push
```

## Testing Changes

Always test before committing:

```bash
# Test installation
make test-dry-run

# Test dependencies
make test-deps

# Test structure
make test-structure

# Dry-run stow
cd ~/.dotfiles/common
stow -n -v package-name
```

## Updating Dependencies in install.sh

### Adding System Packages

Edit the package list in `install.sh`:

```bash
# For Linux
sudo apt install -y stow zsh neovim tmux ... your-new-package

# For macOS
brew install stow zsh neovim tmux ... your-new-package
```

### Adding Custom Installation Functions

Follow the pattern of existing functions:

```bash
install_your_tool() {
    if command -v your-tool &>/dev/null; then
        echo "your-tool is already installed. Skipping."
        return 0
    fi
    
    echo "Installing your-tool..."
    # Installation steps here
    
    if command -v your-tool &>/dev/null; then
        echo "your-tool successfully installed."
    else
        echo "Warning: your-tool installation may have failed."
        return 1
    fi
}
```

Then call it in the main installation flow:

```bash
install_rustup
install_node
install_your_tool  # Add here
```

## File Organization Best Practices

### Stow Package Structure

✅ **Good:**
```
package-name/
└── .config/
    └── package-name/
        └── config-file
```

❌ **Bad:**
```
package-name/
└── config-file  # Missing .config directory
```

### Naming Conventions

- **Package folders**: lowercase, hyphen-separated (e.g., `my-app`)
- **Script files**: lowercase, underscore-separated (e.g., `sync_configs.sh`)
- **Documentation**: UPPERCASE for top-level docs (e.g., `README.md`)

## Sync Configuration

The `sync.sh` script uses this format:

```bash
"package-name:source-path"
```

Examples:
```bash
"nvim:.config/nvim"           # From ~/.config/nvim
"tmux:.tmux.conf"             # From ~/.tmux.conf
"zsh:.zshrc"                  # From ~/.zshrc
```

## Makefile Targets

### Adding New Commands

Edit `Makefile` and add your target:

```makefile
.PHONY: your-command

your-command:
	@echo "Running your command..."
	@./your-script.sh
```

Update the help section:

```makefile
help:
	@echo "  make your-command     - Description of your command"
```

## Git Workflow

### Branching

Create feature branches for major changes:

```bash
git checkout -b feature/add-hyprland-config
# Make changes
git add -A
git commit -m "Add Hyprland window manager config"
git push -u origin feature/add-hyprland-config
```

### Commit Messages

Use clear, descriptive commit messages:

✅ **Good:**
- `Add Hyprland config with custom keybindings`
- `Fix rofi theme path in sync script`
- `Update nvim: add telescope fuzzy finder`

❌ **Bad:**
- `update`
- `fix bug`
- `changes`

### Commit Message Format

```
<type>: <short summary>

<optional detailed description>

<optional breaking changes>
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

## Updating README

When adding significant features, update `README.md`:

1. Add to "What's Included?" section
2. Update repository structure diagram
3. Add to usage examples if applicable
4. Update troubleshooting if needed

## Platform-Specific Notes

### Linux (Ubuntu/Debian)

- Test with `apt` package manager
- Consider adding PPA repositories if needed
- Test on both GNOME and i3 environments

### macOS

- Test with Homebrew
- Use `brew install --cask` for GUI apps
- Consider Apple Silicon vs Intel differences

## Backup Strategy

Before major changes:

```bash
# Backup current configs
cp -r ~/.config/nvim ~/.config/nvim.backup
cp ~/.zshrc ~/.zshrc.backup

# Or use timeshift/Time Machine
```

## Getting Help

If something breaks:

1. Check `make test-dry-run` output
2. Review recent commits: `git log -5`
3. Use `git diff` to see changes
4. Revert if needed: `git revert HEAD`
5. Check logs in test scripts

## Useful Git Commands

```bash
# See what changed
git diff
git status

# Undo uncommitted changes
git restore file.txt
git restore .

# Undo last commit (keep changes)
git reset --soft HEAD~1

# View history
git log --oneline --graph
git log -p file.txt

# Compare with remote
git fetch
git diff origin/main
```
