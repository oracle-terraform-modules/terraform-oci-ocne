#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

yum update --security

# enable olcne yum channels
yum install -y oracle-olcne-release-el7
yum-config-manager --disable ol7_olcne
yum-config-manager --enable ol7_olcne11 ol7_kvm_utils ol7_addons ol7_latest 
# ol7_UEKR5

# install oci cli
pip3 install oci-cli

# enable chronyd
systemctl enable --now chronyd

# br_netfilter
modprobe br_netfilter
sh -c 'echo "br_netfilter" > /etc/modules-load.d/br_netfilter.conf'

# set SELinux to Permissive
sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
/usr/sbin/setenforce 0

# firewalld
firewall-offline-cmd --add-port=8091/tcp

systemctl restart firewalld

# install the Platform CLI, Platform API Server, and utilities
yum install -y olcnectl olcne-api-server olcne-utils

# enable olcne-api-server
systemctl enable olcne-api-server.service 