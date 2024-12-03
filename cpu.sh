#!/bin/bash

cd "$(dirname "$0")"
source .env

CPU=`cat /proc/loadavg | awk '{print $3}'`

echo $CPU

if [ $(echo "$CPU > $CPU_LOAD_THRESHOLD" | bc -l) -eq 1 ];
then
    echo "CPU usage is $CPU which is above $CPU_LOAD_THRESHOLD! Take action immediately."
    
    curl -s \
    --form-string "token=$PUSHOVER_TOKEN" \
    --form-string "user=$PUSHOVER_USER_KEY" \
    --form-string "priority=0" \
    --form-string "title=High CPU Alert" \
    --form-string "message=$HOSTNAME: $CPU \
    $(ps -eo pid,comm,args,%cpu,%mem --sort=-%cpu | head -n 11)" \
    https://api.pushover.net/1/messages.json
fi

if [ $(echo "$CPU > $CPU_REBOOT_THRESHOLD" | bc -l) -eq 1 ];
then
    echo "CPU usage is critical: $CPU . Rebooting!"
    
    curl -s \
    --form-string "token=$PUSHOVER_TOKEN" \
    --form-string "user=$PUSHOVER_USER_KEY" \
    --form-string "priority=1" \
    --form-string "title=High CPU Alert" \
    --form-string "message=Reboot $HOSTNAME: $CPU \
    $(ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 11)" \
    https://api.pushover.net/1/messages.json

    reboot
fi