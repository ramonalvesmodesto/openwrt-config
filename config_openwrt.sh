
opkg update

#### Install packages ####
opkg install jq curl openssl-util isc-dhcp-client-ipv6 bash luci-app-unbound unbound-control coreutils-nohup nano luci procps-ng-sysctl libxtables12 libelf1 luci-app-sqm ip-full bind-dig cqueues kmod-tcp-bbr kmod-tcp-hybla  openssh-sftp-client openssh-sftp-server tc-full dnscrypt-proxy2 kmod-sched-ctinfo tcpdump 
# opkg install mcproxy irqbalance knot-resolver

#### uhttpd ####
uci delete uhttpd.main.listen_http
uci delete uhttpd.main.listen_https
uci add_list uhttpd.main.listen_http='192.168.1.1:5011'
uci commit uhttpd
service uhttpd restart

#### Replacing dnsmasq with odhcpd #### 
opkg remove dnsmasq dnsmasq-full odhcpd-ipv6only
opkg install odhcpd odhcp6c
uci -q delete dhcp.@dnsmasq[0]
uci set dhcp.lan.dhcpv4="server"
uci set dhcp.odhcpd.maindhcp="1"
uci set dhcp.odhcpd.leasefile="/var/lib/odhcpd/dhcp.leases"
uci set dhcp.odhcpd.leasetrigger="/usr/lib/unbound/odhcpd.sh"
uci commit dhcp
service odhcpd restart

#### Ipv6 config with prefix delegate ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/ipv6/verify_ipv6.sh -O /etc/verify_ipv6.sh
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/ipv6/config_ipv6_with_prefix_delegate -O /etc/init.d/config_ipv6_with_prefix_delegate
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/ipv6/config_ipv6_with_prefix_delegate.sh -O /etc/config_ipv6_with_prefix_delegate.sh
chmod +x /etc/init.d/config_ipv6_with_prefix_delegate
/etc/init.d/config_ipv6_with_prefix_delegate enable
/etc/init.d/config_ipv6_with_prefix_delegate start

#### crontab ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/crontabs/root -O /etc/crontabs/root
service cron restart

#### rc.local ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/rc/rc.local -O /etc/rc.local

#### dnscrypt-proxy ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/dnscrypt/dnscrypt-proxy.toml -O /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
service dnscrypt-proxy restart

#### Knot-resolver ####
# wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/knot-resolver/kresd.config -O /etc/knot-resolver/kresd.config
# wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/knot-resolver/kresd -O /etc/init.d/kresd 

#### Unbound ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/unbound/unbound -O /etc/config/unbound
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/unbound/unbound.conf -O /etc/unbound/unbound.conf

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

#### Sqm ####
# uci add sqm queue
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
uci set sqm.@queue[-1].iqdisc_opts='nat dual-dsthost ingress diffserv4 rtt 300000'
uci set sqm.@queue[-1].eqdisc_opts='nat dual-srchost ack-filter diffserv4 rtt 300000'
uci set sqm.@queue[-1].linklayer='ethernet'
uci set sqm.@queue[-1].overhead='44'
uci commit sqm
service sqm restart

#### system ####
uci del system.ntp.enabled
uci del system.ntp.enable_server
uci set system.@system[0].zonename='America/Sao Paulo'
uci set system.@system[0].timezone='<-03>3'
uci set system.@system[0].log_proto='udp'
uci set system.@system[0].conloglevel='8'
uci set system.@system[0].cronloglevel='5'
uci commit system
service system restart

uci del dropbear.@dropbear[0].RootPasswordAuth
uci set dropbear.@dropbear[0].Interface='lan'
uci set dropbear.@dropbear[0].Port='2238'
uci commit dropbear
service dropbear restart

# /etc/config/network
uci set network.wan.peerdns='0'
uci add_list network.wan.dns='127.0.0.1'
uci set network.wan6.peerdns='0'
uci add_list network.wan6.dns='::1'
uci add_list network.lan.dns='127.0.0.1'
uci del network.lan.ip6class
uci add_list network.lan.ip6class='local'
uci set network.globals.packet_steering='1'
uci commit network
service network restart
# service kresd restart
service dropbear disable

#### ntp ####
uci -q delete system.ntp.server
uci set system.ntp.enable_server="1"
uci add_list system.ntp.server="0.br.pool.ntp.org"
uci add_list system.ntp.server="1.br.pool.ntp.org"
uci add_list system.ntp.server="2.br.pool.ntp.org"
uci add_list system.ntp.server="3.br.pool.ntp.org"
uci add_list system.ntp.server="time.google.com"
uci add_list system.ntp.server="time1.google.com"
uci add_list system.ntp.server="time2.google.com"
uci add_list system.ntp.server="time3.google.com"
uci add_list system.ntp.server="time4.google.com"
uci add_list system.ntp.server="time.cloudflare.com"
uci commit system
service sysntpd restart

# Intercept DNS traffic
uci -q del firewall.dns_int
uci set firewall.dns_int="redirect"
uci set firewall.dns_int.name="Intercept-DNS"
uci set firewall.dns_int.family="any"
uci set firewall.dns_int.proto="tcp udp"
uci set firewall.dns_int.src="lan"
uci set firewall.dns_int.src_dport="53"
uci set firewall.dns_int.target="DNAT"
uci commit firewall
service firewall restart

#### Ipv6 outros ####
NET_ULA="$(uci get network.globals.ula_prefix)"
uci set network.globals.ula_prefix="d${NET_ULA:1}"

uci set network.lan.ip6class="local"
uci set dhcp.lan.ra_default="1"
uci commit dhcp
service odhcpd restart

uci set network.wan.ip4table='local'
uci set network.wan.ip6table='local'
uci set network.lan.ip4table='local'
uci set network.lan.ip6table='local'

uci commit
service network restart
service unbound restart

ethtool -K eth0 rx-gro-list off && ethtool -K eth1 rx-gro-list off
ethtool -K eth0 gro off && ethtool -K eth1 gro off
ethtool -K eth0 rx-udp-gro-forwarding on && ethtool -K eth1 rx-udp-gro-forwarding on
