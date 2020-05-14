# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

variable "compartment_id" {
  type = string
}

variable "label_prefix" {
  type = string
}

variable "nsg_ids" {
  type = map(string)
}

variable "int_lb_shape" {
  type = string
}

variable "pub_lb_shape" {
  type = string
}

variable "int_lb_subnet_id" {
  type = string
}

variable "pub_lb_subnet_id" {
  type = string
}

variable "olcne_workers" {
  type = list(any)
}