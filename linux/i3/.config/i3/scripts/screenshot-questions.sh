#!/usr/bin/env bash
set -euo pipefail

target_dir="/home/neonid0/Documents/projects/thm/network/questions"
mkdir -p "$target_dir"

output_file="$target_dir/$(date +%Y-%m-%d_%H-%M-%S).png"
maim --select "$output_file"

# Bail out if the selection was cancelled (no/empty file captured)
if [ ! -s "$output_file" ]; then
    exit 0
fi

# Solve in the background so the hotkey returns immediately
~/.config/i3/scripts/solve-question.sh "$output_file" &
disown
