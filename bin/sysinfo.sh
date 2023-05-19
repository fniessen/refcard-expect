#!/bin/bash

#
# sysinfo.sh
#
# 2008 - Mike Golvach - eggi@comcast.net
#
# Creative Commons Attribution-Noncommercial-Share Alike 3.0 United States License
#

echo -n "hostname:  "
/bin/hostname
echo

echo -n "model:   "
/bin/uname -pm
echo

echo -n "cpu count: "
/bin/dmesg|grep CPU|awk -F: '{print $1}'|sort -u|wc -l
echo

echo -n "disks online: "
fdisk -l|awk '{print $1}'|grep \/dev\/|sed 's/[1234567890]//'|sort -u|wc -l
echo

echo "disk types:"
echo
fdisk -l|awk '{print $1}'|grep \/dev\/|sed 's/[1234567890]//'|sed 's/\/dev\///'|sort -u|xargs -iboink grep "^boink" /var/log/dmesg
echo

echo "dns name and aliases:"
echo
nslookup `hostname`|grep Name;nslookup `hostname`|sed -n '/Alias/,$p'
echo

echo "Interfaces:"
echo
netstat -in|grep -v Kernel|grep -v Iface|grep -v lo|awk '{print $1}'|xargs -iboink cat /etc/sysconfig/network-scripts/ifcfg-boink|sed -n 1,2p
echo

echo "Access Restrictions:"
echo
if [ -f /etc/hosts.allow ]
then
 cat /etc/hosts.allow
else
 echo "No host based access restrictions in place"
fi
echo
echo -n "OS Release: "
uname -r
