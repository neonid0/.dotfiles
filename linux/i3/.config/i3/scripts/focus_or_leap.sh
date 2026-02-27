#!/bin/bash
# focus_or_leap.sh
# Usage: focus_or_leap.sh <direction> <key>
#   direction: left|right|up|down
#   key:       h|j|k|l
#
# When Input Leap integration is enabled (flag file exists):
#   - Tries to move i3 focus in the given direction.
#   - If the focused window didn't change (edge of screen), sends Alt+<key>
#     instead, which Input Leap uses to switch machines.

DIRECTION=$1
KEY=$2
FLAG_FILE="/tmp/i3_leap_enabled"
LOG="/tmp/focus_or_leap.log"
exec >> "$LOG" 2>&1
echo "=== $(date) dir=$DIRECTION key=$KEY ==="

# If leap integration is disabled, just do normal i3 focus
if [ ! -f "$FLAG_FILE" ]; then
    i3-msg focus "$DIRECTION"
    exit 0
fi

get_focused_id() {
    i3-msg -t get_tree | python3 -c "
import json, sys
def find_focused(node):
    if node.get('focused'):
        return node['id']
    for child in node.get('nodes', []) + node.get('floating_nodes', []):
        r = find_focused(child)
        if r is not None:
            return r
    return None
print(find_focused(json.load(sys.stdin)))
"
}

BEFORE=$(get_focused_id)
echo "BEFORE=$BEFORE"
i3-msg focus "$DIRECTION" > /dev/null 2>&1
AFTER=$(get_focused_id)
echo "AFTER=$AFTER"

# If focus didn't move, hand off to Input Leap
if [ "$BEFORE" = "$AFTER" ]; then
    echo "EDGE DETECTED → xdotool key --clearmodifiers alt+$KEY"
    sleep 0.1
    xdotool key --clearmodifiers "alt+$KEY"
    echo "xdotool exit: $?"
fi
