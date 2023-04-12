#!/bin/bash

# Source config file
source "$(dirname "$0")/config"

# Log start time and duration of script
start_time=$(date +%s)
echo "###########################################################################" >> /var/log/etny-node-monitoring.log
echo "Script started at $(date '+%Y-%m-%d %H:%M:%S')" >> /var/log/etny-node-monitoring.log

# Define output variable
output=""

# Loop through addresses and monitor each one
for address in "${nodes[@]}"; do
    # Extract name and address from the string
    name="$(echo "$address" | cut -d':' -f1)"
    address="$(echo "$address" | cut -d':' -f2)"

    # Get the last transaction from the address
    last_transaction=$(curl -s "https://blockexplorer.bloxberg.org/api?module=account&action=txlist&address=${address}" | jq '.result[0]') || { echo "Failed to get last transaction for ${name} (${address})" >&2; exit 1; } >> /var/log/etny-node-monitoring.log

    # Extract the timestamp from the last transaction
    last_transaction_timestamp=$(echo "${last_transaction}" | jq -r '.timeStamp')

    # Calculate the time difference in hours between now and the last transaction
    now=$(date +%s)
    time_diff=$(( (now - last_transaction_timestamp) / 3600 ))

    # Display the result on the screen
    echo "Last contract call for ${name} (${address}): ${time_diff} hours ago"

    # If the last transaction was more than 12 hours ago, send a notification via Telegram
    function send_notification {
        if [ "${time_diff}" -ge 12 ] && [ "${time_diff}" -le $((90*24)) ]; then
            message="Last contract call for ${name} (${address}): ${time_diff} hours ago"
            curl -s -X POST "https://api.telegram.org/bot${bot_token}/sendMessage" \
                -d "chat_id=${chat_id}" \
                -d "text=${message}" >> /dev/null || { echo "Failed to send notification for ${name} (${address})" >&2; exit 1; }
            echo "Notification sent: ${message}" >> /var/log/etny-node-monitoring.log
        fi
    }

    send_notification

done

# Log end time and duration of script
end_time=$(date +%s)
duration=$((end_time - start_time))
echo "Script ended at $(date '+%Y-%m-%d %H:%M:%S')" >> /var/log/etny-node-monitoring.log
echo "Duration time: ${duration} seconds" >> /var/log/etny-node-monitoring.log
