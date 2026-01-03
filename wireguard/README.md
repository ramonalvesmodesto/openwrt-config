wget https://ramonalvesmodesto.github.io/openwrt-config/wireguard/wireguard_cloud.sh -O /etc/wireguard_cloud.sh
wget https://ramonalvesmodesto.github.io/openwrt-config/wireguard/wireguard_cloud -O /etc/init.d/wireguard_cloud
chmod +x /etc/init.d/wireguard_cloud
chmod +x /etc/wireguard_cloud.sh
/etc/init.d/wireguard_cloud enable
/etc/init.d/wireguard_cloud start
