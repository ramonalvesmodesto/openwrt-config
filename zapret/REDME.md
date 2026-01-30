```bash
cd /tmp
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/zapret/zapret2-0.9.20260129-r1.apk -O zapret2-0.9.20260129-r1.apk
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/zapret/luci-app-zapret2-0.9.20260129-r1.apk -O luci-app-zapret2-0.9.20260129-r1.apk

apk --allow-untrusted zapret2-0.9.20260129-r1.apk
apk --allow-untrusted luci-app-zapret2-0.9.20260129-r1.apk

cd #
```
