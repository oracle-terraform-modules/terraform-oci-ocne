# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# general
variable "olcne_general" {
  type = object({
    ad_names     = list(string)
    compartment_id = string
    label_prefix = string
  })
}

# worker
variable "olcne_worker" {
  type = object({
    worker_image_id     = string
    worker_shape        = string
    worker_upgrade      = bool
    size                = number
    ssh_public_key_path = string
    timezone            = string
  })
}

variable "olcne_worker_network" {
  type = object({
    nsg_ids      = map(string)
    subnet_id    = string
    subnet_label = string
  })
}

variable "oci_loadbalancer_id" {
  type = string
}
