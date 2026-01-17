#!/bin/bash

# Dependency: timewarrior, libnotify-bin (for notify-send)

# 1. Define Constants
ICON_START="🚀"
ICON_STOP="🛑"
ICON_ERROR="⚠️"

# 2. Helper Method for Notifications
notify_user() {
    local title="$1"
    local message="$2"
    local icon="$3"
    notify-send "$icon $title" "$message" --urgency=low
}

# 3. Business Logic (The "Service" Layer)
command="$1"
shift # Remove the first argument so we can pass the rest as tags

case "$command" in
"start")
    # Tags are passed as remaining arguments
    tags="$*"
    if [ -z "$tags" ]; then
        tags="General"
    fi

    # Stop any running timer first (optional, timew handles this, but good for clarity)
    timew start "$tags"

    # specific logic: if starting a meeting, maybe set DND? (Example of extensibility)
    notify_user "Timer Started" "Tracking: $tags" "$ICON_START"
    ;;

"stop")
    # Check if actually running before stopping to avoid empty log entries
    if timew | grep -q "Tracking"; then
        last_tag=$(timew | grep "Tracking" | cut -d' ' -f2-)
        timew stop
        notify_user "Timer Stopped" "Finished: $last_tag" "$ICON_STOP"
    else
        notify_user "Error" "No active timer to stop." "$ICON_ERROR"
    fi
    ;;

"status")
    # Can be used for debugging or polybar scripts
    timew
    ;;

*)
    echo "Usage: $0 {start [tags]|stop|status}"
    exit 1
    ;;
esac
