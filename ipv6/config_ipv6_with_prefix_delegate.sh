#!/bin/sh

rm /var/dhcpv6.leases
touch /var/dhcpv6.leases
dhclient -6 -cf /etc/dhclient6.conf  -sf /usr/sbin/dhclient-script -lf /var/dhcpv6.leases eth0 #Usa o isc-dhcpv6-client para obter o ipv6 do isp

IPV6_128="$(cat /var/dhcpv6.leases | grep iaaddr | cut -d ' ' -f 6- | cut -d '{' -f 1 | cut -d ' ' -f 1)/128"
IPV6_SUFIX="$(cat /var/dhcpv6.leases | grep iaaddr | cut -d ' ' -f 6- | cut -d '{' -f 1 | sed 's/::/\//' | cut -d '/' -f 1)"
EU64_MAC="1C1A:EAFF:FE28:1CEC"
IPV6_64="$IPV6_SUFIX:$EU64_MAC/64"

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

uci add_list network.wan6.ip6addr="$IPV6_128"
uci add_list network.wan6.ip6addr="$IPV6_64"
uci set network.wan6.ip6prefix="$IPV6_SUFIX::/64"
uci set network.wan6.ip6gw='fe80::1'

uci set dhcp.wan6=dhcp
uci set dhcp.wan6.interface='wan6'
uci set dhcp.wan6.ignore='1'
uci set dhcp.wan6.ra='relay'
uci set dhcp.wan6.dhcpv6='relay'

uci commit
/etc/init.d/network restart
