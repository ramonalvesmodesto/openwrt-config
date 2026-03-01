```bash
#### dnscrypt-proxy ####
#wget https://raw.githubusercontent.com/ramonalvesmodesto/openwrt-config/main/dnscrypt/dnscrypt-proxy.toml -O /etc/dnscrypt-proxy2/dnscrypt-proxy.toml
sed -i "32 s/.*/server_names = ['cloudflare', 'cloudflare-ipv6']/" /etc/dnscrypt-proxy2/*.toml
sed -i "163 s/.*/edns_client_subnet = ['0.0.0.0\/0', '2001:db8::\/32']/" /etc/dnscrypt-proxy2/*.toml
sed -i "150 s/.*/timeout = 5000/" /etc/dnscrypt-proxy2/*.toml
sed -i "155 s/.*/keepalive = 60/" /etc/dnscrypt-proxy2/*.toml
sed -i "283 s/.*/dnscrypt_ephemeral_keys = true/" /etc/dnscrypt-proxy2/*.toml
sed -i '15 s/.*/        procd_set_param command "$PROG" -child -config "$CONFIGFILE"/' /etc/init.d/dnscrypt-proxy
sed -i "40 s/.*/listen_addresses = ['127.0.0.100:53', '[::100]:53']/" /etc/dnscrypt-proxy2/*.toml
sed -i '304 s/.*/tls_cipher_suite = [52392]/' /etc/init.d/dnscrypt-proxy
sed -i '66 s/.*/ipv6_servers = true/' /etc/dnscrypt-proxy2/*.toml
sed -i '349 s/.*/# bootstrap_resolvers = ['9.9.9.11:53', '8.8.8.8:53']/' /etc/dnscrypt-proxy2/*.toml
sed -i '304 s/.*/tls_cipher_suite = [52393]/' /etc/dnscrypt-proxy2/*.toml

service dnscrypt-proxy restart
```
