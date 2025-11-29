#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Launch polybar on all monitors
for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    if [ "$m" = "DP-0" ]; then
        polybar main-dp0 2>&1 | tee -a /tmp/polybar-$m.log & disown
    elif [ "$m" = "HDMI-0" ]; then
        polybar main-hdmi0 2>&1 | tee -a /tmp/polybar-$m.log & disown
    else
        MONITOR=$m polybar main 2>&1 | tee -a /tmp/polybar-$m.log & disown
    fi
done

echo "Polybar launched on all monitors..."
