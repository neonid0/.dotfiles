#!/bin/bash
# Prompt for a name and save the current i3 window setup under it.

MANAGER=~/.config/i3/scripts/i3_setup_manager.py

name=$(rofi -dmenu -p "Save setup as" -lines 0)
[ -z "$name" ] && exit 0

result=$("$MANAGER" save "$name" 2>&1)
notify-send "i3 setup saved" "$result" -u low
