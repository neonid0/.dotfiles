#!/usr/bin/env bash
set -euo pipefail

image_path="${1:-}"

if [ -z "$image_path" ] || [ ! -s "$image_path" ]; then
    echo "Usage: solve-question.sh <image_path>" >&2
    exit 1
fi

PROMPT='You are solving a Cisco network security exam question from the attached screenshot.

Return ONLY the final answer. No explanation, no reasoning, no labels, no extra text.

Rules:
1) Single-select or multi-select:
   - Number options from top to bottom starting at 1.
   - Output only selected number(s).
   - For multiple answers, use comma + space.
   - Examples: 2   |   1, 3, 4

2) Matching:
   - Map left letters to right row numbers.
   - Use exactly this style: a -> 2, b -> 5, c -> 1
   - Keep left-side letters in order.

If unreadable, output exactly: unreadable'

answer=$(copilot -p "$PROMPT" \
    --attachment "$image_path" \
    --model auto \
    --allow-all-tools \
    --no-color \
    -s 2>/tmp/solve-question-error.log)
status=$?

if [ $status -ne 0 ]; then
    cat /tmp/solve-question-error.log >&2 || true
    exit 1
fi

answer="$(printf '%s' "$answer" | sed '/^[[:space:]]*$/d')"

if [ -z "$answer" ]; then
    echo "empty answer" >&2
    exit 1
fi

# Show notification with final answer
if command -v notify-send &>/dev/null; then
    notify-send " " "$answer" -u normal -t 1000
fi

echo "$answer"
