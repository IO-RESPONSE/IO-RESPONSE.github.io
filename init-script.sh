#!/bin/bash
MAC=$(ip a |grep link |grep -v "inet6"|grep -v "00:00:00"|awk '{print $2}')
DEV=$(ip a |grep BROADCAST|awk '{print $2}'|cut -d: -f1)
UUID=$(nmcli connection|grep $DEV|awk '{print $2}')
IP=$(ip a |grep inet |grep -v inet6|grep -v "127.0.0.1"|awk '{print $2}'|cut -d/ -f1)
file=$(find  /etc/sysconfig/network-scripts -name "ifcfg-e*")
cat <<EOF > /tmp/network
TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
IPADDR=$IP
PREFIX=24
GATEWAY=10.0.4.1
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
NAME="$DEV"
DNS1=8.8.8.8
DNS2=8.8.4.4
UUID=$UUID
DEVICE=$DEV
ONBOOT="yes"
EOF
cat /tmp/network > $file
systemctl restart network

cat <<EOF >> /etc/hosts
10.0.4.100	km1	km1.ioresponse.net
10.0.4.98		km2	km2.ioresponse.net
10.0.4.17		km3	km3.ioresponse.net
10.0.4.121	kn1	kn1.ioresponse.net
10.0.4.11		kn2	kn2.ioresponse.net
10.0.4.6		kn3	kn3.ioresponse.net
10.0.4.32		kn4	kn4.ioresponse.net
10.0.4.26		kn5	kn5.ioresponse.net
EOF

hostnamectl set-hostname $(cat /etc/hosts|grep $IP|awk '{print $3}'
reboot
