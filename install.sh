#!/bin/bash

# Install prerequisites
echo "Installing prerequisites..."
sudo apt-get update >/dev/null 2>&1
sudo apt-get install -y curl jq python3-pip >/dev/null 2>&1
sudo pip3 install python-telegram-bot >/dev/null 2>&1
echo "Prerequisites installed successfully."

# Check if config file exists
if [ -f config ]; then
    echo "Config file already exists, skipping configuration..."
else
    # Read input from user and save to config file
    echo "Please enter your Telegram Bot Token:"
    read bot_token

    # Retrieve chat ID from Telegram API
    chat_id=$(curl -s -X GET "https://api.telegram.org/bot${bot_token}/getUpdates" | jq -r '.result[-1].message.chat.id')

    # Initialize nodes array

    echo "Please enter the number of nodes you want to monitor:"
    read num_nodes

    nodes=()

    for (( i=1; i<=$num_nodes; i++ )); do
        echo "Please enter the name for node $i:"
        read node_name
        echo "Please enter the address for node $i:"
        read node_address

        # Remove any non-alphanumeric characters from user input
        node_name=$(echo "$node_name" | tr -dc '[:alnum:]\n\r')

        # Add the node to the nodes array
        nodes+=("$node_name:$node_address")
    done

    # Save the nodes, bot_token, and chat_id to the config file
    echo "bot_token=${bot_token}" > config
    echo "chat_id=${chat_id}" >> config
    echo "nodes=(" >> config
    for node in "${nodes[@]}"; do
        echo "'$node'" >> config
    done
    echo ")" >> config

    echo "Config file created successfully."
fi


# Set the path to the script
SCRIPT_PATH=$(dirname "$(readlink -f "$0")")/etny-node-monitoring.sh

# Check if crontab line exists and update or create it accordingly
if sudo crontab -l | grep -qF "$SCRIPT_PATH"; then
    (sudo crontab -l | grep -vF "$SCRIPT_PATH"; echo "0 * * * * $(pwd)/etny-node-monitoring.sh >> /var/log/etny-node-monitoring.log 2>&1") | sudo crontab -
    echo "Crontab line updated successfully."
else
    (sudo crontab -l ; echo "0 * * * * $(pwd)/etny-node-monitoring.sh >> /var/log/etny-node-monitoring.log 2>&1") | sudo crontab -
    echo "Crontab line added successfully."
fi

# Function to display the loading bar

function loading_bar {
    local delay=0.75
    local progress=0
    local spinstr='⣷⣯⣟⡿⢿⣻⣽⣾'

    # Get the PID of the etny-node-monitoring.sh script
    local pid=$!

    # Loop until the etny-node-monitoring.sh script completes
    while ps -p $pid > /dev/null; do
        # Increment the progress every 2 seconds
        sleep 2
        progress=$((progress+1))

        # Display the progress bar
        printf "\r[${spinstr:$((progress % ${#spinstr})):1}] Running etny-node-monitoring.sh...[${progress}s] \n"
    done

    # Display the progress bar with 100% completion
    printf "\r[✓] etny-node-monitoring.sh completed successfully!          \n"
}

# Grant executable permission to the monitoring script
chmod +x ./etny-node-monitoring.sh

# Start the monitoring script
echo "Starting the monitoring script..."
./etny-node-monitoring.sh & loading_bar

echo "Etny Node Monitoring setup complete!"
