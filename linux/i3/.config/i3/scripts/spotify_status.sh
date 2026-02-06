#!/bin/bash

# Get Spotify status using playerctl
if command -v playerctl &>/dev/null; then
    STATUS=$(playerctl -p spotify status 2>/dev/null)

    if [ "$STATUS" = "Playing" ] || [ "$STATUS" = "Paused" ]; then
        ARTIST=$(playerctl -p spotify metadata artist 2>/dev/null)
        TITLE=$(playerctl -p spotify metadata title 2>/dev/null)

        ARTIST_TRUNCATED="${ARTIST:0:16}"
        TITLE_TRUNCATED="${TITLE:0:32}"

        if [ -n "$ARTIST_TRUNCATED" ] && [ -n "$TITLE_TRUNCATED" ]; then
            if [ "$STATUS" = "Playing" ]; then
                if [ "${#ARTIST}" -gt 16 ] || [ "${#TITLE}" -gt 32 ]; then
                    echo "♫ $ARTIST_TRUNCATED.. - $TITLE_TRUNCATED.."
                else
                    echo "♫ $ARTIST_TRUNCATED - $TITLE_TRUNCATED"
                fi
            else
                if [ "${#ARTIST}" -gt 16 ] || [ "${#TITLE}" -gt 32 ]; then
                    echo "⏸ $ARTIST_TRUNCATED.. - $TITLE_TRUNCATED.."
                else
                    echo "⏸ $ARTIST_TRUNCATED - $TITLE_TRUNCATED"
                fi
            fi
        fi
        #
        # if [ -n "$ARTIST" ] && [ -n "$TITLE" ]; then
        #     if [ "$STATUS" = "Playing" ]; then
        #         echo "♫ $ARTIST - $TITLE"
        #     else
        #         echo "⏸ $ARTIST - $TITLE"
        #     fi
        # fi
    fi
fi
