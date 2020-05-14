# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# provider

variable "oci_provider" {
  type = object({
    api_fingerprint      = string
    api_private_key_path = string
    home_region          = string
    region               = string
    tenancy_id           = string
    user_id              = string
  })
}

# general
variable "olcne_general" {
  type = object({
    ad_names       = list(string)
    compartment_id = string
    label_prefix   = string
  })
}

# bastion
variable "olcne_bastion" {
  type = object({
    bastion_public_ip    = string
    ssh_private_key_path = string
  })
}

# operator

variable "olcne_operator" {
  type = object({
    operator_image_id    = string
    operator_shape       = string
    operator_upgrade     = bool
    ssh_private_key_path = string
    ssh_public_key_path  = string
    timezone             = string
  })
}

variable "olcne_operator_network" {
  type = object({
    nsg_ids      = map(string)
    subnet_id    = string
    subnet_label = string
  })
}

variable "olcne_masters" {
  type = object({
    master_nodes_size  = number
    olcne_master_nodes = list(any)
    primary_master_vip = string
  })
}

variable "olcne_certificate" {
  type = object({
    org_unit    = string
    org         = string
    city        = string
    state       = string
    country     = string
    common_name = string
  })
}

variable "olcne_workers" {
  type = object({
    olcne_worker_nodes = list(any)
    worker_nodes_size  = number
  })
}

variable "secret_id" {
  type = string
}

variable "olcne_environment" {
  type = object({
    environment_name        = string
    cluster_name            = string
    create_kata_runtime     = bool
    kata_runtime_class_name = string
  })
}

variable "helm_version" {
  type = string
}

variable "loadbalancer_ip_address" {
  type = string
}

variable "container_registry_urls" {
  description = "urls of container-registries"
  default = {
    ap-sydney-1    = "container-registry-syd.oracle.com"
    ap-melbourne-1 = "container-registry-mel.oracle.com"
    ap-mumbai-1    = "container-registry-bom.oracle.com"
    ap-osaka-1     = "container-registry-kix.oracle.com"
    ap-seoul-1     = "container-registry-icn.oracle.com"
    ap-tokyo-1     = "container-registry-nrt.oracle.com"
    ca-montreal-1  = "container-registry-yul.oracle.com"
    ca-toronto-1   = "container-registry-yyz.oracle.com"
    eu-amsterdam-1 = "container-registry-ams.oracle.com"
    eu-frankfurt-1 = "container-registry-fra.oracle.com"
    eu-zurich-1    = "container-registry-zrh.oracle.com"
    me-jeddah-1    = "container-registry-jed.oracle.com"
    sa-saopaulo-1  = "container-registry-gru.oracle.com"
    uk-london-1    = "container-registry-lhr.oracle.com"
    us-ashburn-1   = "container-registry-iad.oracle.com"
    us-phoenix-1   = "container-registry-phx.oracle.com"
  }
  type = map(string)
}
