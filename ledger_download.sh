#!/bin/bash

# Vite Node ledger download
# Tested on Ubuntu 20.04
# https://github.com/vitelabs/go-vite
# https://vite.net

info=$(tput setaf 12)
error=$(tput setaf 1)
success=$(tput setaf 2)
normal=$(tput sgr0)

declare HOST=185.252.232.137


if pgrep -x "gvite" > /dev/null
then
    printf "${error}Stopping Vite Node process${normal}\n"

    pkill -9 gvite
fi

cd ~/.gvite/maindata/
printf "${info}Backing up old ledger\n${normal}"
mv ledger ledger_bk
printf "${info}Downloading new ledger\n${normal}"
wget -c ${HOST}/ledger.tar.gz
printf "${info}Uncompressing new ledger\n${normal}"
tar -xzvf ledger.tar.gz
#rm ledger.tar.gz
cd

printf "${info}Launch ./bootstrap\n${normal}"
printf "${success}Finished!${normal}\n\n"