# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_core_subnets" "olcne_subnets" {
  compartment_id = var.compartment_id
  vcn_id         = var.vcn_id

  filter {
    name   = "state"
    values = ["AVAILABLE"]
  }
}

data "oci_core_vcn" "vcn" {
  vcn_id = var.vcn_id
}
