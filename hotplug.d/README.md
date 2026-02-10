```bash
mkdir -p /etc/hotplug.d/button
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/hotplug.d/00-netstate -O /etc/hotplug.d/iface/00-netstate
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/scripts/net -O /etc/scripts/net
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/hotplug.d/buttons -O /etc/hotplug.d/button/buttons

chmod +x /etc/scripts/net
```
