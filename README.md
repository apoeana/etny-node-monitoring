# etny-node-monitoring for sending notifications to a Telegram Bot

1.	Begin by creting a Telegram Bot and cloning the repository:

            1.1. Open Telegram and search for @BotFather.
            1.2. Start a chat with BotFather by clicking on the "Start" button.
            1.3. Send the command "/newbot" to BotFather to create a new bot.
            1.4. Follow the instructions provided by BotFather to set a name and username for your bot.
            1.5. Once you have successfully created your bot, BotFather will provide you with an API token. Save this token as it will be required for the bot to function properly.
            1.6. Open Telegram and search your @bot_name (replace it wiht your bot name)
            1.7. Click on the "Start" button to start interacting with the bot, it is mandatory to send a message to the bot.
            1.8 Clone the repository.


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

