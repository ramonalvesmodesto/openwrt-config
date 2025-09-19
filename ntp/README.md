Fonte [https://openwrt.org/docs/guide-user/firewall/fw3_configurations/fw3_nat#npt](https://openwrt.org/docs/guide-user/firewall/fw3_configurations/fw3_nat#npt)

Caso de uso: pppoe com CGNAT, é necessário modificar o arquivo ppp-up para ips dinâmicos

:warning: Realize backup para recuperação em caso em configuração não funcione em seu roteador

#### NTP
```bash
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/refs/heads/main/ppp/ppp.sh -O /lib/netifd/proto/ppp.sh
wget https://raw.githubusercontent.com/ramonmodesto99999/openwrt-config/refs/heads/main/ppp/ppp-up1 -O /lib/netifd/ppp-up

cat << "EOF" > /etc/nftables.d/npt.sh
LAN_PFX="192.168.1.0/24"
WAN_PFX="192.168.2.0/24"
. /lib/functions/network.sh
network_flush_cache
network_find_wan WAN_IF
network_get_device WAN_DEV "${WAN_IF}"
nft add rule inet fw4 srcnat \
oifname "${WAN_DEV}" snat ip prefix to ip \
saddr map { "${LAN_PFX}" : "${WAN_PFX}" }
EOF
uci -q delete firewall.npt
uci set firewall.npt="include"
uci set firewall.npt.path="/etc/nftables.d/npt.sh"
uci commit firewall
service firewall restart

uci del firewall.@zone[1].masq='1'
```
O ppp-up acima já possui modificações para ip dinâmico, então a variável WAN_PFX será atualizado com o ip de sua interface pppoe cada vez que ela reiniciar

![imagem](https://github.com/ramonmodesto99999/openwrt-config/blob/main/ntp/Captura%20de%20tela%20de%202025-09-19%2010-13-30.png)
