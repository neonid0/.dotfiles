#!/bin/bash
if xrandr | grep -q "^DP-0 connected"; then
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 \
        --output DP-0 --mode 1920x1080 --pos 1920x0 --right-of DP-2
else
    xrandr --output DP-2 --primary --mode 1920x1080 --pos 0x0 --output DP-0 --off
fi
