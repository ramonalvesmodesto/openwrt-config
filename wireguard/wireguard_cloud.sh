#!/bin/bash

sleep 10
NUMBERRAMDOM=$(echo $((RANDOM % 254)))
NUMBERRAMDOMOTHER=$(echo $((RANDOM % 254)))
NUMBERRAMDOMSIXTEEN=$(echo $((RANDOM % (127 - 16 + 1)+  16)))
#NUMBERRAMDOMDOMAIN=$(echo $((RANDOM % 4)))
NUMBERRAMDOMPORT=$(echo $((RANDOM % (5999 - 5000 + 1) + 5000)))

#list=("server_names = ['quad9-dnscrypt-ip4-filter-pri']"
#        "server_names = ['adguard-dns-unfiltered']"
#        "server_names = ['dnscry.pt-valdivia-ipv4']"
#        "server_names = ['google']"
#        "server_names = ['cloudflare']"
#     )

#sed -i "32 s/.*/${list[$NUMBERRAMDOMDOMAIN]}/" /etc/dnscrypt-proxy2/*.toml






IPCGNAT=172.$NUMBERRAMDOMSIXTEEN.$NUMBERRAMDOMOTHER.$NUMBERRAMDOM/32
IPCGNATISP=$(ip -4 a show pppoe-wan | grep inet | cut -d' ' -f6)/32
IPV6=2606:4700:110:8c2e:ab97:d031:8048:fe2d/128

#uci set firewall.@zone[1].masq_src="$IPCGNAT"
#uci set firewall.@zone[1].masq_dest="$IPCGNATISP"
#uci set network.cloud.addresses="$IPCGNAT $IPV6"
uci set network.cloud.addresses="104.28.234.64/32"
#uci set network.cloud.listen_port="$NUMBERRAMDOMPORT"
#uci set firewall.@nat[0].snat_ip="$IPCGNAT"
uci commit
service firewall restart
service network restart
