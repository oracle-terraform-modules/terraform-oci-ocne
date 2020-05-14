# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_core_services" "all_oci_services" {
  filter {
    name   = "name"
    values = ["All .* Services In Oracle Services Network"]
    regex  = true
  }
  count = var.olcne_network_vcn.is_service_gateway_enabled == true ? 1 : 0
}

data "oci_core_subnets" "olcne_subnets" {
  compartment_id = var.olcne_general.compartment_id
  vcn_id         = var.olcne_network_vcn.vcn_id

  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
}

data "oci_core_vcn" "olcne_vcn" {
  vcn_id = var.olcne_network_vcn.vcn_id
}
