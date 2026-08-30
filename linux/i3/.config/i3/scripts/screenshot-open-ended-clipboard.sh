#!/usr/bin/env bash
set -euo pipefail

tmp_image="/tmp/open-ended-question-$(date +%Y-%m-%d_%H-%M-%S).png"
tmp_error="/tmp/open-ended-solver-error.log"

cleanup() {
    rm -f "$tmp_image"
}
trap cleanup EXIT

maim --select "$tmp_image"

if [ ! -s "$tmp_image" ]; then
    exit 0
fi

PROMPT='You are solving an open-ended Cisco network security exam question from the attached screenshot.

Return only the final answer text that should be written in the exam answer box.
Do not include explanations, headers, labels, bullet points, or any extra text.
If the screenshot is unreadable, output exactly: unreadable
Note:Your output should be concise and to the point, providing only the necessary information for the answer.'

answer=$(copilot -p "$PROMPT" \
    --attachment "$tmp_image" \
    --model auto \
    --allow-all-tools \
    --no-color \
    -s 2>"$tmp_error")

answer="$(
    printf '%s\n' "$answer" | sed -E \
        -e 's/\r$//' \
        -e '/^[[:space:]]*```[[:alnum:]]*[[:space:]]*$/d' \
        -e 's/^[[:space:]]*(final[[:space:]]+)?answer[[:space:]]*:[[:space:]]*//I' \
        -e '/^[[:space:]]*$/d'
)"

if [ -z "$answer" ]; then
    if command -v notify-send &>/dev/null; then
        notify-send "Instagram" "Harun Gezer: hayir" -u critical -t 5000
    fi
    exit 1
fi

printf '%s' "$answer" | xclip -selection clipboard

if command -v notify-send &>/dev/null; then
    notify-send " " " " -u normal -t 1000
fi

echo "$answer"
