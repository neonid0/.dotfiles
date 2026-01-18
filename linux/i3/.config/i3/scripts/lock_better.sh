#!/bin/bash

# Cache directory for pre-generated frames
CACHE_DIR="$HOME/.cache/video_lockscreen"
CACHE_FLAG="$CACHE_DIR/.cached"

# Check if cache exists
if [ ! -f "$CACHE_FLAG" ]; then
    echo "Generating lockscreen cache (first time only)..."
    mkdir -p "$CACHE_DIR"
    
    # Extract frame from video
    ffmpeg -i ~/Videos/wallpaper.mp4 -vframes 1 -y "$CACHE_DIR/video_frame.png" >/dev/null 2>&1
    
    # Update betterlockscreen cache once
    betterlockscreen -u "$CACHE_DIR/video_frame.png" --fx blur
    
    # Mark as cached
    touch "$CACHE_FLAG"
fi

# Just lock with cached image (instant)
betterlockscreen -l blur
