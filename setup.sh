#!/bin/bash

# Vite Node automated setup
# Tested on Ubuntu 20.04
# https://github.com/vitelabs/go-vite
# https://vite.net
# 
# Credits to Luke Childs for GitHub latest release script
# https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c

info=$(tput setaf 12)
error=$(tput setaf 1)
success=$(tput setaf 2)
normal=$(tput sgr0)


declare limits_file="/etc/security/limits.conf"
isInFile=$(cat ${limits_file} | grep -c "root soft nofile 10240
root hard nofile 10240")
if [ $isInFile -eq 0 ]; then
    printf "> ${success}modifing limits.conf...${normal}\n"
    sed -i '/^# End of file/i \
root soft nofile 10240 \
root hard nofile 10240' ${limits_file}
else
    printf "> ${error}limits.conf already modified ${normal}\n"
fi



declare pam_limits_file="/etc/pam.d/common-session"

isInFile=$(cat ${pam_limits_file} | grep -c "session required pam_limits.so")
if [ $isInFile -eq 0 ]; then
    printf "> ${success}modifing pam_limits.so...${normal}\n\n"
    echo "session required pam_limits.so" >> ${pam_limits_file}
else
    printf "> ${error}pam_limits.conf already modified${normal}\n\n"
fi


declare work_dir="../gvite"
LATEST=$(curl --silent "https://api.github.com/repos/vitelabs/go-vite/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/')

printf "\n${info}Downloading latest Vite Node stable release ($LATEST) ${normal}\n"
curl -L -O "https://github.com/vitelabs/go-vite/releases/download/$LATEST/gvite-$LATEST-linux.tar.gz"
tar -xzvf "gvite-$LATEST-linux.tar.gz"
mv gvite-$LATEST-linux ${work_dir}
rm  "gvite-$LATEST-linux.tar.gz"


printf "\n${info}Vite FullNode name? ${normal}\n"
read fullNodeName

declare config_file="${work_dir}/node_config.json"

isInFile=$(cat ${config_file} | grep -c "foobar")
if [ $isInFile -eq 0 ]; then
    printf "> ${error}Unable to set Vite Node name, already modified?${normal}\n\n"
else
    sed -i 's/foobar/'"$fullNodeName"'/g' ${config_file}
    printf "> Vite FullNode name set to ${info}$fullNodeName${normal}\n\n"
fi


printf "${info}Vite account? ${normal}\n"
read viteAccount

isInFile=$(cat ${config_file} | grep -c "vite_xxxxxxxxxxxxxxxxxx")
if [ $isInFile -eq 0 ]; then
    printf "> ${error}Unable to ser Vite Account, already modified?${normal}\n\n"
else
    sed -i 's/vite_xxxxxxxxxxxxxxxxxx/'"$viteAccount"'/g' ${config_file}
    printf "> Vite Account set to ${info}$viteAccount${normal}\n\n"
fi

declare vite_tools_dir="./vite-tools"
declare bashrc_file="../.bashrc"

isInFile=$(cat ${bashrc_file} | grep -c "check_release.sh")
if [ $isInFile -eq 0 ]; then
    printf "> ${success}modifying bashrc to launch release_checker.sh on login...${normal}\n\n"
    echo "${vite_tools_dir}/check_release.sh" >> ${bashrc_file}
else
    printf "> ${error}bashrc already has release_checker.sh command${normal}\n\n"
fi

isInFile=$(cat ${bashrc_file} | grep -c "check_process.sh")
if [ $isInFile -eq 0 ]; then
    printf "> ${success}modifying bashrc to launch process_checker.sh on login...${normal}\n\n"
    echo "${vite_tools_dir}/check_process.sh" >> ${bashrc_file}
else
    printf "> ${error}bashrc already has process_checker.sh command${normal}\n\n"
fi

printf "${info}Download current ledger with ledger_download.sh to speed up the sync${normal}\n"

printf "${info}Remember to logout and login to set the new limits${normal}\n"
printf "${info}Launch ./bootstrap after relogin!\n${normal}"
printf "${success}Finished!${normal}\n\n"