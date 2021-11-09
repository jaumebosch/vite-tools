#!/bin/bash

jq  '.Identity' ../gvite/node_config.json
printf "Git pull....\n"
git pull
#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "*/30 * * * * ~/vite-tools/check_process.sh" >> mycron
#install new cron file
printf "Installing crontab....\n"
crontab mycron
rm mycron

printf "\n\n"
printf "================================================================\n"