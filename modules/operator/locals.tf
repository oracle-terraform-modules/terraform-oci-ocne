# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  operator_image_id = var.olcne_operator.operator_image_id == "Oracle" ? data.oci_core_images.operator_images.images.0.id : var.olcne_operator.operator_image_id

  operator_node = "${data.oci_core_instance.operator.hostname_label}.${var.olcne_operator_network.subnet_label}"

  operator_private_ip = join(",", data.oci_core_vnic.operator_vnic.*.private_ip_address)
  
  # to configure agent
  all_nodes = concat(var.olcne_masters.olcne_master_nodes, var.olcne_workers.olcne_worker_nodes)

  # to create module
  master_nodes_addresses = formatlist("%s:8090", var.olcne_masters.olcne_master_nodes)

  worker_nodes_addresses = formatlist("%s:8090", var.olcne_workers.olcne_worker_nodes)

  # to download ssh key
  policy_statement_secret = "Allow dynamic-group ${oci_identity_dynamic_group.operator_instance_principal.name} to read secret-bundles in compartment id ${var.olcne_general.compartment_id}"
}
