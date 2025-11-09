#!/bin/bash

MONITOR="DP-0" # Adjust if needed

# Get the rotation field (e.g., "normal", "left", etc.)
ROTATION=$(xrandr | grep "^$MONITOR connected" | awk '{print $4}')
echo "Current rotation: $ROTATION"

# Toggle rotation
if [ "$ROTATION" = "left" ]; then
    xrandr --output "$MONITOR" --rotate normal
fi
if [ "$ROTATION" = "(normal" ]; then
    xrandr --output "$MONITOR" --rotate left
fi
