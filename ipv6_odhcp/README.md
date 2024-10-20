## Correção ipv6-pd odhcp
``` bash
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/ipv6_odhcp/dhcpv6.script -O /lib/netifd/dhcpv6.script
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/ipv6_odhcp/dhcpv6.sh -O /lib/netifd/proto/dhcpv6.sh
```
## Configuração via interface
Escolha o tamanho do prefixo na interface wan6 na opção "Request IPv6-prefix of length"

![IPV6](https://github.com/ramonalvesmodesto/openwrt-config/blob/main/ipv6_odhcp/Captura%20de%20tela%20de%202024-10-20%2013-32-18.png)
