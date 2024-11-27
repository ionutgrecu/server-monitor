#!/bin/bash

cd "$(dirname "$0")"
source .env

TIMESTAMP_FILE="/tmp/.last_run_timestamp"
FORCE_RUN=false

while [[ "$#" -gt 0 ]]; do
    case $1 in
        --force) FORCE_RUN=true ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ "$FORCE_RUN" = false ]; then
    if [ -f "$TIMESTAMP_FILE" ]; then
        LAST_RUN=$(cat "$TIMESTAMP_FILE")
        CURRENT_TIME=$(date +%s)
        TIME_DIFF=$((CURRENT_TIME - LAST_RUN))
        
        if [ $TIME_DIFF -lt 3600 ]; then
            echo "The script has already run within the last hour. Use --force"
            exit 0
        fi
    fi
fi

date +%s > "$TIMESTAMP_FILE"

DISK=`df -h -x tmpfs -x devtmpfs -x nfs -x cifs | awk '$NF=="/"{printf "%s", $5}' | sed 's/%//g'`

echo $DISK

if [ $(echo "$DISK > $DISK_USAGE_THRESHOLD" | bc -l) -eq 1 ];
then
    echo "Disk usage is $DISK% which is above $DISK_USAGE_THRESHOLD%! Take action immediately."
    
    curl -s \
    --form-string "token=$PUSHOVER_TOKEN" \
    --form-string "user=$PUSHOVER_USER_KEY" \
    --form-string "priority=1" \
    --form-string "title=High Disk Alert" \
    --form-string "message=$HOSTNAME: $DISK% \
    $(df -h -x tmpfs -x devtmpfs -x nfs -x cifs)" \
    https://api.pushover.net/1/messages.json
fi