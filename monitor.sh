#!/bin/bash

cd "$(dirname "$0")"
source .env

CPU=`cat /proc/loadavg | awk '{print $3}'`
DISK=`df -h | awk '$NF=="/"{printf "%s", $5}' | sed 's/%//g'`

echo $CPU
# Check if either usage is above 80%
if [ $(echo "$CPU > $CPU_LOAD_THRESHOLD" | bc -l) -eq 1 ] || [ $(echo "$DISK > $DISK_USAGE_THRESHOLD" | bc -l) -eq 1 ];
then
    # Send an alert via email or any other desired method
    echo "CPU or DISK usage is above 80%! Take action immediately." | mail -s "Alert: High resource usage on EC2 instance" websea.development@gmail.com
fi
