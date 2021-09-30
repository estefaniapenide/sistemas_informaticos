#!/bin/bash
/etc/init.d/NetworkManager stop
ifconfig enp0s3 10.0.1.2/24
route add default gw 10.0.1.1
echo 'nameserver 8.8.8.8' > /etc/resolv.conf
echo PT01 > /etc/hostname
echo '127.0.0.1 PT01 localhost' > /etc/hosts
/etc/init.d/hostname stop
/etc/init.d/hostname start
