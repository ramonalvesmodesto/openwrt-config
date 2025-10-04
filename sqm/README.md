``` bash
#### sqm simplest fq ####
#wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/refs/heads/main/sqm/simplest_tbf_with_fq.qos -O /usr/lib/sqm/simplest_tbf_with_fq.qos
wget https://raw.githubusercontent.com/ramonmodesto18/openwrt-config/refs/heads/main/sqm/simple2.qos -O /usr/lib/sqm/simple.qos

#### Sqm ####
#uci set sqm.@queue[-1].interface='eth1'
#uci set sqm.@queue[-1].enabled='1'
#uci set sqm.@queue[-1].download='600000'
#uci set sqm.@queue[-1].upload='300000'
#uci set sqm.@queue[-1].qdisc='fq_codel'
#uci set sqm.@queue[-1].script='simple.qos'
#uci set sqm.@queue[-1].qdisc_advanced='1'
#uci set sqm.@queue[-1].squash_dscp='0'
#uci set sqm.@queue[-1].squash_ingress='0'
#uci set sqm.@queue[-1].ingress_ecn='ECN'
#uci set sqm.@queue[-1].egress_ecn='ECN'
#uci set sqm.@queue[-1].qdisc_really_really_advanced='1'
#uci set sqm.@queue[-1].iqdisc_opts='nat dual-dsthost ingress diffserv4'
#uci set sqm.@queue[-1].eqdisc_opts='nat dual-srchost ack-filter diffserv4'

```
