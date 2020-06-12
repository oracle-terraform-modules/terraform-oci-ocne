# Copyright 2020, Oracle Corporation and/or affiliates. 
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {

  oci_base_general = {
    compartment_id = var.compartment_id
    label_prefix   = var.label_prefix
  }

  oci_base_provider = {
    api_fingerprint      = var.api_fingerprint
    api_private_key_path = var.api_private_key_path
    region               = var.region
    tenancy_id           = var.tenancy_id
    user_id              = var.user_id
  }

  oci_base_vcn = {
    internet_gateway_enabled = true
    nat_gateway_enabled      = true
    service_gateway_enabled  = true
    tags                     = var.tags["vcn"]
    vcn_cidr                 = var.vcn_cidr
    vcn_dns_label            = var.vcn_dns_label
    vcn_name                 = var.vcn_name
  }

  oci_base_ssh_keys = {
    ssh_private_key_path = var.ssh_private_key_path
    ssh_public_key_path  = var.ssh_public_key_path
  }

  oci_base_bastion = {
    availability_domain   = var.availability_domains["bastion"]
    bastion_access        = var.bastion_access
    bastion_enabled       = true
    bastion_image_id      = var.bastion_image_id
    bastion_shape         = var.bastion_shape
    bastion_upgrade       = var.bastion_package_upgrade
    netnum                = var.netnum["bastion"]
    newbits               = var.newbits["bastion"]
    notification_enabled  = var.bastion_notification_enabled
    notification_endpoint = var.bastion_notification_endpoint
    notification_protocol = var.bastion_notification_protocol
    notification_topic    = var.bastion_notification_topic
    ssh_private_key_path  = var.ssh_private_key_path
    ssh_public_key_path   = var.ssh_public_key_path
    tags                  = var.tags["bastion"]
    timezone              = var.bastion_timezone
  }

  oci_base_operator = {
    availability_domain       = var.availability_domains["operator"]
    operator_enabled          = true
    operator_image_id         = var.operator_image_id
    operator_shape            = var.operator_shape
    operator_upgrade          = var.operator_package_upgrade
    enable_instance_principal = true
    netnum                    = var.netnum["operator"]
    newbits                   = var.newbits["operator"]
    notification_enabled      = var.operator_notification_enabled
    notification_endpoint     = var.operator_notification_endpoint
    notification_protocol     = var.operator_notification_protocol
    notification_topic        = var.operator_notification_topic
    ssh_private_key_path      = var.ssh_private_key_path
    ssh_public_key_path       = var.ssh_public_key_path
    tags                      = var.tags["bastion"]
    timezone                  = var.operator_timezone
  }

  olcne_masters = {
    master_nodes_size  = var.master_size
    olcne_master_nodes = module.master.olcne_master_nodes
    primary_master_vip = module.master.master_vip
  }

  olcne_certificate = {
    org_unit    = var.org_unit
    org         = var.org
    city        = var.city
    state       = var.state
    country     = var.country
    common_name = var.common_name
  }

  olcne_workers = {
    olcne_worker_nodes = module.worker.olcne_worker_nodes
    worker_nodes_size  = var.worker_size
  }

  olcne_environment = {
    environment_name        = var.environment_name
    cluster_name            = var.cluster_name
    create_kata_runtime     = var.create_kata_runtime
    kata_runtime_class_name = var.kata_runtime_class_name
  }
}
