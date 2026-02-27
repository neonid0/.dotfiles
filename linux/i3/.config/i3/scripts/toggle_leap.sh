#!/bin/bash
# toggle_leap.sh — Toggle Input Leap edge-navigation integration

FLAG_FILE="/tmp/i3_leap_enabled"

if [ -f "$FLAG_FILE" ]; then
    rm "$FLAG_FILE"
    notify-send -t 2000 -i input-keyboard "Input Leap" "🔴 Edge navigation disabled"
else
    touch "$FLAG_FILE"
    notify-send -t 2000 -i input-keyboard "Input Leap" "🟢 Edge navigation enabled"
fi
