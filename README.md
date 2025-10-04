# Configurações opnwrt

```bash
uci set wireless.radio0.country='BR'
uci set wireless.radio0.cell_density='0'
uci set wireless.default_radio0.ssid='Openwrt'
uci set wireless.default_radio0.encryption='psk2'
uci set wireless.default_radio0.key='Devm#ucRiptY25*%'
uci set wireless.radio1.country='BR'
uci set wireless.radio1.cell_density='0'
uci set wireless.default_radio1.ssid='Openwrt_5G'
uci set wireless.default_radio1.encryption='psk2'
uci set wireless.default_radio1.key='Devm#ucRiptY25*%'
uci set wireless.radio0.disabled='0'
uci set wireless.radio1.disabled='0'
uci set wireless.default_radio0.isolate='1'
uci set wireless.default_radio1.isolate='1'
uci set wireless.radio0.txpower='22'
uci set wireless.radio1.txpower='22'
uci set wireless.radio1.htmode='VHT80'
uci set wireless.radio1.channel='36'

uci add system led # =cfg038bba
uci set system.@led[-1].sysfs='blue:status'
uci set system.@led[-1].trigger='none'
uci set system.@led[-1].default='0'
uci add system led # =cfg048bba
uci set system.@led[-1].sysfs='green:power'
uci set system.@led[-1].trigger='none'
uci set system.@led[-1].default='0'
uci add system led # =cfg058bba
uci set system.@led[-1].sysfs='mt76-phy0'
uci set system.@led[-1].trigger='none'
uci set system.@led[-1].default='0'
uci add system led # =cfg068bba
uci set system.@led[-1].sysfs='mt76-phy1'
uci set system.@led[-1].trigger='none'
uci set system.@led[-1].default='0'

uci commit
/etc/init.d/network restart

#opkg list-installed | grep i18n | cut -f 1 -d ' ' | xargs opkg remove
#opkg list-upgradable | cut -f 1 -d ' ' | xargs opkg upgrade

apk update --allow-untrusted

apk add --allow-untrusted luci bash kmod-sched kmod-sched-core kmod-sched-bpf openssh-sftp-client openssh-sftp-server cloudflared kmod-tcp-hybla htop  irqbalance libopenssl-afalg_sync kmod-tcp-bbr ethtool-full nano luci procps-ng-sysctl tc-full luci-proto-wireguard
apk add parted lsblk resize2fs cfdisk fdisc

uci set irqbalance.irqbalance.enabled='1'

#### Cloudflared instancia ####
wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/cloud/cloud -O /etc/init.d/cloud
sed -i "7s/.*/    procd_set_param command \/usr\/bin\/cloudflared --no-autoupdate --protocol http2 tunnel run --token eyJhIjoiMjJlMjVlM2M0OTliZTcwMmRlNTg0MTM0N2MwZTNmNzAiLCJ0IjoiYWY2MTJjNDEtMjA1OS00MWIzLWE1MmQtODNjMjFhMjI5YjQ1IiwicyI6Ik5tSTRZemcxTm1RdE5XUm1NaTAwTnpCbExXRmpNVEF0TlRReU5Ea3lZVFkxWlRJMiJ9/" /etc/init.d/cloud
chmod +x /etc/init.d/cloud
service cloud enable
service cloud start

cp /www/luci-static/bootstrap/cascade.css /www/luci-static/bootstrap/cascade.css.bk
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/refs/heads/main/css/cascade.css -O /www/luci-static/bootstrap/cascade.css

#### uhttpd ####
uci delete uhttpd.main.listen_http
uci delete uhttpd.main.listen_https
uci add_list uhttpd.main.listen_http='192.168.1.1:5011'

echo 'nameserver 9.9.9.9' > /etc/resolv.conf
## Replacing dnsmasq with dnsmasq-full #### 
apk del dnsmasq odhcpd-ipv6only dnsmasq
akp add dnsmasq-full

service dnsmasq stop
#uci set dhcp.@dnsmasq[0].noresolv="1"
uci set dhcp.@dnsmasq[0].cachesize='0'
uci -q delete dhcp.@dnsmasq[0].server
uci add_list dhcp.@dnsmasq[0].server="172.64.36.1"
uci commit dhcp
service dnsmasq start
service dnscrypt-proxy restart

#### crontab ####
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/main/crontabs/root -O /etc/crontabs/root
service cron restart

#### rc.local ####
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/main/rc/rc.local -O /etc/rc.local

#### Sysctl.conf ####
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/main/sysctl/sysctl.conf -O /etc/sysctl.conf
sed -i "42s/.*/                [ -f \"\$CONF\" ] \&\& sysctl -e -p \"\$CONF\" 3\>\&-/" /etc/init.d/sysctl 
sysctl -p

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

uci set network.wan.peerdns='0'
uci set network.wan6.peerdns='0'
uci set network.wan6.device='@wan'

#### ntp ####
uci -q delete system.ntp.server
uci add_list system.ntp.server="a.st1.ntp.br"
uci add_list system.ntp.server="b.st1.ntp.br"
uci add_list system.ntp.server="c.st1.ntp.br"
uci add_list system.ntp.server="d.st1.ntp.br"

#########

uci set dhcp.lan.ra_default='2'
uci set dhcp.wan6=dhcp
uci set dhcp.wan6.interface='wan6'
uci set dhcp.wan6.ignore='1'
uci set dhcp.wan6.master='1'
uci set dhcp.wan6.ra='relay'
uci set dhcp.wan6.dhcpv6='relay'

uci set network.wan.ipv6='1'
uci set network.wan6.reqaddress='try'
uci set network.wan6.reqprefix='auto'
uci set network.wan6.norelease='1'

uci set network.globals.packet_steering='2'

uci set network.lan.ip6hint='60'
uci set dhcp.lan.ra_slaac='1'

uci del dhcp.lan.ra_flags
uci add_list dhcp.lan.ra_flags='managed-config'
uci add_list dhcp.lan.ra_flags='other-config'


uci del network.wan6.sourcefilter
uci del network.wan.sourcefilter

uci del network.globals.ula_prefix
uci set system.ntp.enable_server='1'

# /etc/config/dhcp
uci del dhcp.lan.ra_slaac
uci set dhcp.lan.ra='server'
uci set dhcp.lan.dhcpv6='server'


uci set network.wan.force_link='1'
uci set network.wan6.force_link='1'

uci set network.wan6.sourcefilter="0"
uci set network.cloud.sourcefilter="0"

uci set dhcp.lan.ra_useleasetime='1'
uci set dhcp.wan6.ra_useleasetime='1'

uci set dhcp.lan.ra_slaac='0'
uci del dhcp.lan.ra_flags
uci add_list dhcp.lan.ra_flags='managed-config'
uci add_list dhcp.lan.ra_flags='other-config'
uci add_list dhcp.lan.ra_flags='home-agent'


### Altera configurações icmp para aumento de performance de rede ####
uci add firewall rule # =cfg1092bd
uci set firewall.@rule[-1].src='wan'
uci set firewall.@rule[-1].name='Allow-Ping-Forward'
uci add_list firewall.@rule[-1].proto='icmp'
uci add_list firewall.@rule[-1].icmp_type='destination-unreachable'
uci add_list firewall.@rule[-1].icmp_type='echo-reply'
uci add_list firewall.@rule[-1].icmp_type='echo-request'
uci add_list firewall.@rule[-1].icmp_type='fragmentation-needed'
uci set firewall.@rule[-1].limit='400/sec'
uci set firewall.@rule[-1].target='ACCEPT'

# Allow-ICMPv6-Forward'
uci set firewall.@rule[6].icmp_type='destination-unreachable' 'echo-reply' 'echo-request' 'fragmentation-needed'
uci set firewall.@rule[9].limit='400/sec'

# Allow-ICMPv6-Input
uci set firewall.@rule[5].limit='400/sec'

#### PPP ####
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/refs/heads/main/ppp/ppp.sh -O /lib/netifd/proto/ppp.sh
#wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/refs/heads/main/ppp/ppp-up -O /lib/netifd/ppp-up


uci commit
service firewall restart
service sqm restart
service system restart
service unbound restart
service odhcpd restart
service uhttpd restart
service sysntpd restart
service led restart
service irqbalance start
service irqbalance restart
service irqbalance enable
service network restart
service sysctl restart
```
