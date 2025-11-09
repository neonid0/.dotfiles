#!/bin/bash

DIR="$HOME/.tmux/resurrect"
cd "$DIR" || {
    echo "❌ Folder $DIR not found"
    exit 1
}

# Show only files except 'last', pick one via fzf
CHOSEN=$(ls "$DIR" | grep -v '^last$' | fzf)

# If a file was selected, copy it to 'last'
if [ -n "$CHOSEN" ]; then
    cp "$CHOSEN" last
    notify-send "✅ Restore complete" "Copied $CHOSEN → last"
else
    notify-send "❌ Cancelled" "No file selected"
fi
