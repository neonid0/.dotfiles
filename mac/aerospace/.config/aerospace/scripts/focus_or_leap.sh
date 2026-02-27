#!/bin/bash
# focus_or_leap.sh
# Usage: focus_or_leap.sh <direction> <key>
#   direction: left|right|up|down
#   key:       h|j|k|l
#
# When Input Leap integration is enabled (flag file exists):
#   - Tries to move Aerospace focus in the given direction.
#   - If the focused window didn't change (edge of screen), sends Cmd+<key>
#     via CGEventTap which Input Leap uses to switch machines.

DIRECTION=$1
KEY=$2
FLAG_FILE="/tmp/aerospace_leap_enabled"
LOG="/tmp/focus_or_leap.log"
SEND_KEY="$HOME/.config/aerospace/scripts/send_key"
CMD_MOD=1048576

# key -> macOS keycode mapping
declare -A KEYCODES
KEYCODES[h]=4
KEYCODES[j]=38
KEYCODES[k]=40
KEYCODES[l]=37

exec >> "$LOG" 2>&1
echo "=== $(date) dir=$DIRECTION key=$KEY ==="

get_focused_id() {
    aerospace list-windows --focused 2>/dev/null | awk '{print $1}'
}

# If leap integration is disabled, just do normal aerospace focus
if [ ! -f "$FLAG_FILE" ]; then
    aerospace focus --boundaries-action stop "$DIRECTION"
    exit 0
fi

BEFORE=$(get_focused_id)
echo "BEFORE=$BEFORE"

aerospace focus --boundaries-action stop "$DIRECTION" > /dev/null 2>&1

AFTER=$(get_focused_id)
echo "AFTER=$AFTER"

if [ "$BEFORE" = "$AFTER" ]; then
    KEYCODE=${KEYCODES[$KEY]}
    echo "EDGE DETECTED → send_key $KEYCODE $CMD_MOD (Cmd+$KEY)"
    sleep 0.1
    "$SEND_KEY" "$KEYCODE" "$CMD_MOD"
    echo "send_key exit: $?"
fi
