#!/bin/bash

# Kill any existing video wallpaper
killall -9 xwinwrap mpv 2>/dev/null

# Set your video path here
VIDEO_PATH="$HOME/Videos/wallpaper.mp4"

# Get all monitor resolutions and positions
xrandr --query | grep " connected" | while read -r line; do
    # Extract monitor geometry (WIDTHxHEIGHT+X+Y)
    geometry=$(echo "$line" | grep -oP '\d+x\d+\+\d+\+\d+')
    
    if [ -n "$geometry" ]; then
        # Start video wallpaper for this monitor
        xwinwrap -g "$geometry" -ov -ni -s -nf -- mpv -wid WID --loop --no-audio --no-osc --no-osd-bar --hwdec=auto --panscan=1.0 "$VIDEO_PATH" &
    fi
done
