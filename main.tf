# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

terraform {
  required_version = ">= 0.12.24"
}

module "vcn" {
  source  = "oracle-terraform-modules/vcn/oci"
  version = "1.0.1"

  region = var.region

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # vcn parameters
  internet_gateway_enabled = true
  nat_gateway_enabled      = true
  service_gateway_enabled  = true
  vcn_cidr                 = var.vcn_cidr
  vcn_dns_label            = var.vcn_dns_label
  vcn_name                 = var.vcn_name

  tags = {
    environment = "dev"
    department  = "finance"
  }
}

module "bastion" {
  source  = "oracle-terraform-modules/bastion/oci"
  version = "1.0.1"

  # provider identity parameters
  api_fingerprint      = var.api_fingerprint
  api_private_key_path = var.api_private_key_path
  region               = var.region
  tenancy_id           = var.tenancy_id
  user_id              = var.user_id

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # region parameters
  availability_domain = var.availability_domains["bastion"]

  # bastion parameters
  bastion_access   = var.bastion_access
  bastion_enabled  = true
  bastion_image_id = "Autonomous"
  bastion_shape    = "VM.Standard.E2.2"
  bastion_upgrade  = false
  timezone         = var.bastion_timezone

  # network parameters
  ig_route_id = module.vcn.ig_route_id
  netnum      = var.netnum["bastion"]
  newbits     = var.newbits["bastion"]
  vcn_id      = module.vcn.vcn_id

  # ssh key parameters
  ssh_public_key      = ""
  ssh_public_key_path = var.ssh_public_key_path

  # notification
  notification_enabled  = false
  notification_endpoint = ""
  notification_protocol = "EMAIL"
  notification_topic    = "bastion"

  tags = {
    department  = "finance"
    environment = "dev"
    role        = "bastion"
  }
}

module "operator" {
  source  = "oracle-terraform-modules/operator/oci"
  version = "1.0.6"

  # provider identity parameters
  api_fingerprint      = var.api_fingerprint
  api_private_key_path = var.api_private_key_path
  region               = var.region
  tenancy_id           = var.tenancy_id
  user_id              = var.user_id

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix

  # region parameters
  availability_domain = var.availability_domains["operator"]

  # operator parameters
  operator_enabled            = true
  operator_image_id           = "Oracle"
  operator_instance_principal = true
  operator_shape              = "VM.Standard.E2.2"
  operator_upgrade            = false
  timezone                    = var.operator_timezone

  # network parameters
  nat_route_id = module.vcn.nat_route_id
  netnum       = var.netnum["operator"]
  newbits      = var.newbits["operator"]
  nsg_ids      = list(module.network.nsg_ids["operator"])
  vcn_id       = module.vcn.vcn_id

  # ssh key parameters
  ssh_public_key      = ""
  ssh_public_key_path = var.ssh_public_key_path

  # notification
  notification_enabled  = false
  notification_endpoint = ""
  notification_protocol = "EMAIL"
  notification_topic    = "operator"

  tags = {
    department  = "finance"
    environment = "dev"
    role        = "operator"
  }
}

module "network" {
  source = "./modules/network"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  ad_names       = sort(data.template_file.ad_names.*.rendered)

  # network parameters
  ig_route_id  = module.vcn.ig_route_id
  nat_route_id = module.vcn.nat_route_id
  netnum       = var.netnum
  newbits      = var.newbits
  vcn_id       = module.vcn.vcn_id
}

module "master" {
  source = "./modules/master"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  ad_names       = sort(data.template_file.ad_names.*.rendered)

  # networking parameters
  nsg_id       = module.network.nsg_ids["master"]
  subnet_id    = module.network.subnet_ids["masters"]
  subnet_label = module.network.master_subnet_dns_label

  # master compute parameters
  master_image_id     = var.master_image_id
  master_shape        = var.master_shape
  master_size         = var.master_size
  master_upgrade      = var.master_package_upgrade
  ssh_public_key      = ""
  ssh_public_key_path = var.ssh_public_key_path
  timezone            = var.master_timezone

}

module "worker" {
  source = "./modules/worker"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  ad_names       = sort(data.template_file.ad_names.*.rendered)

  # networking parameters
  nsg_id       = module.network.nsg_ids["worker"]
  subnet_id    = module.network.subnet_ids["workers"]
  subnet_label = module.network.worker_subnet_dns_label

  # worker compute parameters
  worker_image_id     = var.worker_image_id
  worker_shape        = var.worker_shape
  worker_size         = var.worker_size
  worker_upgrade      = var.worker_package_upgrade
  ssh_public_key      = ""
  ssh_public_key_path = var.ssh_public_key_path
  timezone            = var.worker_timezone

  # olcne public load balancer to attach to worker pool
  oci_loadbalancer_id = module.loadbalancer.pub_lb_id
}

module "loadbalancer" {
  source = "./modules/loadbalancer"

  # general parameters
  compartment_id = var.compartment_id

  label_prefix = var.label_prefix

  nsg_ids = module.network.nsg_ids

  # load balancer shapes
  int_lb_shape = var.int_lb_shape
  pub_lb_shape = var.public_lb_shape

  # subnet ids
  int_lb_subnet_id = lookup(module.network.subnet_ids, "int_lb")
  pub_lb_subnet_id = lookup(module.network.subnet_ids, "pub_lb")

  # workers ip addresses for backend resources
  olcne_workers = module.worker.worker_ip_list
}

# configuration
module "olcne" {
  source = "./modules/olcne"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  region         = var.region

  # bastion
  bastion_public_ip    = module.bastion.bastion_public_ip
  ssh_private_key_path = var.ssh_private_key_path

  # operator
  operator_ip = module.operator.operator_private_ip

  # list of master nodes
  olcne_masters = local.olcne_masters

  # private CA Certificate
  olcne_certificate = local.olcne_certificate

  # list of worker nodes
  olcne_workers = local.olcne_workers

  # private key parameter to access other nodes
  secret_id = var.secret_id

  # olcne environment
  olcne_environment = local.olcne_environment

  helm_version = var.helm_version

  loadbalancer_ip_address = module.loadbalancer.pub_lb_ip

}
