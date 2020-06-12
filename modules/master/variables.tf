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
variable "nsg_id" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "subnet_label" {
  type = string
}

# master compute parameters
variable "master_image_id" {
  type = string
}

variable "master_shape" {
  type = string
}

variable "master_size" {
  type = number
}

variable "master_upgrade" {
  type = string
}

variable "ssh_public_key" {
  type = string
}

variable "ssh_public_key_path" {
  type = string
}

variable "timezone" {
  type = string
}