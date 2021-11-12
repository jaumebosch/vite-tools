#!/bin/bash

jq  '.Identity' ../gvite/node_config.json
printf "Git pull....\n"
git pull



printf "\n\n"
printf "================================================================\n"