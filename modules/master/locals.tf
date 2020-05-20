# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  master_image_id = var.olcne_master.master_image_id == "Oracle" ? data.oci_core_images.master_images.images.0.id : var.olcne_master.master_image_id

  unsorted_master_nodes_id_list = [
    for instance in data.oci_core_instance_pool_instances.master.instances :
    instance.id
  ]

  master_nodes_id_list = sort(local.unsorted_master_nodes_id_list)

  master_nodes_hostname_list = [
    for instance in data.oci_core_instance.master :
    "${instance.hostname_label}.${var.olcne_master_network.subnet_label}"
  ]

  vnic_ids_list = [
    for vnic_attachment in data.oci_core_vnic_attachments.master_vnics_attachments.vnic_attachments :
    vnic_attachment.vnic_id
  ]
   
  formatted_list_of_master_ids = formatlist("instance.id='%s'", data.oci_core_instance.master.*.id)
}
