# Copyright 2020, Oracle Corporation and/or affiliates. 
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {

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
