#!/bin/bash
# Script to extract Spotify artwork for fastfetch

CACHE_DIR="/home/neonid0/.cache/fastfetch"
ARTWORK_PATH="$CACHE_DIR/spotify_artwork.jpg"
METADATA_FILE="$CACHE_DIR/spotify_metadata.txt"
FALLBACK_IMAGE="/home/neonid0/.config/fastfetch/newww.jpg"

mkdir -p "$CACHE_DIR"

# Check if Spotify is running and get artwork
if command -v playerctl &>/dev/null; then
    STATUS=$(playerctl -p spotify status 2>/dev/null)
    
    if [ "$STATUS" = "Playing" ] || [ "$STATUS" = "Paused" ]; then
        ART_URL=$(playerctl -p spotify metadata mpris:artUrl 2>/dev/null)
        TRACK_ID=$(playerctl -p spotify metadata mpris:trackid 2>/dev/null)
        
        if [ -n "$ART_URL" ] && [ -n "$TRACK_ID" ]; then
            # Check if track changed
            CACHED_ID=""
            if [ -f "$METADATA_FILE" ]; then
                CACHED_ID=$(cat "$METADATA_FILE")
            fi
            
            # Download if track changed or cache doesn't exist
            if [ "$TRACK_ID" != "$CACHED_ID" ] || [ ! -f "$ARTWORK_PATH" ]; then
                curl -s -o "$ARTWORK_PATH.tmp" "$ART_URL"
                
                if [ -s "$ARTWORK_PATH.tmp" ]; then
                    mv "$ARTWORK_PATH.tmp" "$ARTWORK_PATH"
                    echo "$TRACK_ID" > "$METADATA_FILE"
                    
                    # Clean old kitty cache for this path
                    rm -rf "$CACHE_DIR/images/home/neonid0/.cache/fastfetch/spotify_artwork.jpg" 2>/dev/null
                else
                    rm -f "$ARTWORK_PATH.tmp"
                fi
            fi
            
            [ -f "$ARTWORK_PATH" ] && echo "$ARTWORK_PATH" && exit 0
        fi
    fi
fi

# Fallback to default image
echo "$FALLBACK_IMAGE"
