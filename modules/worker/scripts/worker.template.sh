#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

yum update --security

# enable olcne yum channels
yum install -y oracle-olcne-release-el7
yum-config-manager --disable ol7_olcne
yum-config-manager --enable ol7_olcne11 ol7_kvm_utils ol7_addons ol7_latest 
# ol7_UEKR5

# enable chronyd
systemctl enable --now chronyd

# disable swap
swapoff -a
sed -i '/swap/d' /etc/fstab

# br_netfilter
modprobe br_netfilter
sh -c 'echo "br_netfilter" > /etc/modules-load.d/br_netfilter.conf'

# set SELinux to Permissive
sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
/usr/sbin/setenforce 0

# firewalld
firewall-offline-cmd --zone=trusted --add-interface=cni0

for z in public
do
  firewall-offline-cmd --zone=$z --add-interface=ens3
  firewall-offline-cmd --zone=$z --add-port=8090/tcp
  firewall-offline-cmd --zone=$z --add-port=10250/tcp
  firewall-offline-cmd --zone=$z --add-port=10255/tcp
  firewall-offline-cmd --zone=$z --add-port=8472/udp
done

firewall-offline-cmd --set-default-zone=public
systemctl restart firewalld

# install the Platform Agent package and utilities
yum install -y olcne-agent olcne-utils

# enable agent
systemctl enable --now olcne-agent.service