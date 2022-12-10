#!/bin/bash
clear

author="©Jan Kupczyk"
version="3.1.9"

fg_red=`tput setaf 1`
fg_green=`tput setaf 2`
fg_yellow=`tput setaf 3`
fg_blue=`tput setaf 4`
fg_magenta=`tput setaf 5`
fg_cyan=`tput setaf 6`
fg_white=`tput setaf 7`
fg_def_col="\033[00m"
bg_red='\033[41m'
bg_black='\033[40m'

DIG_IP=$(dig +short myip.opendns.com @resolver4.opendns.com)
S_KEY=$(shuf -er -n7  {A..Z} {a..z} {0..9} | tr -d '\n')
BOD=56
PVN=277
DV=319

log=$(date +"%T")

printf "${fg_red}
╔═╗╦ ╦╔═╗╔═╗╔═╗╔═╗╦═╗
╚═╗║║║║╣ ║╣ ╠═╝║╣ ╠╦╝
╚═╝╚╩╝╚═╝╚═╝╩  ╚═╝╩╚═v${version}
Made by ${author}
"

echo -e "${fg_white}\n${bg_red}DISCLAIMER: Remember that you use the script at your own risk, the author of script is not responsible for any potential damage and will not be liable!${fg_def_col}${fg_white}"

echo -e "\n${fg_red}Be aware that the program is in its alpha version, so there may be bugs!${fg_white}"
echo -e "${fg_red}Ping sweep is a method that can establish a range of IP addresses which map to live hosts.${fg_white}"
echo -e "${fg_red}Be aware that pings can be detected by protocol loggers!${fg_white}"
echo -e "${fg_green}Complete only the octets responsible for the network address, and leave the last one responsible for the host address empty!${fg_white}"
echo -e "${fg_green}Enter the ip address in this format |xxx.xxx.xxx|${fg_white}"
read -p "${fg_green}Enter network address: ${fg_white}" IP_input

function IP_SWEEPER_(){
    echo -e "\n${fg_red}Running ${0} ${fg_white}" && sleep 2s
    echo -e "${fg_red}"
    sudo systemctl restart systemd-resolved && sudo systemctl stop systemd-resolved && sudo service redis-server start
    echo -e "Get all services..." && sleep 2s
    service --status-all
    echo -e " [ % ]  MYIP-${DIG_IP}"
    echo -e "\n${fg_green}---------------BEGIN SWEEPER REQUEST---------------${fg_white}"
    echo "Generated ${log}" >> sweeperip.txt
    echo "<<--Possible addresses-->>" >> sweeperip.txt

    for ip in `seq 0 254`; do
        if ping -c1 -w3 $IP_input.$ip >/dev/null 2>&1
        then
            echo -e "${fg_yellow}[*] Pinging IPSWEEPER ($IP_input.$ip) with ${BOD} bytes of data:${fg_white}"
            echo -e "${fg_green}[+] Destination host reachable; IP address is assigned${fg_white}" >&2
            locate_ip=$(curl -s ipinfo.io/$IP_input.$ip | jq .country)
            E_LOCATE=$(curl -s https://ipinfo.io/$IP_input.$ip | jq .loc)
            mrt=ESTABLISHED
            result_of_ping=0
            ISP=$(curl -s https://ipinfo.io/$IP_input.$ip | jq .org)
            TP=$(shuf -i 13-77 -n 1)
        else
            echo -e "${fg_yellow}[*] Pinging IPSWEEPER ($IP_input.$ip) with ${BOD} bytes of data:${fg_white}"
            echo -e "${fg_red}[-] Destination host unreachable; IP address is free${fg_white}" >&2
            locate_ip=$(curl -s ipinfo.io/$IP_input.$ip | jq .country)
            E_LOCATE=$(curl -s https://ipinfo.io/$IP_input.$ip | jq .loc)
            mrt=UNKNOWN
            result_of_ping=1
            ISP=$(curl -s https://ipinfo.io/$IP_input.$ip | jq .org)
            TP=$(shuf -i 999-9999 -n 1)
        fi
        echo -e "[#] $IP_input.$ip -- COUNTRY: ${locate_ip}(${E_LOCATE}°) -- ${TP}ms -- STATE: ${mrt} -- ISP: ${ISP}\n"
        ping -c 1 $IP_input.$ip | grep "64 bytes" | cut -d " " -f 4 | tr -d ":" >> sweeperip.txt &
    done
    echo -e "${fg_green}---------------END SWEEPER REQUEST---------------${fg_white}"
    echo -e "${fg_red}Ending session...${fg_white}" && sleep 2s
    echo -e "${fg_red}Session key: ${S_KEY}${fg_white}"
    echo -e "\n${fg_green}Read more about sweeper at${fg_green} [${fg_blue}https://github.com/jankupczyk/IP_SWEEPER${fg_green}]${fg_white}"
    echo -e "\n${fg_green}For more information head to${fg_green} [${fg_blue}sweeperip.txt${fg_green}]${fg_white}\n"
    echo -e "${fg_green}~~Made with ${fg_magenta}❤${fg_green}  by ${author}"
    echo -e "${fg_white}"
}
IP_SWEEPER_