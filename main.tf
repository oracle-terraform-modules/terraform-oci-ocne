# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

terraform {
  required_version = ">= 0.12.24"
}

module "base" {
  source  = "oracle-terraform-modules/base/oci"
  version = "1.2.3"

  # general oci parameters
  oci_base_general = local.oci_base_general

  # identity
  oci_base_provider = local.oci_base_provider

  # vcn parameters
  oci_base_vcn = local.oci_base_vcn

  # bastion parameters
  oci_base_bastion = local.oci_base_bastion

  # operator server parameters
  oci_base_operator = local.oci_base_operator

}

module "network" {
  source = "./modules/network"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  ad_names       = module.base.ad_names

  # network parameters
  ig_route_id  = module.base.ig_route_id
  nat_route_id = module.base.nat_route_id
  netnum       = var.netnum
  newbits      = var.newbits
  vcn_id       = module.base.vcn_id
}

module "master" {
  source = "./modules/master"

  # general oci parameters
  compartment_id = var.compartment_id
  label_prefix   = var.label_prefix
  ad_names       = module.base.ad_names

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
  ad_names       = module.base.ad_names

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
  bastion_public_ip    = module.base.bastion_public_ip
  ssh_private_key_path = var.ssh_private_key_path

  # operator
  operator_ip = module.base.operator_private_ip

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
  deploy_nginx_software = var.deploy_nginx_software
}
