#!/bin/bash
bar_id=$(i3-msg -t get_bar_config | python3 -c "import sys,json; print(json.load(sys.stdin)[0])")
current=$(i3-msg -t get_bar_config "$bar_id" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d['mode'])")
if [ "$current" = "hide" ]; then
    i3-msg bar mode dock "$bar_id"
else
    i3-msg bar mode hide "$bar_id"
fi
