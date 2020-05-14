# Copyright 2020, Oracle Corporation and/or affiliates. 
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {

  # base module parameters
  oci_base_identity = {
    api_fingerprint      = var.api_fingerprint
    api_private_key_path = var.api_private_key_path
    compartment_id       = var.compartment_id
    tenancy_id           = var.tenancy_id
    user_id              = var.user_id
  }

  oci_base_ssh_keys = {
    ssh_private_key_path = var.ssh_private_key_path
    ssh_public_key_path  = var.ssh_public_key_path
  }

  oci_base_general = {
    label_prefix = var.label_prefix
    region       = var.region
  }

  oci_base_vcn = {
    nat_gateway_enabled     = var.nat_gateway_enabled
    service_gateway_enabled = var.service_gateway_enabled
    vcn_cidr                = var.vcn_cidr
    vcn_dns_label           = var.vcn_dns_label
    vcn_name                = var.vcn_name
  }

  oci_base_bastion = {
    availability_domains  = var.availability_domains["bastion"]
    bastion_access        = var.bastion_access
    bastion_enabled       = var.bastion_enabled
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
    timezone              = var.bastion_timezone
  }

  oci_base_admin = {
    availability_domains      = var.availability_domains["admin"]
    admin_enabled             = var.admin_enabled
    admin_image_id            = var.admin_image_id
    admin_shape               = var.admin_shape
    admin_upgrade             = var.admin_package_upgrade
    enable_instance_principal = var.admin_instance_principal
    netnum                    = var.netnum["admin"]
    newbits                   = var.newbits["admin"]
    notification_enabled      = var.admin_notification_enabled
    notification_endpoint     = var.admin_notification_endpoint
    notification_protocol     = var.admin_notification_protocol
    notification_topic        = var.admin_notification_topic
    ssh_private_key_path      = var.ssh_private_key_path
    ssh_public_key_path       = var.ssh_public_key_path
    timezone                  = var.admin_timezone
  }

  # reusable module parameters
  olcne_general = {
    ad_names       = module.base.ad_names
    compartment_id = var.compartment_id
    label_prefix   = var.label_prefix
  }

  olcne_bastion = {
    bastion_public_ip    = module.base.bastion_public_ip
    ssh_private_key_path = var.ssh_private_key_path
  }


  # network module parameters
  olcne_network_access = {
    allow_master_ssh_access = var.allow_master_ssh_access
    allow_worker_ssh_access = var.allow_worker_ssh_access
  }

  olcne_network_vcn = {
    ig_route_id                = module.base.ig_route_id
    is_service_gateway_enabled = var.service_gateway_enabled
    nat_route_id               = module.base.nat_route_id
    netnum                     = var.netnum
    newbits                    = var.newbits
    vcn_cidr                   = var.vcn_cidr
    vcn_id                     = module.base.vcn_id
  }


  # master module parameters
  olcne_master = {
    master_image_id     = var.master_image_id
    master_shape        = var.master_shape
    master_upgrade      = var.master_package_upgrade
    size                = var.master_size
    ssh_public_key_path = var.ssh_public_key_path
    timezone            = var.master_timezone
  }

  olcne_master_network = {
    nsg_ids      = module.network.nsg_ids
    subnet_id    = lookup(module.network.subnet_ids, "masters")
    subnet_label = module.network.master_subnet_dns_label
    subnet_mask  = cidrnetmask(cidrsubnet(var.vcn_cidr, var.newbits["master"], var.netnum["master"]))
  }

  # operator module parameters

  oci_provider = {
    api_fingerprint      = var.api_fingerprint
    api_private_key_path = var.api_private_key_path
    home_region          = module.base.home_region
    region               = var.region
    tenancy_id           = var.tenancy_id
    user_id              = var.user_id
  }

  olcne_operator = {
    operator_image_id    = var.operator_image_id
    operator_shape       = var.operator_shape
    operator_upgrade     = var.operator_package_upgrade
    ssh_private_key_path = var.ssh_private_key_path
    ssh_public_key_path  = var.ssh_public_key_path
    timezone             = var.operator_timezone
  }

  olcne_operator_network = {
    nsg_ids      = module.network.nsg_ids
    subnet_id    = lookup(module.network.subnet_ids, "operator")
    subnet_label = module.network.operator_subnet_dns_label
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

  # worker module parameters

  olcne_worker = {
    worker_image_id     = var.worker_image_id
    worker_shape        = var.worker_shape
    worker_upgrade      = var.worker_package_upgrade
    size                = var.worker_size
    ssh_public_key_path = var.ssh_public_key_path
    timezone            = var.worker_timezone
  }

  olcne_worker_network = {
    nsg_ids      = module.network.nsg_ids
    subnet_id    = lookup(module.network.subnet_ids, "workers")
    subnet_label = module.network.worker_subnet_dns_label
  }

  # public load balancer module parameters

  olcne_pub_lb_network = {
    nsg_ids   = module.network.nsg_ids
    subnet_id = lookup(module.network.subnet_ids, "pub_lb")
  }

  olcne_lb_shapes = {
    int_lb = var.int_lb_shape
    pub_lb = var.public_lb_shape
  }

  olcne_lb_workers = {
    olcne_worker_ips  = module.worker.worker_ip_list
    worker_nodes_size = var.worker_size
  }
}
