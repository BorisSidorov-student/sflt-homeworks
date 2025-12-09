#!/bin/bash

COUNT_CPU=$(nproc)
LOAD_AVARAGE_1MIN=$(cat /proc/loadavg | cut -d' ' -f1)
CURRENT_LOAD=$(echo "scale=3; ${LOAD_AVARAGE_1MIN} / ${COUNT_CPU}" | bc -l)
PRIORITY=0
TRACK_FILE="/etc/keepalived/load_priority"


if (( $(echo "$CURRENT_LOAD >= 0.70" | bc -l) )); then PRIORITY=-50
elif (( $(echo "$CURRENT_LOAD > 0.25" | bc -l) )); then PRIORITY=-15
else PRIORITY=0
fi

echo $PRIORITY > $TRACK_FILE
echo "$PRIORITY"