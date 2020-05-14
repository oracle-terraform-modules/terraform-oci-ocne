# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# general

variable "olcne_general" {
  type = object({
    ad_names       = list(string)
    compartment_id = string
    label_prefix   = string
  })
}

# master

variable "olcne_master" {
  type = object({
    master_image_id     = string
    master_shape        = string
    master_upgrade      = bool
    size                = number
    ssh_public_key_path = string
    timezone            = string
  })
}

variable "olcne_master_network" {
  type = object({
    nsg_ids      = map(string)
    subnet_id    = string
    subnet_label = string
    subnet_mask  = string
  })
}
