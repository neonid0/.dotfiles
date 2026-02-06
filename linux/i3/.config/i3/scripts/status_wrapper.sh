#!/bin/bash

# Track if we've seen the first data line
FIRST_LINE=1

# Pipe i3status output and inject Timewarrior data
i3status -c ~/.config/i3status/config | while :; do
    read line
    # Pass through the header and opening bracket unchanged
    if [[ "$line" == "{"*"version"* ]] || [[ "$line" == "[" ]]; then
        echo "$line"
        continue
    fi

    # Get the Timewarrior status from our script
    TIMEW=$(~/.config/i3/scripts/timew_status.sh)

    # Get the Spotify status
    SPOTIFY=$(~/.config/i3/scripts/spotify_status.sh)

    # Use jq to properly construct JSON with escaped text
    # Remove leading comma if present, then use jq to inject our custom block
    LINE_CLEAN=$(echo "$line" | sed 's/^,//')

    if [ "$FIRST_LINE" -eq 1 ]; then
        # First data line - no leading comma
        if [ -n "$SPOTIFY" ]; then
            echo "$LINE_CLEAN" | jq -c --arg timew "$TIMEW" --arg spotify "$SPOTIFY" '. = [{full_text: $timew, color: "#fadb2f"}, {full_text: $spotify, color: "#1db954"}] + .'
        else
            echo "$LINE_CLEAN" | jq -c --arg timew "$TIMEW" '. = [{full_text: $timew, color: "#fadb2f"}] + .'
        fi
        FIRST_LINE=0
    else
        # Subsequent lines - add leading comma
        if [ -n "$SPOTIFY" ]; then
            echo "$LINE_CLEAN" | jq -c --arg timew "$TIMEW" --arg spotify "$SPOTIFY" '. = [{full_text: $timew, color: "#fadb2f"}, {full_text: $spotify, color: "#1db954"}] + .' | sed 's/^/,/'
        else
            echo "$LINE_CLEAN" | jq -c --arg timew "$TIMEW" '. = [{full_text: $timew, color: "#fadb2f"}] + .' | sed 's/^/,/'
        fi
    fi
done
