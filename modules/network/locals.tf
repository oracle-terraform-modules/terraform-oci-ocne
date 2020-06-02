# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  # subnet cidrs - used by subnets
  bastion_subnet  = cidrsubnet(data.oci_core_vcn.vcn.cidr_block, var.newbits["bastion"], var.netnum["bastion"])
  int_lb_subnet   = cidrsubnet(data.oci_core_vcn.vcn.cidr_block, var.newbits["lb"], var.netnum["int_lb"])
  master_subnet   = cidrsubnet(data.oci_core_vcn.vcn.cidr_block, var.newbits["masters"], var.netnum["masters"])
  operator_subnet = cidrsubnet(data.oci_core_vcn.vcn.cidr_block, var.newbits["operator"], var.netnum["operator"])
  pub_lb_subnet   = cidrsubnet(data.oci_core_vcn.vcn.cidr_block, var.newbits["lb"], var.netnum["pub_lb"])
  worker_subnet   = cidrsubnet(data.oci_core_vcn.vcn.cidr_block, var.newbits["workers"], var.netnum["workers"])

  anywhere = "0.0.0.0/0"

  # port numbers
  node_port_min = 30000

  node_port_max = 32767

  ssh_port = 22

  # protocols
  # # special oci designation for all protocols
  all_protocols = "all"

  # # IANA protocol numbers
  icmp_protocol = 1

  tcp_protocol = 6

  udp_protocol = 17

  vrrp_protocol = 112

  # nsgs
  operator_ingress = [
    {
      description = "Allow ssh access from bastion",
      protocol    = local.tcp_protocol, port = local.ssh_port,
      source      = local.bastion_subnet
    },
    {
      description = "Allow access to Platform API Server",
      protocol    = local.tcp_protocol, port = 8091,
      source      = data.oci_core_vcn.vcn.cidr_block
    }
  ]

  master_ingress = [
    {
      description = "Allow ssh access from bastion",
      protocol    = local.tcp_protocol, port = local.ssh_port,
      source      = local.bastion_subnet
    },
    {
      description = "Allow ssh from operator node",
      protocol    = local.tcp_protocol, port = local.ssh_port,
      source      = local.operator_subnet
    },
    {
      description = "Kubernetes etcd server client API (multi-master)",
      protocol    = local.tcp_protocol, port = 2379,
      source      = local.master_subnet
    },
    {
      description = "Kubernetes etcd server client API (multi-master)",
      protocol    = local.tcp_protocol, port = 2380,
      source      = local.master_subnet
    },
    {
      description = "Kubernetes API server access from master",
      protocol    = local.tcp_protocol, port = 6443,
      source      = local.master_subnet
    },
    {
      description = "Kubernetes API server access from operator",
      protocol    = local.tcp_protocol, port = 6443,
      source      = local.operator_subnet
    },
    {
      description = "Kubernetes API server access from worker",
      protocol    = local.tcp_protocol, port = 6443,
      source      = local.worker_subnet
    },
    {
      description = "Kubernetes API server access from master (multimaster)",
      protocol    = local.tcp_protocol, port = 6444,
      source      = local.master_subnet
    },
    {
      description = "Kubernetes API server access from operator (multimaster)",
      protocol    = local.tcp_protocol, port = 6444,
      source      = local.operator_subnet
    },
    {
      description = "Kubernetes API server access from worker (multimaster)",
      protocol    = local.tcp_protocol, port = 6444,
      source      = local.worker_subnet
    },
    {
      description = "Allow operator to access Platform agent",
      protocol    = local.tcp_protocol, port = 8090,
      source      = local.operator_subnet
    },
    {
      description = "Kubernetes kubelet API server",
      protocol    = local.tcp_protocol, port = 10250,
      source      = local.master_subnet
    },
    {
      description = "Kubernetes kube-scheduler (multi-master)",
      protocol    = local.tcp_protocol, port = 10251,
      source      = local.master_subnet
    },
    {
      description = "Kubernetes kube-controller-manager (multi-master)",
      protocol    = local.tcp_protocol, port = 10252,
      source      = local.master_subnet
    },
    {
      description = "Kubernetes kubelet API server",
      protocol    = local.tcp_protocol, port = 10255,
      source      = local.master_subnet
    },
    {
      description = "Flannel overlay network, VxLAN backend",
      protocol    = local.udp_protocol, port = 8472,
      source      = local.master_subnet
    },
    {
      description = "Flannel overlay network, VxLAN backend",
      protocol    = local.udp_protocol, port = 8472,
      source      = local.worker_subnet
    },
  ]

  worker_ingress = [
    {
      description = "Allow ssh access from bastion",
      protocol    = local.tcp_protocol, port = local.ssh_port,
      source      = local.bastion_subnet
    },
    {
      description = "Allow ssh from operator node",
      protocol    = local.tcp_protocol, port = local.ssh_port,
      source      = local.operator_subnet
    },
    {
      description = "Allow operator to access Platform agent",
      protocol    = local.tcp_protocol, port = 8090,
      source      = local.operator_subnet
    },
    {
      description = "Kubernetes kubelet API server",
      protocol    = local.tcp_protocol, port = 10250,
      source      = local.master_subnet
    },
    {
      description = "Kubernetes kubelet API server",
      protocol    = local.tcp_protocol, port = 10255,
      source      = local.master_subnet
    },
    {
      description = "Flannel overlay network, VxLAN backend",
      protocol    = local.udp_protocol, port = 8472,
      source      = local.master_subnet
    },
    {
      description = "Flannel overlay network, VxLAN backend",
      protocol    = local.udp_protocol, port = 8472,
      source      = local.worker_subnet
    }
  ]

  pub_lb_ingress = [
    {
      description = "Allow http access from public load balancer",
      protocol    = local.tcp_protocol, port = 80,
      source      = local.anywhere
    },
    {
      description = "Allow https access from anywhere",
      protocol    = local.tcp_protocol, port = 443,
      source      = local.anywhere
    },
  ]

}
