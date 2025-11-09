#!/bin/bash
logfile="/tmp/i3-workspace-assign.log"
echo "$(date): Running workspace assign" >>"$logfile"
xrandr_output=$(xrandr)
echo "$xrandr_output" >>"$logfile"

if echo "$xrandr_output" | grep -q "^DP-0 connected"; then
    echo "DP-0 connected" >>"$logfile"
    i3-msg "workspace 10; move workspace to output DP-0"
    i3-msg "workspace 9; move workspace to output DP-0"
    i3-msg "workspace 8; move workspace to output DP-2"
    i3-msg "workspace 7; move workspace to output DP-2"
    i3-msg "workspace 6; move workspace to output DP-0"
    i3-msg "workspace 5; move workspace to output DP-0"
    i3-msg "workspace 4; move workspace to output DP-0"
    i3-msg "workspace 3; move workspace to output DP-2"
    i3-msg "workspace 2; move workspace to output DP-2"
    i3-msg "workspace 1; move workspace to output DP-2"
    # else
    # echo "DP-0 NOT connected" >>"$logfile"
    # for ws in 1 2 3 4 5 6 7 8 9 0; do
    #     i3-msg "workspace $ws; move workspace to output DP-2"
    # done
fi
