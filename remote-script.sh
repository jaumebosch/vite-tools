#!/bin/bash

jq  '.Identity' ../gvite/node_config.json
printf "Git pull....\n"
git pull
~/vite-tools/check_process.sh

printf "\n\n"
printf "================================================================\n"