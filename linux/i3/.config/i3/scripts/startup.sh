#!/bin/bash

# i3 Startup Script
# Detects displays, configures them, and launches applications on appropriate workspaces

# Wait a bit for displays to be detected
sleep 2

# Check connected displays
xrandr_output=$(xrandr)
dp0_connected=$(echo "$xrandr_output" | grep -q "^DP-0 connected" && echo "yes" || echo "no")
hdmi0_connected=$(echo "$xrandr_output" | grep -q "^HDMI-0 connected" && echo "yes" || echo "no")

# Determine configuration type
if [ "$dp0_connected" = "yes" ] && [ "$hdmi0_connected" = "yes" ]; then
    # Triple monitor setup
    CONFIG_TYPE="triple"
    FLOORP_WS=7
    SPOTIFY_WS=8
    TERMINAL_WS=1
elif [ "$dp0_connected" = "yes" ]; then
    # Dual monitor setup
    CONFIG_TYPE="dual"
    FLOORP_WS=5
    SPOTIFY_WS=6
    TERMINAL_WS=1
else
    # Single monitor setup
    CONFIG_TYPE="single"
    FLOORP_WS=2
    SPOTIFY_WS=3
    TERMINAL_WS=1
fi

# Apply workspace assignments
case "$CONFIG_TYPE" in
    single)
        for ws in 1 2 3 4 5 6 7 8 9 10; do
            i3-msg "workspace number $ws; move workspace to output DP-2" >/dev/null 2>&1
        done
        ;;
    dual)
        i3-msg "workspace number 1; move workspace to output DP-2" >/dev/null 2>&1
        i3-msg "workspace number 2; move workspace to output DP-2" >/dev/null 2>&1
        i3-msg "workspace number 3; move workspace to output DP-2" >/dev/null 2>&1
        i3-msg "workspace number 4; move workspace to output DP-0" >/dev/null 2>&1
        i3-msg "workspace number 5; move workspace to output DP-0" >/dev/null 2>&1
        i3-msg "workspace number 6; move workspace to output DP-0" >/dev/null 2>&1
        i3-msg "workspace number 7; move workspace to output DP-2" >/dev/null 2>&1
        i3-msg "workspace number 8; move workspace to output DP-2" >/dev/null 2>&1
        i3-msg "workspace number 9; move workspace to output DP-0" >/dev/null 2>&1
        i3-msg "workspace number 10; move workspace to output DP-0" >/dev/null 2>&1
        ;;
    triple)
        i3-msg "workspace number 1; move workspace to output DP-2" >/dev/null 2>&1
        i3-msg "workspace number 2; move workspace to output DP-2" >/dev/null 2>&1
        i3-msg "workspace number 3; move workspace to output DP-2" >/dev/null 2>&1
        i3-msg "workspace number 4; move workspace to output DP-0" >/dev/null 2>&1
        i3-msg "workspace number 5; move workspace to output DP-0" >/dev/null 2>&1
        i3-msg "workspace number 6; move workspace to output DP-0" >/dev/null 2>&1
        i3-msg "workspace number 7; move workspace to output HDMI-0" >/dev/null 2>&1
        i3-msg "workspace number 8; move workspace to output HDMI-0" >/dev/null 2>&1
        i3-msg "workspace number 9; move workspace to output HDMI-0" >/dev/null 2>&1
        i3-msg "workspace number 10; move workspace to output DP-2" >/dev/null 2>&1
        ;;
esac

# Launch applications on appropriate workspaces
i3-msg "workspace $TERMINAL_WS; exec i3-sensible-terminal"
sleep 1
i3-msg "workspace $FLOORP_WS; exec floorp"
sleep 1
i3-msg "workspace $SPOTIFY_WS; exec spotify"

# Return to workspace 1
i3-msg "workspace number 1"

# Show notification
if command -v notify-send &>/dev/null; then
    notify-send "i3 Startup" "$CONFIG_TYPE monitor setup\nApps launched" -u low
fi
