#!/bin/bash

DIA=$(date | cut -d' ' -f3)
NUMBER=1
NUMBER1=$(uci get network.@wireguard_cloud[0].endpoint_host | cut -d'.' -f4)

if [ $DIA -eq $NUMBER1 ]; then
    logger 'Script exit wireguard_cloud.sh'
    exit 0
elif [ $DIA -ge 3 ] && [ $DIA -le 20 ]; then
    NUMBER=$DIA
elif [ $DIA -ge 21 ] && [ $DIA -le 29 ]; then
    A=$(echo "$DIA" | grep -o .)
    NUMBER=$(echo "$A" | tail -n 1)
else
    NUMBER=20
fi

IP=162.159.192.$NUMBER
uci set network.@wireguard_cloud[0].endpoint_host="$IP"
uci commit
service network restart
