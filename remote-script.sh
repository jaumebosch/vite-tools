#!/bin/bash

jq  '.Identity' ../gvite/node_config.json
git pull
printf "\n\n"
printf "================================================================\n"