#!/bin/bash
# cambio nombre al equipo
echo router > /etc/hostname
/etc/init.d/hostname stop
/etc/init.d/hostname start
echo '127.0.0.1 router localhost' > /etc/hosts
# echo '192.168.31.5 PT01' >> /etc/hosts

# obtengo configuración red externa por dhcp
# dhclient

/etc/init.d/NetworkManager stop

# borro gw poporcionado por dhcp de red interna
route del default enp0s3

# configuro nic interna
ifconfig enp0s3 192.168.31.1/24
route add -net 192.168.31.0/24 dev enp0s3

# inicializo iptables
iptables -t nat -F
iptables -t nat -Z

# activo reenvio
echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -j ACCEPT

# establezco NAT dinamico
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

