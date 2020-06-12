#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# enable olcne yum channels
sudo yum install -y oracle-olcne-release-el7
sudo yum-config-manager --disable ol7_olcne
sudo yum-config-manager --enable ol7_olcne11 ol7_kvm_utils ol7_addons ol7_latest 
# ol7_UEKR5

# install oci cli
sudo pip3 install oci-cli

# enable chronyd
sudo yum install -y chrony
sudo systemctl enable --now chronyd

# br_netfilter
sudo modprobe br_netfilter
sudo sh -c 'echo "br_netfilter" > /etc/modules-load.d/br_netfilter.conf'

# set SELinux to Permissive
sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config
sudo /usr/sbin/setenforce 0

# firewalld
sudo firewall-offline-cmd --add-port=8091/tcp

sudo systemctl restart firewalld

# install the Platform CLI, Platform API Server, and utilities
sudo yum install -y olcnectl olcne-api-server olcne-utils

# enable olcne-api-server
sudo systemctl enable olcne-api-server.service 