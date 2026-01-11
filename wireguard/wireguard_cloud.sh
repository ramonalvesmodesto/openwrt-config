#!/bin/bash
sleep 10
NUMBERRAMDOM=$(echo $((RANDOM % 254)))
NUMBERRAMDOMOTHER=$(echo $((RANDOM % 254)))
NUMBERRAMDOMSIXTEEN=$(echo $((RANDOM % (127 - 16 + 1)+  16)))
NUMBERRAMDOMDOMAIN=$(echo $((RANDOM % 4)))
NUMBERRAMDOMPORT=$(echo $((RANDOM % (5999 - 5000 + 1) + 5000)))

list=("server_names = ['quad9-dnscrypt-ip4-filter-pri']"
        "server_names = ['adguard-dns-unfiltered']"
        "server_names = ['dnscry.pt-valdivia-ipv4']"
        "server_names = ['google']"
        "server_names = ['cloudflare']"
     )

sed -i "32 s/.*/${list[$NUMBERRAMDOMDOMAIN]}/" /etc/dnscrypt-proxy2/*.toml

IPCGNAT=172.$NUMBERRAMDOMSIXTEEN.$NUMBERRAMDOMOTHER.$NUMBERRAMDOM/32
uci set network.cloud.addresses="$IPCGNAT"
uci set network.cloud.listen_port="$NUMBERRAMDOMPORT"
uci commit
service dnscrypt-proxy restart
service network restart
