#!/bin/bash

#NET_ULA="$(uci get network.globals.ula_prefix)"
#uci set network.globals.ula_prefix="d${NET_ULA:1}"

uci set network.lan.ip6class="local"
uci set dhcp.lan.ra_default="1"

arrPortsNameVlan=()
increment=10

for portlan in $(uci get network.@device[0].ports)
do
    if [[ "$increment" -eq 10 ]]; then

        uci add network bridge-vlan # =cfg09a1b0
        uci set network.@bridge-vlan[-1].device='br-lan'
        uci set network.@bridge-vlan[-1].vlan="$increment"
        uci add_list network.@bridge-vlan[-1].ports="$portlan:u*"
        uci set network.lan.device="br-lan.$increment"

    else
        # /etc/config/dhcp
        uci set dhcp."vlan$increment"=dhcp
        uci set dhcp."vlan$increment".interface="vlan$increment"
        uci set dhcp."vlan$increment".start='100'
        uci set dhcp."vlan$increment".limit='150'
        uci set dhcp."vlan$increment".leasetime='12h'
        #### Firewall ####
        uci add firewall zone # =cfg0fdc81
        uci set firewall.@zone[-1].name="vlan$increment"
        uci set firewall.@zone[-1].input='ACCEPT'
        uci set firewall.@zone[-1].output='ACCEPT'
        uci set firewall.@zone[-1].forward='ACCEPT'
        uci add firewall forwarding # =cfg10ad58
        uci set firewall.@forwarding[-1].src="vlan$increment"
        uci set firewall.@forwarding[-1].dest='wan'
        uci add_list firewall.@zone[-1].network="vlan$increment"
        # /etc/config/network
        uci add network bridge-vlan # =cfg09a1b0
        uci set network.@bridge-vlan[-1].device='br-lan'
        uci set network.@bridge-vlan[-1].vlan="$increment"
        uci add_list network.@bridge-vlan[-1].ports="$portlan:u*"
        uci set network."vlan$increment"=interface
        uci set network."vlan$increment".proto='static'
        uci set network."vlan$increment".device="br-lan.$increment"
        uci set network."vlan$increment".ipaddr="192.168.$increment.1"
        uci set network."vlan$increment".netmask='255.255.255.0'
    fi

    echo $portlan
    
    arrPortsNameVlan+=("$portlan.$increment")
    increment=$(($increment+10))
    echo $increment
done

uci commit
reboot
