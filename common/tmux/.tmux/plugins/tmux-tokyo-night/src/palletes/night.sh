#!/usr/bin/env bash

# Carbonfox Pallet (Blue/Cyan/Charcoal focus)
# Based on the IBM Carbon theme influence
declare -A PALLETE=(
    [none]="NONE"
    [bg]="#161616"             # bg0 (Deepest charcoal/Carbon background)
    [bg_dark]="#0c0c0c"        # Custom even darker BG for distinction
    [bg_highlight]="#262626"   # bg2 (Slightly lighter background)
    [terminal_black]="#393b44" # Normal black/dark gray
    [fg]="#cdcecf"             # fg (Clean, high-contrast foreground)
    [fg_dark]="#888b8a"        # fg_dim (Muted gray text)
    [fg_gutter]="#4f5553"      # dark3 (For comments/less important text)
    [dark3]="#536878"          # dark3 (Dark Electric Blue)
    [comment]="#747c84"        # comment (Lighter comment gray)
    [dark5]="#78a9ff"          # Blue (Secondary blue highlight)

    # --- BLUE/CYAN TONES (Maximized) ---
    [blue0]="#304261" # Deep Koamaru (Deep, primary blue)
    [blue]="#78a9ff"  # Blue (Default blue accent)
    [cyan]="#3ddbd9"  # Cyan (Success states, light blue)
    [blue1]="#52bdff" # Light Blue (Info/secondary elements)
    [blue2]="#007d79" # Dark Teal (For a deep blue/green look)
    [blue5]="#78a9ff" # Use main blue
    [blue6]="#63cdcf" # Soft Cyan/Aqua
    [blue7]="#113f67" # Custom deep blue for depth

    # --- MINIMIZED/MAPPED ACCENTS (for roles only) ---
    [magenta]="#be95ff"  # Purple (Used for primary actions/keywords - can't be pure blue)
    [magenta2]="#ee5396" # Pink (Used for errors/warnings - can't be pure blue)
    [purple]="#be95ff"   # Purple (Same as magenta)
    [orange]="#78a9ff"   # Blue (Mapping orange role to a blue highlight)
    [yellow]="#78a9ff"   # Blue (Mapping yellow role to a blue highlight)
    [green]="#3ddbd9"    # Cyan (Mapping green role to Cyan/Aqua)
    [green1]="#3ddbd9"   # Cyan
    [green2]="#007d79"   # Dark Teal
    [teal]="#3ddbd9"     # Cyan (Same as cyan)
    [red]="#ee5396"      # Pink (Error/Danger)
    [red1]="#be95ff"     # Purple (Using purple for a muted error)
    [white]="#ffffff"    # white
)

export PALLETE
