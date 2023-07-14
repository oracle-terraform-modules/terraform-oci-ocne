# Copyright (c) 2023 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_vcn" "vcn" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_id
  display_name   = var.prefix == "none" ? var.vcn_name : "${var.prefix}-${var.vcn_name}"
  dns_label      = var.vcn_dns_label

  freeform_tags = var.freeform_tags
}

resource "oci_core_internet_gateway" "ig" {
  compartment_id = var.compartment_id
  display_name   = var.prefix == "none" ? "internet-gateway" : "${var.prefix}-internet-gateway"

  freeform_tags = var.freeform_tags

  vcn_id = oci_core_vcn.vcn.id

  count = var.internet_gateway_enabled == true ? 1 : 0
}

resource "oci_core_route_table" "ig" {
  compartment_id = var.compartment_id
  display_name   = var.prefix == "none" ? "internet-route" : "${var.prefix}-internet-route"

  freeform_tags = var.freeform_tags

  route_rules {
    destination       = local.anywhere
    network_entity_id = oci_core_internet_gateway.ig[0].id
  }

  vcn_id = oci_core_vcn.vcn.id

  count = var.internet_gateway_enabled == true ? 1 : 0
}
