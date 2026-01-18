#!/bin/bash

# Move mouse to center of focused window
# This script monitors i3 focus events and moves the cursor accordingly

MOVEMOUSE='eval $(xdotool getactivewindow getwindowgeometry --shell 2>/dev/null); xdotool mousemove $((X+WIDTH/2)) $((Y+HEIGHT/2)) 2>/dev/null'

# Subscribe to i3 window focus events and move mouse when focus changes
i3-msg -t subscribe -m '[ "window" ]' | while read -r event; do
    if echo "$event" | grep -q '"change":"focus"'; then
        eval "$MOVEMOUSE"
    fi
done
