```bash
wget https://ramonalvesmodesto.github.io/openwrt-config/wireguard/wireguard_cloud.sh -O /etc/wireguard_cloud.sh
wget https://ramonalvesmodesto.github.io/openwrt-config/wireguard/wireguard_cloud -O /etc/init.d/wireguard_cloud
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/wireguard/script_network_wireguard_cloud_change.sh -O /etc/script_network_wireguard_cloud_change.sh
chmod +x /etc/init.d/wireguard_cloud
chmod +x /etc/wireguard_cloud.sh
chmod +x /etc/script_network_wireguard_cloud_change.sh
/etc/init.d/wireguard_cloud enable
/etc/init.d/wireguard_cloud start
```
