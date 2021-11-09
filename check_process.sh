#!/bin/bash

# Simple Vite Node process checker
# https://github.com/vitelabs/go-vite
# https://vite.net

error=$(tput setaf 1)
success=$(tput setaf 2)
normal=$(tput sgr0)

if pgrep -x "gvite" > /dev/null
then
    printf "${success}Vite Node process running${normal}\n"
else
    printf "${error}Vite Node process not found. Launching${normal}\n"
    ~/gvite/bootstrap
fi