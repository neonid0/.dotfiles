#!/bin/bash
# Carbonfox GNOME Terminal Setup
# Author: ChatGPT

# Get default profile ID
PROFILE=$(gsettings get org.gnome.Terminal.ProfilesList default | tr -d \')

if [ -z "$PROFILE" ]; then
    echo "No default GNOME Terminal profile found. Create one first."
    exit 1
fi

echo "Applying Carbonfox colors to profile: $PROFILE"

# Set main colors
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/" background-color '#0d1117'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/" foreground-color '#cdd6f4'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/" cursor-background-color '#61afef'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/" cursor-foreground-color '#0d1117'

# Enable use of custom colors
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/" use-theme-colors false

# Set ANSI palette
PALETTE="['#0d1117', '#f7768e', '#9ece6a', '#e0af68', '#61afef', '#bb9af7', '#7dcfff', '#cdd6f4', '#545c7e', '#f7768e', '#9ece6a', '#e0af68', '#61afef', '#bb9af7', '#7dcfff', '#ffffff']"
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/" palette "$PALETTE"

# Optional: Enable transparent background
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/" use-transparent-background true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$PROFILE/" background-transparency-percent 10

echo "Carbonfox theme applied! Restart GNOME Terminal to see changes."
