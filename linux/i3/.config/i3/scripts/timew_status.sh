#!/bin/bash

# Check if Timewarrior has an active tracking session
# 'timew' returns status code 0 even if no tracking is active,
# so we grep for the 'Tracking' keyword.
ACTIVE_LINE=$(timew | grep "Tracking")

# Get today's total time tracked (last non-empty line from summary)
TODAY_TOTAL=$(timew summary :day 2>/dev/null | grep -v "^$" | tail -1 | awk '{print $NF}')
[ -z "$TODAY_TOTAL" ] && TODAY_TOTAL="0:00:00"

if [ -z "$ACTIVE_LINE" ]; then
    echo "⏸️ Idle | Today: $TODAY_TOTAL"
else
    # Extract the tag (e.g., "Feature-X") and the elapsed time
    # This logic handles multiple tags and standard timew output
    TAG=$(timew | grep "Tracking" | cut -d' ' -f2-)
    TIME=$(timew | grep "Total" | awk '{print $2}')
    echo "⏱️ $TAG ($TIME) | Today: $TODAY_TOTAL"
fi
