#!/bin/sh
VAR=$1
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/firewall/firewall$VAR.conf -O /etc/config/firewall
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/network/network$VAR -O /etc/config/network
