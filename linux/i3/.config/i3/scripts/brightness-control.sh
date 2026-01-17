#!/bin/bash

# Brightness control script for all displays using xrandr
# Usage: ./brightness-control.sh [up|down]

BRIGHTNESS_FILE="/tmp/current_brightness"
STEP=0.1
MIN=0.3
MAX=1.0

# Get all connected displays
DISPLAYS=$(xrandr --query | grep " connected" | awk '{print $1}')

# Initialize brightness file if it doesn't exist
if [ ! -f "$BRIGHTNESS_FILE" ]; then
    echo "1.0" > "$BRIGHTNESS_FILE"
fi

# Read current brightness
CURRENT=$(cat "$BRIGHTNESS_FILE")

# Calculate new brightness
if [ "$1" = "up" ]; then
    NEW=$(echo "$CURRENT + $STEP" | bc)
    # Cap at MAX
    if (( $(echo "$NEW > $MAX" | bc -l) )); then
        NEW=$MAX
    fi
elif [ "$1" = "down" ]; then
    NEW=$(echo "$CURRENT - $STEP" | bc)
    # Cap at MIN
    if (( $(echo "$NEW < $MIN" | bc -l) )); then
        NEW=$MIN
    fi
else
    echo "Usage: $0 [up|down]"
    exit 1
fi

# Apply brightness to all displays
for display in $DISPLAYS; do
    xrandr --output "$display" --brightness "$NEW"
done

# Save new brightness
echo "$NEW" > "$BRIGHTNESS_FILE"

# Optional: send notification (requires notify-send)
if command -v notify-send &> /dev/null; then
    PERCENTAGE=$(echo "$NEW * 100" | bc | cut -d. -f1)
    notify-send -t 1000 "Brightness: ${PERCENTAGE}%"
fi
