```bash
#### SNAT ####
#wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/refs/heads/main/ppp/ppp.sh -O /lib/netifd/proto/ppp.sh
#wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/ppp/ppp-up -O /lib/netifd/ppp-up

#uci add firewall nat # =cfg1293c8
#uci set firewall.@nat[-1].name='snat pppoe'
#uci add_list firewall.@nat[-1].proto='all'
#uci set firewall.@nat[-1].src='wan'
#uci set firewall.@nat[-1].target='SNAT'
#uci set firewall.@nat[-1].snat_ip='100.91.23.131'
#uci set firewall.@nat[-1].device='pppoe-wan'

```
