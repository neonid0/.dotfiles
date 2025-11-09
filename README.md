# neonid0's Dotfiles

These are my personal configuration files (dotfiles) for Linux (Ubuntu/Debian) and macOS.

The setup is managed by **GNU Stow** and automated with a bootstrap script (`install.sh`) to make setting up a new machine fast and simple.

---

## 📸 Preview

(This is the perfect place to put a screenshot of your `i3` desktop, maybe running `neofetch` or `rofi`, so people can see what it looks like!)



---

## 🚀 Installation

**Warning:** This script will install packages, set `zsh` as your default shell, and overwrite existing configs for the software listed below. Please read the script before running.

1.  **Clone the repository (recursively):**

Clone to ~/.dotfiles. The --recursive flag is now required to pull the nvim config

    ```bash
    git clone --recursive [https://github.com/neonid0/.dotfiles.git](https://github.com/neonid0/.dotfiles.git) ~/.dotfiles
    ```

2.  **Run the bootstrap script:**
    ```bash
    cd ~/.dotfiles
    ./install.sh
    ```

The script is idempotent, so you can run it multiple times. It will ask for `sudo` permission to install system packages.

**Note on Updating**: To pull updates for both the dotfiles and the nvim config, run:

    ```
    git pull && git submodule update --remote
    ```

---

## 📦 What's Included?

This setup script configures and installs the following:

| Category | Software |
| :--- | :--- |
| **Core Tools** | `nvim`, `tmux`, `zsh`, `git`, `gh` |
| **Linux GUI** | `i3`, `rofi`, `picom`, `feh`, `i3lock-color`, `dconf` |
| **Shell** | `Oh My Zsh` + `PowerLevel10k` theme, `bat`, `fzf`, `neofetch`, `btop`, `ripgrep` |
| **Dev Runtimes** | `Rust (rustup)`, `Node.js (nvm)` |
| **Dev Tools** | `build-essential`, `python3-pip`, `pipx` |
| **Utilities** | `curl`, `wget`, `maim`, `xclip`, `xbacklight`, `pavucontrol`, `scrot` |
| **Networking** | `bluez`, `blueman`, `cloudflare-warp` |
| **Fonts & Themes** | `Caskaydia Cove Nerd Font`, `Carbonfox Theme (Gnome Terminal, neovim)` |

---

## 📂 File Structure

This repository uses **GNU Stow** to manage symlinks. All configurations are organized into "packages" (folders) which are then symlinked to your home directory (`~/`).

The structure is split by operating system:

* **`common/`**: Contains configs shared between all systems (e.g., `nvim`, `zsh`, `tmux`).
* **`linux/`**: Contains Linux-only configs (e.g., `i3`, `rofi`, `systemd-user`).
* **`macos/`**: Contains macOS-only configs.

The `install.sh` script automatically detects the OS and stows the correct packages.

---

## ✏️ Manual Post-Install Steps

The script automates almost everything, but a few final steps are required:

1.  **Restart Your Shell (or Log Out):** You must log out and log back in for the `chsh -s /usr/bin/zsh` (shell change) to take effect.

2.  **Configure PowerLevel10k:** The first time you open `zsh`, the `PowerLevel10k` configuration wizard will automatically run. You'll need to go through it once to set up your prompt (e.g., `p10k configure`).

3.  **Activate Systemd Services (Optional):**
    Your script includes a commented-out section for `systemd` user services (like your Bluetooth scripts). If you want to enable these, you must:
    * Un-comment the final section in `install.sh`.
    * Re-run the script: `./install.sh`.

4.  **Gnome Terminal Theme:**
    The script attempts to apply the `carbonfox.sh` theme. You may need to manually select "Carbonfox" in your Gnome Terminal's profile settings (`Preferences` -> `Profiles`).

## Extra Notes

- You need to add your ```device MAC address``` to ```Auto Bluetooth scripts``` for it to work properly.

- If you want to customize any configurations, simply edit the files in the respective package folders (e.g., `common/nvim/` for Neovim config). After making changes, you can re-stow the package by running:
    ```bash
    stow -R common/nvim
    ```
