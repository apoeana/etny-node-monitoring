# etny-node-monitoring for sending notifications to a Telegram Bot

1.	Begin by cloning the repository.

2.	Navigate to the cloned repository folder and start the installer by running the command:

            $ cd etny-node-monitoring && sudo chmod +x ./install.sh && sudo ./install.sh"

3.	Follow the instructions provided by the installer. This includes:

            3.1	Please enter your Telegram Bot Token:

            3.2	Please enter the number of nodes you want to monitor:

            3.3	Please enter the name for node 1:

            3.4	Please enter the address for node 1:

            3.5	Please enter the name for node 2:

            3.6	Please enter the address for node 2:

            3.7	Wait until Etny Node Monitoring setup complete!

If you encounter issues with the Etny Node Monitoring setup, you can try the following troubleshooting steps:

1.	Check if the information in the configuration file is correct by running the command:
            
            $ cat config"

2.	Check if the crontab service is running and if the script is added to it by running the following commands:
             
             $ sudo systemctl status cron.service
             $ sudo crontab -l

