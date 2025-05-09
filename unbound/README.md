```bash
#### Unbound ####
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/main/unbound/unbound -O /etc/config/unbound
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/main/unbound/unbound.conf -O /etc/unbound/unbound.conf
#wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/main/unbound/unbound.sh -O /usr/lib/unbound/unbound.sh
#wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/refs/heads/main/unbound/unbound_init -O /etc/init.d/unbound
touch /etc/unbound/root.hints
service unbound enable
```
