# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

terraform {
  required_version = ">= 0.12.16"
}

module "base" {
  source  = "oracle-terraform-modules/base/oci"
  version = "1.1.4"

  # identity
  oci_base_identity = local.oci_base_identity

  # general oci parameters
  oci_base_general = local.oci_base_general

  # vcn parameters
  oci_base_vcn = local.oci_base_vcn

  # bastion parameters
  oci_base_bastion = local.oci_base_bastion

  # admin server parameters
  oci_base_admin = local.oci_base_admin

  tagging = {
    computetag = {
      Environment = "dev"
    }
    networktag = {
      Name = "network"
    }
  }
}

module "network" {
  source = "./modules/network"

  # general parameters
  olcne_general = local.olcne_general

  # olcne networking parameters
  olcne_network_vcn = local.olcne_network_vcn

  # olcne network access parameters
  olcne_network_access = local.olcne_network_access
}

module "master" {
  source = "./modules/master"

  # general parameters
  olcne_general = local.olcne_general

  # olcne master nodes parameters
  olcne_master = local.olcne_master

  # olcne master network parameters
  olcne_master_network = local.olcne_master_network
}

module "operator" {
  source = "./modules/operator"

  # home provider parameters
  oci_provider = local.oci_provider

  # general parameters
  olcne_general = local.olcne_general

  # bastion
  olcne_bastion = local.olcne_bastion

  # olcne operator node parameters
  olcne_operator = local.olcne_operator

  # olcne operator network parameters
  olcne_operator_network = local.olcne_operator_network

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

module "worker" {
  source = "./modules/worker"

  # general parameters
  olcne_general = local.olcne_general

  # olcne worker nodes parameters
  olcne_worker = local.olcne_worker

  # olcne worker network parameters
  olcne_worker_network = local.olcne_worker_network

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
