#!/bin/bash

# Display Configuration Selector for i3
# Manages multiple display configurations with position and rotation variants

# Workspace assignment functions
assign_workspaces_single() {
    # Single monitor: all workspaces on DP-2
    for ws in 1 2 3 4 5 6 7 8 9 10; do
        i3-msg "workspace number $ws; move workspace to output DP-2"
    done
}

assign_workspaces_dual() {
    # Dual monitor: 1,2,3,7,8 on DP-2; 4,5,6,9,10 on DP-0
    i3-msg "workspace number 1; move workspace to output DP-2"
    i3-msg "workspace number 2; move workspace to output DP-2"
    i3-msg "workspace number 3; move workspace to output DP-2"
    i3-msg "workspace number 4; move workspace to output DP-0"
    i3-msg "workspace number 5; move workspace to output DP-0"
    i3-msg "workspace number 6; move workspace to output DP-0"
    i3-msg "workspace number 7; move workspace to output DP-2"
    i3-msg "workspace number 8; move workspace to output DP-2"
    i3-msg "workspace number 9; move workspace to output DP-0"
    i3-msg "workspace number 10; move workspace to output DP-0"
}

assign_workspaces_triple() {
    # Triple monitor: 1-3 on DP-2, 4-6 on DP-0, 7-9 on HDMI-0, 10 on DP-2
    # Use single i3-msg commands with semicolon to ensure atomic operations
    i3-msg "workspace number 1; move workspace to output DP-2"
    i3-msg "workspace number 2; move workspace to output DP-2"
    i3-msg "workspace number 3; move workspace to output DP-2"
    i3-msg "workspace number 4; move workspace to output DP-0"
    i3-msg "workspace number 5; move workspace to output DP-0"
    i3-msg "workspace number 6; move workspace to output DP-0"
    i3-msg "workspace number 7; move workspace to output HDMI-0"
    i3-msg "workspace number 8; move workspace to output HDMI-0"
    i3-msg "workspace number 9; move workspace to output HDMI-0"
    i3-msg "workspace number 10; move workspace to output DP-2"
    # Return to workspace 1
    i3-msg "workspace number 1"
}

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
    shift
    local options=("$@")

    case "$ui_tool" in
        rofi)
            printf '%s\n' "${options[@]}" | rofi -dmenu -i -p "Display Configuration"
            ;;
        dmenu)
            printf '%s\n' "${options[@]}" | dmenu -i -p "Display Configuration:"
            ;;
        zenity)
            zenity --list --title="Display Configuration" --column="Configuration" "${options[@]}"
            ;;
        *)
            echo "Error: No UI tool found. Please install rofi, dmenu, or zenity." >&2
            exit 1
            ;;
    esac
}

# Display configuration functions
config_single_dp2() {
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --off \
           --output HDMI-0 --off
}

config_ultrawide_dp0_only() {
    # Ultrawide monitor 3440x1440 on DP-0 only (34" UW-QHD)
    xrandr --output DP-0 --primary --mode 3440x1440 --pos 0x0 --rotate normal \
           --output DP-2 --off \
           --output HDMI-0 --off
}

config_dual_dp2_left() {
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output HDMI-0 --off
}

config_dual_dp2_right() {
    xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output HDMI-0 --off
}

config_dual_dp0_rotated_left() {
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate left \
           --output HDMI-0 --off
}

config_dual_dp0_rotated_right() {
    xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --rotate left \
           --output DP-2 --primary --mode 1920x1080 --pos 1080x0 --rotate normal \
           --output HDMI-0 --off
}

config_dual_vertical_stack() {
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 0x1080 --rotate normal \
           --output HDMI-0 --off
}

config_dual_dp2_hdmi_mirror() {
    # DP-2 and HDMI-0 mirrored (same content on both)
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal --same-as DP-2 \
           --output DP-0 --off
}

config_triple_presentation_mirror() {
    # HDMI-0 mirrors DP-0 for presentation
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output HDMI-0 --mode 1920x1080 --pos 1920x0 --same-as DP-0
}

config_triple_separate_hdmi_extend_right() {
    # HDMI-0 as separate monitor extending to the right
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output HDMI-0 --mode 1920x1080 --pos 3840x0 --rotate normal
}

config_triple_separate_hdmi_top() {
    # HDMI-0 as separate monitor on top
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x1080 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 1920x1080 --rotate normal \
           --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal
}

config_triple_separate_hdmi_middle() {
    # HDMI-0 in the middle
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 3840x0 --rotate normal
}

config_triple_dp0_rotated() {
    # DP-0 rotated left, HDMI-0 as separate monitor
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate left \
           --output HDMI-0 --mode 1920x1080 --pos 3000x0 --rotate normal
}

# Additional horizontal arrangements
config_triple_dp0_dp2_hdmi() {
    # DP-0 (left), DP-2 (middle), HDMI-0 (right)
    xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output HDMI-0 --mode 1920x1080 --pos 3840x0 --rotate normal
}

config_triple_dp0_hdmi_dp2() {
    # DP-0 (left), HDMI-0 (middle), DP-2 (right)
    xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --rotate normal \
           --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output DP-2 --primary --mode 1920x1080 --pos 3840x0 --rotate normal
}

config_triple_hdmi_dp2_dp0() {
    # HDMI-0 (left), DP-2 (middle), DP-0 (right)
    xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 3840x0 --rotate normal
}

config_triple_hdmi_dp0_dp2() {
    # HDMI-0 (left), DP-0 (middle), DP-2 (right)
    xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output DP-2 --primary --mode 1920x1080 --pos 3840x0 --rotate normal
}

# Configurations with rotated displays (DP-0 rotated = 1080 width instead of 1920)
config_triple_dp0rot_dp2_hdmi() {
    # DP-0 rotated (left), DP-2 (middle), HDMI-0 (right)
    xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --rotate left \
           --output DP-2 --primary --mode 1920x1080 --pos 1080x0 --rotate normal \
           --output HDMI-0 --mode 1920x1080 --pos 3000x0 --rotate normal
}

config_triple_dp2_dp0rot_hdmi() {
    # DP-2 (left), DP-0 rotated (middle), HDMI-0 (right)
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate left \
           --output HDMI-0 --mode 1920x1080 --pos 3000x0 --rotate normal
}

config_triple_dp2_hdmi_dp0rot() {
    # DP-2 (left), HDMI-0 (middle), DP-0 rotated (right)
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --rotate normal \
           --output HDMI-0 --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 3840x0 --rotate left
}

config_triple_hdmi_dp0rot_dp2() {
    # HDMI-0 (left), DP-0 rotated (middle), DP-2 (right)
    xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 1920x0 --rotate left \
           --output DP-2 --primary --mode 1920x1080 --pos 3000x0 --rotate normal
}

config_triple_hdmi_dp2_dp0rot() {
    # HDMI-0 (left), DP-2 (middle), DP-0 rotated (right)
    xrandr --output HDMI-0 --mode 1920x1080 --pos 0x0 --rotate normal \
           --output DP-2 --primary --mode 1920x1080 --pos 1920x0 --rotate normal \
           --output DP-0 --mode 1920x1080 --pos 3840x0 --rotate left
}

config_triple_dp0rot_hdmi_dp2() {
    # DP-0 rotated (left), HDMI-0 (middle), DP-2 (right)
    xrandr --output DP-0 --mode 1920x1080 --pos 0x0 --rotate left \
           --output HDMI-0 --mode 1920x1080 --pos 1080x0 --rotate normal \
           --output DP-2 --primary --mode 1920x1080 --pos 3000x0 --rotate normal
}

# Main menu options
OPTIONS=(
    "1. Single Monitor (DP-2 only)"
    "2. Dual: DP-2 (left) + DP-0 (right)"
    "3. Dual: DP-0 (left) + DP-2 (right)"
    "4. Dual: DP-2 (left) + DP-0 rotated left (right)"
    "5. Dual: DP-0 rotated left (left) + DP-2 (right)"
    "6. Dual: DP-2 (top) + DP-0 (bottom) - Vertical"
    "7. Dual: DP-2 + HDMI-0 (mirrored)"
    "8. Triple: DP-2 + DP-0 + HDMI-0 (mirror DP-0 - presentation)"
    "9. Triple: DP-2 + DP-0 + HDMI-0"
    "10. Triple: DP-2 + HDMI-0 + DP-0"
    "11. Triple: DP-0 + DP-2 + HDMI-0"
    "12. Triple: DP-0 + HDMI-0 + DP-2"
    "13. Triple: HDMI-0 + DP-2 + DP-0"
    "14. Triple: HDMI-0 + DP-0 + DP-2"
    "15. Triple: HDMI-0 (top) + DP-2 + DP-0 (bottom)"
    "16. Triple Rotated: DP-0↻ + DP-2 + HDMI-0"
    "17. Triple Rotated: DP-2 + DP-0↻ + HDMI-0"
    "18. Triple Rotated: DP-2 + HDMI-0 + DP-0↻"
    "19. Triple Rotated: DP-0↻ + HDMI-0 + DP-2"
    "20. Triple Rotated: HDMI-0 + DP-0↻ + DP-2"
    "21. Triple Rotated: HDMI-0 + DP-2 + DP-0↻"
    "22. Ultrawide: 34\" 3440x1440 (DP-0 only)"
)

UI_TOOL=$(get_ui_tool)
SELECTION=$(show_menu "$UI_TOOL" "${OPTIONS[@]}")

if [ -z "$SELECTION" ]; then
    echo "No selection made. Exiting."
    exit 0
fi

# Execute selected configuration
case "$SELECTION" in
    "1. Single Monitor (DP-2 only)")
        config_single_dp2
        ;;
    "2. Dual: DP-2 (left) + DP-0 (right)")
        config_dual_dp2_left
        ;;
    "3. Dual: DP-0 (left) + DP-2 (right)")
        config_dual_dp2_right
        ;;
    "4. Dual: DP-2 (left) + DP-0 rotated left (right)")
        config_dual_dp0_rotated_left
        ;;
    "5. Dual: DP-0 rotated left (left) + DP-2 (right)")
        config_dual_dp0_rotated_right
        ;;
    "6. Dual: DP-2 (top) + DP-0 (bottom) - Vertical")
        config_dual_vertical_stack
        ;;
    "7. Dual: DP-2 + HDMI-0 (mirrored)")
        config_dual_dp2_hdmi_mirror
        ;;
    "8. Triple: DP-2 + DP-0 + HDMI-0 (mirror DP-0 - presentation)")
        config_triple_presentation_mirror
        ;;
    "9. Triple: DP-2 + DP-0 + HDMI-0")
        config_triple_separate_hdmi_extend_right
        ;;
    "10. Triple: DP-2 + HDMI-0 + DP-0")
        config_triple_separate_hdmi_middle
        ;;
    "11. Triple: DP-0 + DP-2 + HDMI-0")
        config_triple_dp0_dp2_hdmi
        ;;
    "12. Triple: DP-0 + HDMI-0 + DP-2")
        config_triple_dp0_hdmi_dp2
        ;;
    "13. Triple: HDMI-0 + DP-2 + DP-0")
        config_triple_hdmi_dp2_dp0
        ;;
    "14. Triple: HDMI-0 + DP-0 + DP-2")
        config_triple_hdmi_dp0_dp2
        ;;
    "15. Triple: HDMI-0 (top) + DP-2 + DP-0 (bottom)")
        config_triple_separate_hdmi_top
        ;;
    "16. Triple Rotated: DP-0↻ + DP-2 + HDMI-0")
        config_triple_dp0rot_dp2_hdmi
        ;;
    "17. Triple Rotated: DP-2 + DP-0↻ + HDMI-0")
        config_triple_dp2_dp0rot_hdmi
        ;;
    "18. Triple Rotated: DP-2 + HDMI-0 + DP-0↻")
        config_triple_dp2_hdmi_dp0rot
        ;;
    "19. Triple Rotated: DP-0↻ + HDMI-0 + DP-2")
        config_triple_dp0rot_hdmi_dp2
        ;;
    "20. Triple Rotated: HDMI-0 + DP-0↻ + DP-2")
        config_triple_hdmi_dp0rot_dp2
        ;;
    "21. Triple Rotated: HDMI-0 + DP-2 + DP-0↻")
        config_triple_hdmi_dp2_dp0rot
        ;;
    "22. Ultrawide: 34\" 3440x1440 (DP-0 only)")
        config_ultrawide_dp0_only
        ;;
    *)
        echo "Invalid selection: $SELECTION"
        exit 1
        ;;
esac

echo "Display configuration applied: $SELECTION"

# Ask whether to keep laptop running when lid is closed (while external monitor is connected)
ask_yes_no() {
    local ui_tool="$1"
    local prompt="$2"
    case "$ui_tool" in
        rofi)
            printf '%s
' "Yes" "No" | rofi -dmenu -i -p "$prompt"
            ;;
        dmenu)
            printf '%s
' "Yes" "No" | dmenu -i -p "$prompt"
            ;;
        zenity)
            # zenity returns 0 on yes, 1 on no
            if zenity --question --text="$prompt" --no-wrap; then
                echo "Yes"
            else
                echo "No"
            fi
            ;;
        *)
            # Fallback to No
            echo "No"
            ;;
    esac
}

# Assign workspaces based on configuration type
case "$SELECTION" in
    "1. Single Monitor (DP-2 only)")
        assign_workspaces_single
        WORKSPACE_CONFIG="Single monitor"
        ;;
    "2. Dual: DP-2 (left) + DP-0 (right)" | \
    "3. Dual: DP-0 (left) + DP-2 (right)" | \
    "4. Dual: DP-2 (left) + DP-0 rotated left (right)" | \
    "5. Dual: DP-0 rotated left (left) + DP-2 (right)" | \
    "6. Dual: DP-2 (top) + DP-0 (bottom) - Vertical" | \
    "7. Dual: DP-2 + HDMI-0 (mirrored)")
        assign_workspaces_dual
        WORKSPACE_CONFIG="Dual monitor"
        ;;
    *)
        # All triple monitor configurations
        assign_workspaces_triple
        WORKSPACE_CONFIG="Triple monitor"
        ;;
esac

# Wait for workspace moves to complete
sleep 0.5

echo "Workspaces assigned successfully"

# After applying the chosen configuration, ask whether to keep laptop running when lid closes
LID_ACTION=$(ask_yes_no "$UI_TOOL" "Keep laptop running when lid is closed and use external monitor only?")

if [ "$LID_ACTION" = "Yes" ] || [ "$LID_ACTION" = "yes" ]; then
    # Detect all connected external outputs (exclude DP-2 which is laptop internal)
    mapfile -t EXTERNAL_OUTS < <(xrandr --query | awk '/ connected/ {print $1}' | grep -v '^DP-2$' || true)

    if [ "${#EXTERNAL_OUTS[@]}" -gt 0 ]; then
        # Enable each external output with its preferred/auto mode
        for out in "${EXTERNAL_OUTS[@]}"; do
            xrandr --output "$out" --auto 2>/dev/null || true
        done
        # Make the first external primary
        xrandr --output "${EXTERNAL_OUTS[0]}" --primary 2>/dev/null || true
        # Turn off laptop internal display DP-2
        xrandr --output DP-2 --off 2>/dev/null || true
    else
        if command -v notify-send &>/dev/null; then
            notify-send "Lid behavior" "No external monitors detected — cannot switch to external-only." -u normal
        else
            echo "No external monitors detected — cannot switch to external-only."
        fi
    fi

    # Try to prevent suspend on lid close for the current session using systemd-inhibit
    if command -v systemd-inhibit &>/dev/null; then
        # Start an inhibitor in background and store PID for later cleanup
        systemd-inhibit --what=handle-lid-switch --why="External monitor connected" sleep infinity &
        INHIBIT_PID=$!
        mkdir -p "$HOME/.config/i3"
        echo "$INHIBIT_PID" > "$HOME/.config/i3/keep_lid_open.pid"
        if command -v notify-send &>/dev/null; then
            notify-send "Lid behavior" "Laptop will stay awake while lid is closed (inhibitor running)." -u low
        else
            echo "Laptop will stay awake while lid is closed (inhibitor running)."
        fi
    else
        echo "systemd-inhibit not available; cannot programmatically prevent suspend."
        if command -v notify-send &>/dev/null; then
            notify-send "Lid behavior" "systemd-inhibit not available — update /etc/systemd/logind.conf to ignore lid switch when docked." -u normal
        fi
    fi
else
    # User chose default behavior (suspend on lid close)
    if command -v notify-send &>/dev/null; then
        notify-send "Lid behavior" "Default lid-close behavior preserved (suspend)." -u low
    fi
fi

# Show notification summarizing the applied configuration and workspace layout
if command -v notify-send &>/dev/null; then
    notify-send "Display Configuration" "$WORKSPACE_CONFIG setup applied\nWorkspaces reassigned" -u low
else
    echo "Display Configuration: $WORKSPACE_CONFIG setup applied — Workspaces reassigned"
fi
