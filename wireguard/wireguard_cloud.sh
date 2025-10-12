#!/bin/bash

DIA=$(date | cut -d' ' -f3)
NUMBER=1

if [ $DIA -gt 0 ] && [ $DIA -le 20 ]; then
    NUMBER=$DIA
elif [ $DIA -gt 21 ] && [ $DIA -le 29 ]; then
    A=$(echo "$DIA" | grep -o .)
    NUMBER=$(echo "$A" | tail -n 1)
else
    NUMBER=20
fi

IP=162.159.192.$NUMBER

uci set network.@wireguard_cloud[0].endpoint_host="$IP"
uci commit
service network restart
