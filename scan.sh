#!/bin/bash

red='\033[31m'
reset='\033[0m'
blue='\033[34m'

echo -e "${red}"
cat << EOF
 ____            _         ____                                  
|  _ \ ___  _ __| |_ ___  / ___|  ___ __ _ _ __  _ __   ___ _ __ 
| |_) / _ \| '__| __/ __| \___ \ / __/ _  | '_ \| '_ \ / _ \ '__|
|  __/ (_) | |  | |_\__ \  ___) | (_| (_| | | | | | | |  __/ |   
|_|   \___/|_|   \__|___/ |____/ \___\__,_|_| |_|_| |_|\___|_|   
                                               
EOF
echo -e "${reset}"
echo -e "${blue}Created by HackTheHacker${reset}"
echo -e "${blue}https://youtube.com/@js44${reset}"

read -p "Enter IP address: " IP
nmap -T4 -A $IP -p- -v -sV -Pn --open 2>/dev/null
