```bash
#### dnscrypt-proxy ####
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/main/dnscrypt/dnscrypt-proxy.toml -O /etc/dnscrypt-proxy2/dnscrypt-proxy.toml

#cp /usr/sbin/dnscrypt-proxy /etc/dnscrypt-proxy2/
#rm /usr/sbin/dnscrypt-proxy
#wget https://github.com/ramonalvesmodesto/openwrt-config/blob/main/dnscrypt/dnscrypt-2.1.8/dnscrypt-proxy -O /usr/sbin/dnscrypt-proxy
#chmod +x /usr/sbin/dnscrypt-proxy

#service dnsmasq stop
#uci set dhcp.@dnsmasq[0].noresolv="1"
#uci set dhcp.@dnsmasq[0].cachesize='0'
#uci -q delete dhcp.@dnsmasq[0].server
#uci commit dhcp
#service dnsmasq start
service dnscrypt-proxy restart
```
