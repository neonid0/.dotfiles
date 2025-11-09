#!/bin/bash

BT_DEVICE="XX:XX:XX:XX:XX:XX" # Replace with your device MAC
SINK_NAME="bluez_output.XX_XX_XX_XX_XX_XX.1"
# SINK_NAME="bluez_sink.XX_XX_XX_XX_XX_XX.a2dp_sink"

# Loop forever
while true; do
    # Check if any sink input is actively playing (not corked)
    if pactl list sink-inputs | grep -A10 "Sink Input" | grep -q "Corked: no"; then
        echo "[AutoBluetooth] Detected active audio stream."

        # If the sink is not yet listed, try connecting the device
        if ! pactl list sinks | grep -q "$SINK_NAME"; then
            echo "[AutoBluetooth] Connecting Bluetooth device..."
            bluetoothctl connect $BT_DEVICE
            # sleep 5 # Give time to connect
        fi

        # Set as default sink and move inputs
        pactl set-default-sink $SINK_NAME
        for INPUT in $(pactl list short sink-inputs | awk '{print $1}'); do
            pactl move-sink-input "$INPUT" $SINK_NAME
        done
    fi
    sleep 0.7
done
