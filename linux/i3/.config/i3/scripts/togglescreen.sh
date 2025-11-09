#!/bin/bash

PRIMARY="DP-2"
SECONDARY="DP-0"

# Get the X offset of the SECONDARY (DP-0)
X_POS=$(xrandr | grep "^$SECONDARY connected" | grep -oP '\+\K[0-9]+(?=\+)')

echo "X_POS: $X_POS"

if [ "$X_POS" -eq 0 ]; then
    # DP-0 is on the left → move to right
    xrandr --output "$PRIMARY" --primary --auto --pos 0x0 \
        --output "$SECONDARY" --auto --right-of "$PRIMARY"
else
    # DP-0 is on the right → move to left
    xrandr --output "$SECONDARY" --auto --left-of "$PRIMARY" \
        --output "$PRIMARY" --primary --auto --pos 1920x0
fi
