#!/usr/bin/env bash
until i3-msg > /dev/null 2>&1; do
    sleep 0.5
done
sleep 0.5
pkill -x polybar
polybar main 2>&1 | tee -a /tmp/polybar.log & disown
