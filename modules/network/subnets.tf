# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

resource "oci_core_subnet" "masters" {
  cidr_block                 = local.master_subnet
  compartment_id             = var.compartment_id
  display_name               = "${var.label_prefix}-masters"
  dns_label                  = "masters"
  prohibit_public_ip_on_vnic = true
  route_table_id             = var.nat_route_id
  vcn_id                     = var.vcn_id
}

# resource "oci_core_subnet" "operator" {
#   cidr_block                 = local.operator_subnet
#   compartment_id             = var.compartment_id
#   display_name               = "${var.label_prefix}-operator"
#   dns_label                  = "operator"
#   prohibit_public_ip_on_vnic = true
#   route_table_id             = var.nat_route_id
#   vcn_id                     = var.vcn_id
# }

resource "oci_core_subnet" "workers" {
  cidr_block                 = local.worker_subnet
  compartment_id             = var.compartment_id
  display_name               = "${var.label_prefix}-workers"
  dns_label                  = "workers"
  prohibit_public_ip_on_vnic = true
  route_table_id             = var.nat_route_id
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "int_lb" {
  cidr_block                 = local.int_lb_subnet
  compartment_id             = var.compartment_id
  display_name               = "${var.label_prefix}-int-lb"
  dns_label                  = "intlb"
  prohibit_public_ip_on_vnic = true
  route_table_id             = var.nat_route_id
  vcn_id                     = var.vcn_id
}

resource "oci_core_subnet" "pub_lb" {
  cidr_block                 = local.pub_lb_subnet
  compartment_id             = var.compartment_id
  display_name               = "${var.label_prefix}-pub-lb"
  dns_label                  = "publb"
  prohibit_public_ip_on_vnic = false
  route_table_id             = var.ig_route_id
  vcn_id                     = var.vcn_id
}
