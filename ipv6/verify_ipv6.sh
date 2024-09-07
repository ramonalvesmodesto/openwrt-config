#!/bin/sh

status_code=$(curl -I ip6only.me 2>/dev/null | head -n 1 | cut -d$' ' -f2)

if [ "$status_code" == "" ]
then
        /bin/sh /etc/config_ipv6_with_prefix_delegate.sh
elif [ "$status_code" -eq "200" ]
then
	echo 'Status ok'
fi
