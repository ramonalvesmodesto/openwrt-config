``` bash
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/knot-resolver/kresd.config -O /etc/knot-resolver/kresd.config
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/knot-resolver/kresd -O /etc/init.d/kresd 
/etc/init.d/kresd restart
```
