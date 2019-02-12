#!/bin/sh

LEMONBAR=$(which lemonbar)
SCRIPT=/home/ssynx/.config/bspwm/populate_bar.py

while true; do
    $SCRIPT | $LEMONBAR -B "#2C2C2C" -f "monospace:size=10:antialias=true"
    echo -e "$SCRIPT crashed, restarting in 3 secs..." | $LEMONBAR -B "#2C2C2C" -f "monospace:size=10:antialias=true" -p &
    sleep 3
    killall lemonbar
done
