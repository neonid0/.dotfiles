#!/bin/bash
# toggle_leap.sh — toggle Input Leap edge-switching on/off

FLAG_FILE="/tmp/aerospace_leap_enabled"

if [ -f "$FLAG_FILE" ]; then
    rm "$FLAG_FILE"
    osascript -e 'display notification "Input Leap edge-switching: DISABLED" with title "Aerospace"'
else
    touch "$FLAG_FILE"
    osascript -e 'display notification "Input Leap edge-switching: ENABLED" with title "Aerospace"'
fi
