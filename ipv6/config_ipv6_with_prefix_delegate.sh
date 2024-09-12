#!/bin/sh

sleep 10
kill $(cat /var/run/dhclient6.pid)

random_ipv6=$(openssl rand -hex 8)
random_1=${random_ipv6:0:4}
random_2=${random_ipv6:4:4}
random_3=${random_ipv6:8:4}
random_4=${random_ipv6:12:4}

rm /var/dhcpv6.leases
touch /var/dhcpv6.leases
dhclient -6 -cf /etc/dhclient6.conf  -sf /usr/sbin/dhclient-script -lf /var/dhcpv6.leases -pf /var/run/dhclient6.pid eth0 # usa ics-dhcp6-client para obter ipv6 do isp

IPV6_128="$(cat /var/dhcpv6.leases | grep iaaddr | cut -d ' ' -f 6- | cut -d '{' -f 1 | cut -d ' ' -f 1)/128"
IPV6_SUFIX="$(cat /var/dhcpv6.leases | grep iaaddr | cut -d ' ' -f 6- | cut -d '{' -f 1 | sed 's/::/\//' | cut -d '/' -f 1)"
IPV6_RANDOM="$random_1:$random_2:$random_3:$random_4"
IPV6_64="$IPV6_SUFIX:$IPV6_RANDOM/64"

uci del dhcp.wan6
uci del network.wan6
# /etc/config/firewall
uci del firewall.@zone[1].network
uci add_list firewall.@zone[1].network='wan'
uci add_list firewall.@zone[1].network='wan6'
# /etc/config/network
uci set network.wan6=interface
uci set network.wan6.proto='static'
uci set network.wan6.device='eth0'

uci del network.wan6.ip6addr
uci del network.wan6.ip6prefix
uci del network.wan6.ip6gw

# uci add_list network.wan6.ip6addr="$IPV6_128"
uci add_list network.wan6.ip6addr="$IPV6_64"
uci set network.wan6.ip6prefix="$IPV6_SUFIX::/56"
uci set network.wan6.ip6gw='fe80::1'

uci set dhcp.wan6=dhcp
uci set dhcp.wan6.interface='wan6'
uci set dhcp.wan6.ignore='1'
uci set dhcp.wan6.ra='relay'
uci set dhcp.wan6.dhcpv6='relay'

uci set firewall.@zone[1].masq="1"
uci set firewall.@zone[1].masq6="1"
uci commit firewall
service firewall restart

uci set network.wan6.sourcefilter="0"

uci add_list network.wan6.dns='::1'

uci commit
/etc/init.d/network restart
