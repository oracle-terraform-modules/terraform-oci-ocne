# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# operator nsg and rule
resource "oci_core_network_security_group" "operator" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-operator"
  vcn_id         = var.vcn_id
}

resource "oci_core_network_security_group_security_rule" "operator_internet" {
  network_security_group_id = oci_core_network_security_group.operator.id
  description               = "Internet access"
  destination               = local.anywhere
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  protocol                  = local.all_protocols
  stateless                 = false
  lifecycle {
    ignore_changes = [destination, destination_type, direction, protocol]
  }
}

resource "oci_core_network_security_group_security_rule" "operator" {
  network_security_group_id = oci_core_network_security_group.operator.id
  description               = local.operator_ingress[count.index].description
  direction                 = "INGRESS"
  protocol                  = local.operator_ingress[count.index].protocol
  source                    = local.operator_ingress[count.index].source
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  dynamic "tcp_options" {
    for_each = local.operator_ingress[count.index].protocol == local.tcp_protocol ? list(1) : []
    content {
      destination_port_range {
        min = local.operator_ingress[count.index].port
        max = local.operator_ingress[count.index].port
      }
    }
  }

  count = length(local.operator_ingress)

  lifecycle {
    ignore_changes = [direction, protocol, source, source_type, tcp_options]
  }
}

# master nsg and rule
resource "oci_core_network_security_group" "master" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-master"
  vcn_id         = var.vcn_id
}

resource "oci_core_network_security_group_security_rule" "master_internet" {
  network_security_group_id = oci_core_network_security_group.master.id
  description               = "Internet access"
  destination               = local.anywhere
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  protocol                  = local.all_protocols
  stateless                 = false
  lifecycle {
    ignore_changes = [destination, destination_type, direction, protocol]
  }
}


resource "oci_core_network_security_group_security_rule" "master" {
  network_security_group_id = oci_core_network_security_group.master.id
  description               = local.master_ingress[count.index].description
  direction                 = "INGRESS"
  protocol                  = local.master_ingress[count.index].protocol
  source                    = local.master_ingress[count.index].source
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  dynamic "tcp_options" {
    for_each = local.master_ingress[count.index].protocol == local.tcp_protocol ? list(1) : []

    content {
      destination_port_range {
        min = local.master_ingress[count.index].port
        max = local.master_ingress[count.index].port
      }
    }
  }

  dynamic "udp_options" {
    for_each = local.master_ingress[count.index].protocol == local.udp_protocol ? list(1) : []

    content {
      destination_port_range {
        min = local.master_ingress[count.index].port
        max = local.master_ingress[count.index].port
      }
    }
  }
  count = length(local.master_ingress)

  lifecycle {
    ignore_changes = [direction, protocol, source, source_type, tcp_options]
  }
}

resource "oci_core_network_security_group_security_rule" "master_vrrp" {
  network_security_group_id = oci_core_network_security_group.master.id
  description               = "VRRP protocol for keepalived"
  direction                 = "INGRESS"
  protocol                  = local.vrrp_protocol
  source                    = local.master_subnet
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  lifecycle {
    ignore_changes = [direction, protocol, source, source_type]
  }
}

# worker nsg and rule
resource "oci_core_network_security_group" "worker" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-worker"
  vcn_id         = var.vcn_id
}

resource "oci_core_network_security_group_security_rule" "worker_internet" {
  network_security_group_id = oci_core_network_security_group.worker.id
  description               = "Internet access"
  destination               = local.anywhere
  destination_type          = "CIDR_BLOCK"
  direction                 = "EGRESS"
  protocol                  = local.all_protocols
  stateless                 = false
  lifecycle {
    ignore_changes = [destination, destination_type, direction, protocol]
  }
}

resource "oci_core_network_security_group_security_rule" "worker" {
  network_security_group_id = oci_core_network_security_group.worker.id
  description               = local.worker_ingress[count.index].description
  direction                 = "INGRESS"
  protocol                  = local.worker_ingress[count.index].protocol
  source                    = local.worker_ingress[count.index].source
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  dynamic "tcp_options" {
    for_each = local.worker_ingress[count.index].protocol == local.tcp_protocol ? list(1) : []

    content {
      destination_port_range {
        min = local.worker_ingress[count.index].port
        max = local.worker_ingress[count.index].port
      }
    }
  }

  dynamic "udp_options" {
    for_each = local.worker_ingress[count.index].protocol == local.udp_protocol ? list(1) : []

    content {
      destination_port_range {
        min = local.worker_ingress[count.index].port
        max = local.worker_ingress[count.index].port
      }
    }
  }
  count = length(local.worker_ingress)

  lifecycle {
    ignore_changes = [direction, protocol, source, source_type, tcp_options]
  }
}

resource "oci_core_network_security_group_security_rule" "worker_tcp_nodeport" {
  network_security_group_id = oci_core_network_security_group.worker.id
  description               = "Allow NodePort access from load balancer to ingress controller"
  direction                 = "INGRESS"
  protocol                  = local.tcp_protocol
  source                    = local.pub_lb_subnet
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  tcp_options {
    destination_port_range {
      min = local.node_port_min
      max = local.node_port_max
    }
  }

  lifecycle {
    ignore_changes = [direction, protocol, source, source_type, tcp_options]
  }
}

resource "oci_core_network_security_group_security_rule" "worker_udp_nodeport" {
  network_security_group_id = oci_core_network_security_group.worker.id
  description               = "Allow NodePort access from load balancer to ingress controller"
  direction                 = "INGRESS"
  protocol                  = local.udp_protocol
  source                    = local.pub_lb_subnet
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  udp_options {
    destination_port_range {
      min = local.node_port_min
      max = local.node_port_max
    }
  }

  lifecycle {
    ignore_changes = [direction, protocol, source, source_type, tcp_options]
  }
}
# internal load balancer security group
## TBD

# public load balancer nsg and rule
resource "oci_core_network_security_group" "pub_lb" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-lb"
  vcn_id         = var.vcn_id
}

resource "oci_core_network_security_group_security_rule" "pub_lb" {
  network_security_group_id = oci_core_network_security_group.pub_lb.id
  description               = local.pub_lb_ingress[count.index].description
  direction                 = "INGRESS"
  protocol                  = local.pub_lb_ingress[count.index].protocol
  source                    = local.pub_lb_ingress[count.index].source
  source_type               = "CIDR_BLOCK"
  stateless                 = false

  dynamic "tcp_options" {
    for_each = local.pub_lb_ingress[count.index].protocol == local.tcp_protocol ? list(1) : []
    content {
      destination_port_range {
        min = local.pub_lb_ingress[count.index].port
        max = local.pub_lb_ingress[count.index].port
      }
    }
  }

  count = length(local.pub_lb_ingress)

  lifecycle {
    ignore_changes = [direction, protocol, source, source_type, tcp_options]
  }
}
