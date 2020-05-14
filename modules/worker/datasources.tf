# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_core_images" "worker_images" {
  compartment_id           = var.olcne_general.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "7.7"
  shape                    = var.olcne_worker.worker_shape
  sort_by                  = "TIMECREATED"
}

data "template_file" "worker_template" {
  template = file("${path.module}/scripts/worker.template.sh")
}


data "template_file" "worker_cloud_init_file" {
  template = file("${path.module}/cloudinit/worker.template.yaml")

  vars = {
    worker_sh_content = base64gzip(data.template_file.worker_template.rendered)
    worker_upgrade    = var.olcne_worker.worker_upgrade
    timezone          = var.olcne_worker.timezone
  }
}

# cloud init for worker
data "template_cloudinit_config" "worker" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "worker.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.worker_cloud_init_file.rendered
  }
}

# Gets the list of worker instances
data "oci_core_instance_pool_instances" "worker" {
  compartment_id   = var.olcne_general.compartment_id
  instance_pool_id = oci_core_instance_pool.worker.id
}

# filter the worker instances
data "oci_core_instance" "worker" {
  instance_id = element(local.worker_nodes_id_list, count.index)
  count       = var.olcne_worker.size
}

# Gets a list of VNIC attachments on the worker instances
data "oci_core_vnic_attachments" "workers_vnics_attachments" {
  compartment_id = var.olcne_general.compartment_id
  instance_id = element(local.worker_nodes_id_list, count.index)
  count       = var.olcne_worker.size
}

# get a list of vnics for workers
data "oci_core_vnic" "workers_vnic" {
  vnic_id = element(local.worker_nodes_vnic_attachments_list, count.index)
  count   = var.olcne_worker.size
}
