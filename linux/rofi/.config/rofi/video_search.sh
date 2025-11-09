#!/bin/bash

video=$(find ~/Videos -type f \( -iname "*.mp4" -o -iname "*.mkv" -o -iname "*.webm" \) | rofi -dmenu -i -p "Play video")
[ -z "$video" ] && exit 1

subtitle_zip=$(find ~/Videos -type f -iname "*.zip" | rofi -dmenu -i -p "Select ZIP with subtitle (optional)")
tempdir=$(mktemp -d)

if [ -n "$subtitle_zip" ]; then
    unzip -j "$subtitle_zip" '*.srt' -d "$tempdir" >/dev/null 2>&1
    subtitle=$(find "$tempdir" -type f -iname "*.srt" | rofi -dmenu -i -p "Choose extracted subtitle (optional)")
fi

[ -n "$subtitle" ] && mpv --sub-file="$subtitle" "$video" || mpv "$video"
