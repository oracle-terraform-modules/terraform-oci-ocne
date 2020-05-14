# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# general oci parameters

variable "olcne_general" {
  type = object({
    ad_names       = list(string)
    compartment_id = string
    label_prefix   = string
  })
}

# networking parameters

variable "olcne_network_vcn" {
  type = object({
    ig_route_id                = string
    is_service_gateway_enabled = bool
    nat_route_id               = string
    netnum                     = map(number)
    newbits                    = map(number)
    vcn_cidr                   = string
    vcn_id                     = string
  })
}

# olcne node

variable "olcne_network_access" {
  type = object({
    allow_master_ssh_access = bool
    allow_worker_ssh_access = bool
  })
}
