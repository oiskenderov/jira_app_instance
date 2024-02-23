#!/bin/bash

echo "redirect 8080 to 80"
iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 8080 -j ACCEPT
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 80 -j REDIRECT --to-port 8080

echo "80 loopback"
iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-port 8080



echo "set ssl 443 to 8443"
iptables -A INPUT -i eth0 -p tcp --dport 443 -j ACCEPT
iptables -A INPUT -i eth0 -p tcp --dport 8443 -j ACCEPT
iptables -A PREROUTING -t nat -i eth0 -p tcp --dport 443 -j REDIRECT --to-port 8443

echo "Loopback"
iptables -t nat -I OUTPUT -p tcp -o lo --dport 443 -j REDIRECT --to-port 8443

