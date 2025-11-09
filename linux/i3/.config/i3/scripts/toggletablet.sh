#!/bin/bash

DEVICE="Your device name here from xinput list"
MONITOR1="DP-0"
MONITOR2="DP-2"

MATRIX=$(xinput --list-props "$DEVICE" | grep "Coordinate Transformation Matrix" | awk -F: '{ print $2 }')
THIRD=$(echo "$MATRIX" | awk '{print $3}')

echo "MATRIX: $MATRIX"
echo "THIRD: $THIRD"

if [ "$THIRD" = "0.500000," ]; then
    xinput map-to-output "$DEVICE" "$MONITOR2"
else
    xinput map-to-output "$DEVICE" "$MONITOR1"
fi
