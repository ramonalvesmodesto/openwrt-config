```bash
mkdir /etc/ebpf
wget https://github.com/ramonalvesmodesto/openwrt-config/raw/refs/heads/main/ebpf/xdp_le_ipv4_forward.o -O /etc/ebpf
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/ebpf/00-netstate -O /etc/hotplug.d/iface/00-netstate
service network restart
```
