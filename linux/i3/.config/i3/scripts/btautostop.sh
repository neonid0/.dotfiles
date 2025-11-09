#!/bin/bash

BT_DEVICE="XX:XX:XX:XX:XX:XX"
STOPPED=false

while true; do
    if bluetoothctl info "$BT_DEVICE" | grep -q "Connected: yes"; then
        echo "Bluetooth device is connected, starting media players..."

        # Start mpv if not running
        # if ! pgrep -x "mpv" >/dev/null; then
        #     mpv --no-terminal --no-audio-display --loop-file=~/Music/playlist.m3u &
        # fi

        # Play Spotify, VLC, Firefox if not playing
        # playerctl --player=spotify play 2>/dev/null
        # playerctl --player=vlc play 2>/dev/null
        # playerctl --player=firefox play 2>/dev/null
        STOPPED=false
    else
        if [ "$STOPPED" = false ]; then
            echo "Bluetooth device disconnected, stopping media players..."

            # Stop mpv if running
            pkill mpv

            # Pause Spotify, VLC, Firefox
            playerctl --player=spotify pause 2>/dev/null
            playerctl --player=vlc pause 2>/dev/null
            playerctl --player=firefox pause 2>/dev/null
            STOPPED=true
        fi
    fi
    sleep 0.1
done
