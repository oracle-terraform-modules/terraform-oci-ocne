# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

locals {
  worker_image_id = var.worker_image_id == "Oracle" ? data.oci_core_images.worker_images.images.0.id : var.worker_image_id

  worker_nodes_id_list = [
    for instance in data.oci_core_instance_pool_instances.worker.instances :
    instance.id
  ]

  worker_nodes_hostname_list = [
    for instance in data.oci_core_instance.worker :
    "${instance.hostname_label}.${var.subnet_label}"
  ]

  worker_nodes_vnic_attachments_list = [
    for attachment in data.oci_core_vnic_attachments.workers_vnics_attachments :
    element(attachment.vnic_attachments, 0).vnic_id
  ]

  worker_nodes_private_ip_list = [
    for vnic in data.oci_core_vnic.workers_vnic :
    vnic.private_ip_address
  ]

  nginx_ingress_ports = [30080, 30443]
}
