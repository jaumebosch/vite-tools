#!/bin/bash

jq  '.Identity' ../gvite/node_config.json
printf "Git pull....\n"
git pull

# crontab -l > mycron
# echo "*/30 * * * * ~/vite-tools/check_process.sh" >> mycron
# printf "Installing crontab....\n"
# crontab mycron
# rm mycron

printf "\n\n"
printf "================================================================\n"