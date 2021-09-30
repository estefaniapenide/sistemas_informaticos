#!/bin/bash
echo router > /etc/hostname
/etc/init.d/hostname stop
/etc/init.d/hostname start
echo '127.0.0.1 router localhost' > /etc/hosts
echo '10.0.1.2 PT01' >> /etc/hosts
echo '10.0.2.2 PT02' >> /etc/hosts

/etc/init.d/NetworkManager stop

ifconfig enp0s3 10.0.1.1/24
ifconfig enp0s9 10.0.2.1/24
dhclient
iptables -t nat -F
iptables -t nat -Z

echo "1" > /proc/sys/net/ipv4/ip_forward
iptables -A FORWARD -j ACCEPT

# NAT dinamico
iptables -t nat -A POSTROUTING -o enp0s8 -j MASQUERADE

# NAT statico
#iptables -t nat -A POSTROUTING -o eth2 -j SNAT --to 192.168.1.253

route add -net 10.0.1.0/24 dev enp0s9
route add -net 10.0.2.0/24 dev enp0s3

# Comparto /home por NFS
echo '# /etc/exports: NFS file systems being exported.  See exports(5).' > /etc/exports
echo '/home 192.168.10.1/24 (rw,sync,fsid=0,no_root_squash,no_subtree_check)' >> /etc/exports

# reinicio nfs
/etc/init.d/nfs restart

# Para montar en el cliente
# mount -t nfs 192.168.10.1:/ punto_de_montaje
