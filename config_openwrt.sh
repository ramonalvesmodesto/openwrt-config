#### source feed openwrt custom ####
echo 'dest root /' > /etc/opkg.conf
echo 'dest ram /tmp' >> /etc/opkg.conf
echo 'lists_dir ext /var/opkg-lists' >> /etc/opkg.conf
echo 'option overlay_root /overlay' >> /etc/opkg.conf
echo '# option check_signature' >> /etc/opkg.conf


# echo 'src/gz openwrt_core https://downloads.openwrt.org/releases/23.05.5/targets/rockchip/armv8/packages' > /etc/opkg/distfeeds.conf
# echo 'src/gz openwrt_base https://downloads.openwrt.org/releases/23.05.5/packages/aarch64_generic/base' >> /etc/opkg/distfeeds.conf
# echo 'src/gz openwrt_kmod https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-packages/main/aarch64_cortex-a53/kmod' >> /etc/opkg/distfeeds.conf
# echo 'src/gz openwrt_luci https://downloads.openwrt.org/releases/23.05.5/packages/aarch64_generic/luci' >> /etc/opkg/distfeeds.conf
# echo 'src/gz openwrt_packages https://downloads.openwrt.org/releases/23.05.5/packages/aarch64_generic/packages' >> /etc/opkg/distfeeds.conf
# echo 'src/gz openwrt_routing https://downloads.openwrt.org/releases/23.05.5/packages/aarch64_generic/routing' >> /etc/opkg/distfeeds.conf
# echo 'src/gz openwrt_telephony https://downloads.openwrt.org/releases/23.05.5/packages/aarch64_generic/telephony' >> /etc/opkg/distfeeds.conf



opkg update

#### remove ####
#opkg remove --force-removal-of-dependent-packages ddns-scripts-services vsftpd luci-app-commands samba4-libs ttyd samba4-server aria2 ddns-scripts adblock smartdns luci-app-nlbwmon watchcat nft-qos nlbwmon netdata hd-idle minidlna miniupnpd-nftables wsdd2
#opkg list-installed | grep i18n | cut -f 1 -d ' ' | xargs opkg remove
#### Install packages ####

opkg install luci-app-unbound unbound-control bc ethtool-full jq curl openssl-util isc-dhcp-client-ipv6 bash coreutils-nohup nano luci procps-ng-sysctl libxtables12 libelf1 luci-app-sqm ip-full bind-dig cqueues kmod-tcp-bbr kmod-tcp-hybla  openssh-sftp-client openssh-sftp-server tc-full dnscrypt-proxy2 kmod-sched-ctinfo tcpdump 
# opkg install mcproxy irqbalance knot-resolver kmod-veth ip-full kmod-jool-netfilter jool-tools-netfilter 

# uci set network.lan.ipaddr='192.168.1.1'

cp /www/luci-static/bootstrap/cascade.css /www/luci-static/bootstrap/cascade.css.bk
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/css/cascade.css -O /www/luci-static/bootstrap/cascade.css

#### uhttpd ####
uci delete uhttpd.main.listen_http
uci delete uhttpd.main.listen_https
uci add_list uhttpd.main.listen_http='192.168.1.1:5011'

#### Replacing dnsmasq with odhcpd #### 
opkg remove dnsmasq dnsmasq-full odhcpd-ipv6only odhcp6c
opkg install odhcpd odhcp6c
uci -q delete dhcp.@dnsmasq[0]
uci set dhcp.lan.dhcpv4="server"
uci set dhcp.odhcpd.maindhcp="1"
uci set dhcp.odhcpd.leasefile="/var/lib/odhcpd/dhcp.leases"
uci set dhcp.odhcpd.leasetrigger="/usr/lib/unbound/odhcpd.sh"

# #### disable ipv6 ####
# uci del network.lan.ip6assign
# uci set network.lan.delegate='0'
# uci del dhcp.wan6
# # /etc/config/firewall
# uci del firewall.cfg02dc81.network
# uci add_list firewall.cfg02dc81.network='lan'
# uci del firewall.cfg03dc81.network
# uci add_list firewall.cfg03dc81.network='wan'
# # /etc/config/network
# uci del network.wan6
# uci set network.cfg050f15.ipv6='0'
# uci set network.cfg030f15.ipv6='0'

#### Ipv6 config with prefix delegate ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/ipv6/verify_ipv6.sh -O /etc/verify_ipv6.sh
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/ipv6/config_ipv6_with_prefix_delegate -O /etc/init.d/config_ipv6_with_prefix_delegate
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/ipv6/config_ipv6_with_prefix_delegate.sh -O /etc/config_ipv6_with_prefix_delegate.sh
chmod +x /etc/init.d/config_ipv6_with_prefix_delegate
/etc/init.d/config_ipv6_with_prefix_delegate enable

#### crontab ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/crontabs/root -O /etc/crontabs/root
service cron restart

#### rc.local ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/rc/rc.local -O /etc/rc.local

#### dnscrypt-proxy ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/dnscrypt/dnscrypt-proxy.toml -O /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
touch /etc/dnscrypt-proxy2/blocked-names.log
service dnscrypt-proxy restart

#### Knot-resolver ####
# wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/knot-resolver/kresd.config -O /etc/knot-resolver/kresd.config
# wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/knot-resolver/kresd -O /etc/init.d/kresd 

#### Unbound ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/unbound/unbound -O /etc/config/unbound
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/unbound/unbound.conf -O /etc/unbound/unbound.conf
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/unbound/unbound.sh -O /usr/lib/unbound/unbound.sh

#### Sysctl.conf ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/sysctl/sysctl.conf -O /etc/sysctl.conf
sysctl -p

#### Fan ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/fan_control_openwrt/main/fa-fancontrol.sh -O /usr/bin/fa-fancontrol.sh
wget https://raw.githubusercontent.com/ramonalvesmodesto/fan_control_openwrt/main/fa-fancontrol-direct.sh -O /usr/bin/fa-fancontrol-direct.sh
wget https://raw.githubusercontent.com/ramonalvesmodesto/fan_control_openwrt/main/fa-fancontrol -O /etc/init.d/fa-fancontrol
 
chmod +x /etc/init.d/fa-fancontrol
chmod +x /usr/bin/fa-fancontrol.sh
chmod +x /usr/bin/fa-fancontrol-direct.sh
 
service fa-fancontrol enable
service fa-fancontrol start

wget https://raw.githubusercontent.com/hagezi/dns-blocklists/main/wildcard/doh-vpn-proxy-bypass-onlydomains.txt -O /etc/dnscrypt-proxy2/blocked-names.txt 

#### Sqm ####
#uci add sqm queue
uci set sqm.@queue[-1].interface='eth0'
uci set sqm.@queue[-1].enabled='1'
uci set sqm.@queue[-1].download='250000'
uci set sqm.@queue[-1].upload='130000'
uci set sqm.@queue[-1].script='layer_cake.qos'
uci set sqm.@queue[-1].qdisc_advanced='1'
uci set sqm.@queue[-1].squash_dscp='0'
uci set sqm.@queue[-1].squash_ingress='0'
uci set sqm.@queue[-1].ingress_ecn='ECN'
uci set sqm.@queue[-1].egress_ecn='NOECN'
uci set sqm.@queue[-1].qdisc_really_really_advanced='1'
uci set sqm.@queue[-1].iqdisc_opts='nat dual-dsthost ingress diffserv8 rtt 50ms'
uci set sqm.@queue[-1].eqdisc_opts='nat dual-srchost ack-filter diffserv8 rtt 50ms'
uci set sqm.@queue[-1].linklayer='ethernet'
uci set sqm.@queue[-1].overhead='54'

#### system ####
uci del system.ntp.enabled
uci del system.ntp.enable_server
uci set system.@system[0].zonename='America/Sao Paulo'
uci set system.@system[0].timezone='<-03>3'
uci set system.@system[0].log_proto='udp'
uci set system.@system[0].conloglevel='8'
uci set system.@system[0].cronloglevel='5'


uci del dropbear.@dropbear[0].RootPasswordAuth
uci set dropbear.@dropbear[0].Interface='lan'
uci set dropbear.@dropbear[0].Port='2238'
service dropbear restart

/etc/config/network
uci set network.wan.peerdns='0'
uci add_list network.wan.dns='127.0.0.1'
uci set network.wan6.peerdns='0'
uci add_list network.wan6.dns='::1'
uci add_list network.lan.dns='127.0.0.1'


# service kresd restart
# service dropbear disable

#### ntp ####
uci -q delete system.ntp.server
uci set system.ntp.enable_server="1"
uci add_list system.ntp.server="time.google.com"
uci add_list system.ntp.server="time1.google.com"
uci add_list system.ntp.server="time2.google.com"
uci add_list system.ntp.server="time3.google.com"
uci add_list system.ntp.server="time4.google.com"
uci add_list system.ntp.server="time.cloudflare.com"

#### Intercept DNS traffic ####
# /etc/config/firewall
uci add firewall redirect # =cfg103837
uci set firewall.@redirect[-1].target='DNAT'
uci set firewall.@redirect[-1].name='Intercep DNS IPV4'
uci set firewall.@redirect[-1].family='ipv4'
uci set firewall.@redirect[-1].src='lan'
uci set firewall.@redirect[-1].src_dport='53'
uci set firewall.@redirect[-1].dest_port='53'
uci add firewall redirect # =cfg113837
uci set firewall.@redirect[-1].target='DNAT'
uci set firewall.@redirect[-1].name='Intercep DNS IPV6'
uci set firewall.@redirect[-1].family='ipv6'
uci set firewall.@redirect[-1].src='lan'
uci set firewall.@redirect[-1].src_dport='53'
uci set firewall.@redirect[-1].dest_port='53'

## 2. Block DNS-over-TLS over port 853
uci add firewall rule
uci set firewall.@rule[-1].name='Reject-DoT,port 853'
uci add_list firewall.@rule[-1].proto='tcp'
uci set firewall.@rule[-1].src='lan'
uci set firewall.@rule[-1].dest='wan'
uci set firewall.@rule[-1].dest_port='853'
uci set firewall.@rule[-1].target='REJECT'
uci commit firewall

uci add firewall rule
uci set firewall.@rule[-1].name='Reject-Dns,port 53'
uci add_list firewall.@rule[-1].proto='tcp'
uci set firewall.@rule[-1].src='lan'
uci set firewall.@rule[-1].dest='wan'
uci set firewall.@rule[-1].dest_port='53'
uci set firewall.@rule[-1].target='REJECT'
uci commit firewall

#### Ipv6 outros ####
# NET_ULA="$(uci get network.globals.ula_prefix)"
# uci set network.globals.ula_prefix="d${NET_ULA:1}"

# uci set network.globals.ula_prefix=""
uci set network.globals.packet_steering='1'

uci set network.globals.ula_prefix='fdf1:cb1b:35d9::/48'

# ethtool -K eth0 rx-gro-list off && ethtool -K eth1 rx-gro-list off
# ethtool -K eth0 gro off && ethtool -K eth1 gro off
# ethtool -K eth0 rx-udp-gro-forwarding on && ethtool -K eth1 rx-udp-gro-forwarding on
# ethtool --offload eth0 rx off tx off && ethtool --offload eth1 rx off tx off

/etc/init.d/dhcpd enable
/etc/init.d/dhcpd start

uci del network.wan.peerdns
uci set network.wan.proto='static'
uci set network.wan.ipaddr='192.168.2.100'
uci set network.wan.netmask='255.255.255.0'
uci set network.wan.gateway='192.168.2.1'

#### Config NAT64 ####
uci del dhcp.lan.ra
uci del dhcp.lan.ra_default
uci del dhcp.lan.ra_flags
uci del dhcp.lan.dhcpv6
# /etc/config/network
uci del network.lan.ip6assign
uci del network.lan.ip6class

uci set network.lan6=interface
uci set network.lan6.proto='static'
uci set network.lan6.device='br-lan'
uci set network.lan6.ip6assign='64'
uci set network.lan6.ip6hint='64'

uci set dhcp.lan6=dhcp
uci set dhcp.lan6.interface='lan6'
uci set dhcp.lan6.start='100'
uci set dhcp.lan6.limit='150'
uci set dhcp.lan6.leasetime='12h'
uci set dhcp.lan6.ignore='1'
uci set dhcp.lan6.ra='server'
uci set dhcp.lan6.ra_default='1'
uci add_list dhcp.lan6.ra_flags='managed-config'
uci add_list dhcp.lan6.ra_flags='other-config'
uci set dhcp.lan6.dhcpv6='server'
uci add_list network.lan6.ip6class='local'
uci add_list firewall.@zone[0].network='lan6'
uci add_list network.lan6.dns='::1'

wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/jool/setupjool.sh -O /etc/jool/setupjool.sh
chmod +x /etc/jool/setupjool.sh

/etc/jool/setupjool.sh

cat << EOF >> /etc/sysupgrade.conf
/etc/jool/setupjool.sh
EOF

uci set dhcp.jool=dhcp
uci set dhcp.jool.interface='jool'
uci set dhcp.jool.start='100'
uci set dhcp.jool.limit='150'
uci set dhcp.jool.leasetime='12h'
uci set dhcp.jool.ignore='1'
uci set dhcp.jool.ra='server'
uci set dhcp.jool.ra_default='2'
uci add_list dhcp.jool.ra_flags='managed-config'
uci add_list dhcp.jool.ra_flags='other-config'
# uci set dhcp.jool.dhcpv6='server'
# /etc/config/network
uci set network.jool=interface
uci set network.jool.proto='static'
uci set network.jool.device='jool'
uci set network.jool.ipaddr='192.168.164.1'
uci set network.jool.netmask='255.255.255.0'
uci set network.jool.ip6assign='64'
uci set network.jool.ip6hint='64'
uci add_list network.jool.ip6class='local'

uci add network route6 # =cfg0ddf6a
uci set network.@route6[-1].interface='jool'
uci set network.@route6[-1].target='64:ff9b::/96'
uci set network.@route6[-1].gateway='fe80::64'

uci add firewall zone # =cfg0fdc81
uci set firewall.@zone[-1].name='jool'
uci set firewall.@zone[-1].input='ACCEPT'
uci set firewall.@zone[-1].output='ACCEPT'
uci set firewall.@zone[-1].forward='REJECT'
uci add firewall forwarding # =cfg10ad58
uci set firewall.@forwarding[-1].src='jool'
uci set firewall.@forwarding[-1].dest='wan'
uci add_list firewall.@zone[2].network='jool'

uci add firewall forwarding # =cfg11ad58
uci set firewall.@forwarding[-1].src='lan'
uci set firewall.@forwarding[-1].dest='jool'

uci set dhcp.lan6.ra_pref64='64:ff9b::/96'

uci add_list dhcp.lan.dhcp_option='108,0:0:7:8'
uci add_list dhcp.lan6.dhcp_option='108,0:0:7:8'
uci add_list network.lan6.dns='::1'

uci set unbound.ub_main.dns64='1'
uci set unbound.ub_main.dns64_prefix='64:ff9b::/96'

uci commit
service sqm restart
service system restart
service unbound restart
service firewall restart
service odhcpd restart
service uhttpd restart
service sysntpd restart
service network restart
/etc/init.d/config_ipv6_with_prefix_delegate start

#sed -i '/peerdns/d' /lib/netifd/dhcp.script
#sed -i '/peerdns/d' /lib/netifd/dhcpv6.script
#sed -i '/peerdns/d' /lib/netifd/netifd-proto.sh
#sed -i '/peerdns/d' /lib/netifd/netifd-wireless.sh
#sed -i '/peerdns/d' /lib/netifd/ppp-down
#sed -i '/peerdns/d' /lib/netifd/ppp-up
#sed -i '/peerdns/d' /lib/netifd/ppp6-up
#sed -i '/peerdns/d' /lib/netifd/proto/dhcp.sh
#sed -i '/peerdns/d' /lib/netifd/proto/dhcpv6.sh
#sed -i '/peerdns/d' /lib/netifd/proto/ppp.sh
#sed -i '/peerdns/d' /lib/netifd/utils.sh


