#!/bin/bash

#DIA=$(date | cut -d' ' -f3)
#NUMBER=1
#NUMBER1=$(uci get network.@wireguard_cloud[0].endpoint_host | cut -d'.' -f4)
NUMBERRAMDOM=$(echo $((RANDOM % 254)))
NUMBERRAMDOMOTHER=$(echo $((RANDOM % 254)))
NUMBERRAMDOMSIXTEEN=$(echo $((RANDOM % (127 - 16 + 1)+  16)))
NUMBERRAMDOMDOMAIN=$(echo $((RANDOM % 3)))
NUMBERRAMDOMNUMBER=$(echo $((RANDOM % 1)))
NUMBERRAMDOMPORT=$(echo $((RANDOM % (5999 - 5000 + 1) + 5000)))




#if [ $DIA -eq $NUMBER1 ]; then
#    logger 'Script exit wireguard_cloud.sh'
#    exit 0
#elif [ $DIA -ge 4 ] && [ $DIA -le 20 ]; then
#    NUMBER=$DIA
#elif [ $DIA -ge 25 ] && [ $DIA -le 29 ]; then
#    A=$(echo "$DIA" | grep -o .)
#    NUMBER=$(echo "$A" | tail -n 1)
#else
#    NUMBER=16
#fi

#IP=162.159.192.$NUMBER

list=("server_names = ['quad9-dnscrypt-ip4-filter-pri']" 
        "server_names = ['quad9-dnscrypt-ip4-nofilter-ecs-pri']" 
        "server_names = ['adguard-dns-unfiltered']"
        "server_names = ['dnscry.pt-valdivia-ipv4']"
     )

listnumber=(100 172)

NUMBER=${listnumber[$NUMBERRAMDOMNUMBER]}

sed -i "32 s/.*/${list[$NUMBERRAMDOMDOMAIN]}/" /etc/dnscrypt-proxy2/*.toml

IPCGNAT=172.$NUMBERRAMDOMSIXTEEN.$NUMBERRAMDOMOTHER.$NUMBERRAMDOM/32
uci set network.cloud.addresses="$IPCGNAT"
uci set network.cloud.listen_port="$NUMBERRAMDOMPORT"
#uci set network.@wireguard_cloud[0].endpoint_host="$IP"
uci commit
service dnscrypt-proxy restart
service network restart
