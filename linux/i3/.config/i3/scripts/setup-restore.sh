#!/bin/bash
# List saved i3 setups in rofi and restore the chosen one.

MANAGER=~/.config/i3/scripts/i3_setup_manager.py

choice=$("$MANAGER" list | rofi -dmenu -p "Restore setup" -format s)
[ -z "$choice" ] && exit 0

name=$(echo "$choice" | cut -f1)
"$MANAGER" restore "$name"
