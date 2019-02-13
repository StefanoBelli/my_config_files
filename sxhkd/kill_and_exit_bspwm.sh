#!/bin/sh

LEMONBAR_LAUNCHER_PID=$(pidof -x lemonbar_launcher.sh)
TO_KILL_BEFORE="lemonbar populate_bar.py xidlehook"

for pid in $LEMONBAR_LAUNCHER_PID; do
    kill $pid
done

for i in $TO_KILL_BEFORE; do
    killall $i
done

bspc quit
