## Correção dhcpv6 client ipv6-pd odhcp
``` bash
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/ipv6_odhcp/dhcpv6.script -O /lib/netifd/dhcpv6.script
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/ipv6_odhcp/dhcpv6.sh -O /lib/netifd/proto/dhcpv6.sh

uci set firewall.@zone[1].masq="1"
uci set firewall.@zone[1].masq6="1"
uci set network.wan6.sourcefilter="0"
uci set network.wan6.reqprefix='64'
uci set dhcp.lan.ra_slaac='1'
uci commit
service firewall restart
service network restart
```
## Configuração via interface
Escolha o tamanho do prefixo na interface wan6 na opção "Request IPv6-prefix of length". A opção automático é o comportamento padrão do openwrt

![IPV6](https://github.com/ramonalvesmodesto/openwrt-config/blob/main/ipv6_odhcp/Captura%20de%20tela%20de%202024-10-20%2013-32-18.png)
