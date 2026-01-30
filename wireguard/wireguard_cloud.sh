#!/bin/bash

sleep 10
NUMBERRAMDOM=$(echo $((RANDOM % 254)))
NUMBERRAMDOMOTHER=$(echo $((RANDOM % 254)))
NUMBERRAMDOMSIXTEEN=$(echo $((RANDOM % (127 - 16 + 1)+  16)))
NUMBERRAMDOMPORT=$(echo $((RANDOM % (5999 - 5000 + 1) + 5000)))







IPCGNAT=172.$NUMBERRAMDOMSIXTEEN.$NUMBERRAMDOMOTHER.$NUMBERRAMDOM/32
IPV6=2606:4700:110:8c2e:ab97:d031:8048:fe2d/128
uci add_list network.cloud.ip6prefix='2606:4700:110:8c2e:ab97:d031:8048:fe2d/64'
uci set network.cloud.addresses="$IPCGNAT $IPV6"
uci commit
service firewall restart
service network restart
