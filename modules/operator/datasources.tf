# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "oci_core_images" "operator_images" {
  compartment_id           = var.olcne_general.compartment_id
  operating_system         = "Oracle Linux"
  operating_system_version = "7.7"
  shape                    = var.olcne_operator.operator_shape
  sort_by                  = "TIMECREATED"
}

data "template_file" "operator_template" {
  template = file("${path.module}/scripts/operator.template.sh")
}

data "template_file" "operator_cloud_init_file" {
  template = file("${path.module}/cloudinit/operator.template.yaml")

  vars = {
    operator_sh_content = base64gzip(data.template_file.operator_template.rendered)
    operator_upgrade    = var.olcne_operator.operator_upgrade
    timezone            = var.olcne_operator.timezone
  }
}

# cloud init for operator
data "template_cloudinit_config" "operator" {
  gzip          = true
  base64_encode = true

  part {
    filename     = "operator.yaml"
    content_type = "text/cloud-config"
    content      = data.template_file.operator_cloud_init_file.rendered
  }
}

# Gets the list of operator instances
data "oci_core_instance_pool_instances" "operator" {
  compartment_id   = var.olcne_general.compartment_id
  instance_pool_id = oci_core_instance_pool.operator.id
}

# filter the operator instance
data "oci_core_instance" "operator" {
  instance_id = element(data.oci_core_instance_pool_instances.operator.instances, 0).id
  depends_on  = [oci_core_instance_pool.operator]
}

# Gets a list of VNIC attachments on the operator instance
data "oci_core_vnic_attachments" "operator_vnics_attachments" {
  compartment_id = var.olcne_general.compartment_id
  instance_id    = data.oci_core_instance.operator.id
  depends_on     = [oci_core_instance_pool.operator]
}

# Gets the olcne of the first (default) VNIC on the operator instance
data "oci_core_vnic" "operator_vnic" {
  vnic_id    = lookup(data.oci_core_vnic_attachments.operator_vnics_attachments.vnic_attachments[0], "vnic_id")
  depends_on = [oci_core_instance_pool.operator]
}

# get the tenancy details
data "oci_identity_tenancy" "tenancy" {
  tenancy_id = var.oci_provider.tenancy_id
}
