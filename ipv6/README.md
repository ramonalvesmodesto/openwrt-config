## Package dependencies 
```bash
opkg update
opkg install jq curl openssl-util isc-dhcp-client-ipv6 bc
```

## Config
```bash 
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/ipv6/verify_ipv6.sh -O /etc/verify_ipv6.sh
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/ipv6/config_ipv6_with_prefix_delegate -O /etc/init.d/config_ipv6_with_prefix_delegate
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/ipv6/config_ipv6_with_prefix_delegate.sh -O /etc/config_ipv6_with_prefix_delegate.sh
chmod +x /etc/init.d/config_ipv6_with_prefix_delegate
/etc/init.d/config_ipv6_with_prefix_delegate enable
/etc/init.d/config_ipv6_with_prefix_delegate start
```
```bash
sed -i 's/exit 0//' /etc/crontabs/root
echo '*/5 * * * * /bin/sh /etc/verify_ipv6.sh' >> /etc/crontabs/root
echo '' >> /etc/crontabs/root
echo 'exit 0' >> /etc/crontabs/root

service cron restart
```

## Functions
- A new IPv6 is generated at each reboot
- Checks if IPv6 is active every 5 minutes
- Generates a random interface ID

  ![IPV6](https://github.com/ramonalvesmodesto/openwrt-config/blob/main/ipv6/1583548685423.jpg)
