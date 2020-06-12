# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# general oci parameters
variable "compartment_id" {
  type = string
}

variable "label_prefix" {
  type = string
}

# region parameters
variable "ad_names" {
  type = list(string)
}

# networking parameters
variable "ig_route_id" {
  type = string
}

variable "nat_route_id" {
  type = string
}

variable "netnum" {
  type = map(number)
}

variable "newbits" {
  type = map(number)
}

variable "vcn_id" {
  type = string
}
