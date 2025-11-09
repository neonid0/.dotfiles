#!/bin/bash
scrot /tmp/lockscreen.png
convert /tmp/lockscreen.png -blur 10x5 /tmp/lockscreen.png
i3lock \
    -i /tmp/lockscreen.png \
    --clock \
    --time-str="%H:%M:%S" \
    --date-str="%A, %d %B" \
    --time-color=ffffffff \
    --date-color=ccccccff \
    --layout-color=ccccccff \
    --inside-color=00000000 \
    --ring-color=00000000 \
    --line-color=00000000 \
    --separator-color=00000000 \
    --verif-color=f2f2f2f2 \
    --wrong-color=f2f2f2f2 \
    --radius=1 \
    --ring-width=1

rm /tmp/lockscreen.png
