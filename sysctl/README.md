``` bash
opkg update
opkg install kmod-tcp-bbr 

wget https://raw.githubusercontent.com/ramonmodesto98/openwrt-config/main/sysctl/sysctl.conf -O /etc/sysctl.conf
sysctl -p
```
