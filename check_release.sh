#!/bin/bash

# Simple Vite Node release checker
# https://github.com/vitelabs/go-vite
# https://vite.net
# 
# Credits to Luke Childs for GitHub latest release script
# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c

error=$(tput setaf 1)
success=$(tput setaf 2)
normal=$(tput sgr0)

declare work_dir="../gvite"

LATEST=$(curl --silent "https://api.github.com/repos/vitelabs/go-vite/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/')

CURRENT=$(~/gvite/gvite -v | sed -n -e 's/^.*version //p')

if [ "$CURRENT" == "$LATEST" ]; then
    printf "${success}You are running the latest stable Vite Node release ($CURRENT)${normal}\n"
else
    printf "${error}There is a new Vite Node release ($LATEST), please read the changelog and update${normal}\n"
fi