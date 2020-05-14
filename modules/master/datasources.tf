# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_core_images" "master_images" {
  compartment_id           = var.olcne_general.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "7.7"
  shape                    = var.olcne_master.master_shape
  sort_by                  = "TIMECREATED"
}

data "template_file" "master_template" {
  template = file("${path.module}/scripts/master.template.sh")
}

data "template_file" "master_cloud_init_file" {
  template = file("${path.module}/cloudinit/master.template.yaml")

  vars = {
    master_sh_content = base64gzip(data.template_file.master_template.rendered)
    master_upgrade    = var.olcne_master.master_upgrade
    timezone          = var.olcne_master.timezone
  }
}

# cloud init for master
data "template_cloudinit_config" "master" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "master.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.master_cloud_init_file.rendered
  }
}

# Gets the list of master instances
data "oci_core_instance_pool_instances" "master" {
  compartment_id   = var.olcne_general.compartment_id
  depends_on       = [oci_core_instance_pool.master]
  instance_pool_id = oci_core_instance_pool.master.id
}

# compile the master instances
data "oci_core_instance" "master" {
  depends_on  = [oci_core_instance_pool.master]
  instance_id = element(local.master_nodes_id_list, count.index)
  count       = var.olcne_master.size
}

# Gets a list of VNIC attachments on the primary master instance
data "oci_core_vnic_attachments" "master_vnics_attachments" {
  compartment_id = var.olcne_general.compartment_id
  depends_on     = [oci_core_instance_pool.master]
  instance_id    = element(local.master_nodes_id_list, 0)
}

# pick a vnic for primary master
data "oci_core_vnic" "master_vnic" {
  depends_on = [oci_core_instance_pool.master, data.oci_core_vnic_attachments.master_vnics_attachments]
  vnic_id    = element(local.vnic_ids_list, 0)
}
