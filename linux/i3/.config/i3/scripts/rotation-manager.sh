#!/bin/bash

# Display Rotation Manager for i3
# Manages rotation settings for individual displays

# Function to detect available UI tool
get_ui_tool() {
    if command -v rofi &>/dev/null; then
        echo "rofi"
    elif command -v dmenu &>/dev/null; then
        echo "dmenu"
    elif command -v zenity &>/dev/null; then
        echo "zenity"
    else
        echo "none"
    fi
}

# Function to show menu and get selection
show_menu() {
    local ui_tool="$1"
    local prompt="$2"
    shift 2
    local options=("$@")

    case "$ui_tool" in
        rofi)
            printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "$prompt"
            ;;
        dmenu)
            printf '%s\n' "${options[@]}" | dmenu -i -p "$prompt:"
            ;;
        zenity)
            zenity --list --title="$prompt" --column="Option" "${options[@]}"
            ;;
        *)
            echo "Error: No UI tool found. Please install rofi, dmenu, or zenity." >&2
            exit 1
            ;;
    esac
}

# Get list of connected displays
get_connected_displays() {
    xrandr | grep " connected" | awk '{print $1}'
}

# Get current rotation of a display
get_current_rotation() {
    local display="$1"
    local rotation=$(xrandr | grep "^$display connected" | grep -oP '(normal|left|right|inverted)' | head -1)
    if [ -z "$rotation" ]; then
        rotation="normal"
    fi
    echo "$rotation"
}

# Apply rotation to a display
apply_rotation() {
    local display="$1"
    local rotation="$2"
    xrandr --output "$display" --rotate "$rotation"
}

# Main script
UI_TOOL=$(get_ui_tool)

# Step 1: Select display
DISPLAYS=($(get_connected_displays))

if [ ${#DISPLAYS[@]} -eq 0 ]; then
    echo "No displays connected!"
    exit 1
fi

if [ ${#DISPLAYS[@]} -eq 1 ]; then
    SELECTED_DISPLAY="${DISPLAYS[0]}"
else
    # Add display info to selection
    DISPLAY_OPTIONS=()
    for display in "${DISPLAYS[@]}"; do
        current_rot=$(get_current_rotation "$display")
        DISPLAY_OPTIONS+=("$display (current: $current_rot)")
    done

    DISPLAY_SELECTION=$(show_menu "$UI_TOOL" "Select Display" "${DISPLAY_OPTIONS[@]}")

    if [ -z "$DISPLAY_SELECTION" ]; then
        echo "No display selected. Exiting."
        exit 0
    fi

    # Extract display name (remove the current rotation info)
    SELECTED_DISPLAY=$(echo "$DISPLAY_SELECTION" | awk '{print $1}')
fi

# Step 2: Select rotation
CURRENT_ROTATION=$(get_current_rotation "$SELECTED_DISPLAY")

ROTATION_OPTIONS=(
    "normal"
    "left (90° counter-clockwise)"
    "right (90° clockwise)"
    "inverted (180°)"
)

ROTATION_SELECTION=$(show_menu "$UI_TOOL" "Rotate $SELECTED_DISPLAY" "${ROTATION_OPTIONS[@]}")

if [ -z "$ROTATION_SELECTION" ]; then
    echo "No rotation selected. Exiting."
    exit 0
fi

# Extract rotation value
SELECTED_ROTATION=$(echo "$ROTATION_SELECTION" | awk '{print $1}')

# Apply the rotation
apply_rotation "$SELECTED_DISPLAY" "$SELECTED_ROTATION"

echo "Applied rotation '$SELECTED_ROTATION' to display '$SELECTED_DISPLAY'"

# Optional: Show notification if notify-send is available
if command -v notify-send &>/dev/null; then
    notify-send "Display Rotation" "Rotated $SELECTED_DISPLAY to $SELECTED_ROTATION"
fi
