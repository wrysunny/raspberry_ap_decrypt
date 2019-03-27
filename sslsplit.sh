#!/usr/bin/env bash

# for raspberry pi 3b
mkdir -p /tmp/sslsplit
# install raspap
wget -q https://git.io/voEUQ -O /tmp/raspap && bash /tmp/raspap

apt-get update && apt-get upgrade -y && apt-get install wget openssl unzip libssl-dev libevent-dev libpcap-dev libnet-dev check -y
# 安装编译依赖
wget -P /tmp/ https://github.com/droe/sslsplit/archive/develop.zip
unzip -q /tmp/develop.zip -d /tmp/
cd /tmp/sslsplit-develop/
make
make install

# 生成私钥和CA证书，PEM格式（crt后缀）
#openssl genrsa -out ca.key 4096
#openssl req -new -x509 -days 3650 -key ca.key -out ca.crt

# 开启ipv4转发
sysctl -w net.ipv4.ip_forward=1

# 清空iptables并配置规则
iptables -t nat -F
iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8443
iptables -t nat -A PREROUTING -p tcp --dport 587 -j REDIRECT --to-ports 8443
iptables -t nat -A PREROUTING -p tcp --dport 465 -j REDIRECT --to-ports 8443
iptables -t nat -A PREROUTING -p tcp --dport 993 -j REDIRECT --to-ports 8443
iptables -t nat -A PREROUTING -p tcp --dport 5222 -j REDIRECT --to-ports 8080

sslsplit -d -k ca.key -c ca.crt -P  https 0.0.0.0 8443  ssl 0.0.0.0 8443 http 0.0.0.0 8080 -F "/tmp/sslsplit/%T-%s-%d.log" &
tcpdump -i wlan0 -s 0 -w /tmp/wlan-decrypt.pcap

# https://blog.kchung.co/recording-and-decrypting-ssl-encrypted-traffic/