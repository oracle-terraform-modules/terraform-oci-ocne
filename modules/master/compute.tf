# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_instance_configuration" "master" {
  compartment_id = var.compartment_id

  display_name = "${var.label_prefix}-master"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = var.compartment_id

      create_vnic_details {
        assign_public_ip = false
        display_name     = "${var.label_prefix}-master"
        hostname_label   = "master"
        nsg_ids          = [var.nsg_id]
        subnet_id        = var.subnet_id
      }

      display_name = "${var.label_prefix}-master"

      extended_metadata = {
        subnet_id = var.subnet_id
      }

      metadata = {
        ssh_authorized_keys = file(var.ssh_public_key_path)
        user_data           = data.template_cloudinit_config.master.rendered
      }

      shape = var.master_shape
      source_details {
        source_type = "image"
        image_id    = local.master_image_id
      }
    }
  }
  lifecycle {
    ignore_changes = [instance_details[0].launch_details[0].source_details[0].image_id]
  }
}

resource "oci_core_instance_pool" "master" {
  compartment_id            = var.compartment_id
  depends_on                = [oci_core_instance_configuration.master]
  display_name              = "${var.label_prefix}-master"
  instance_configuration_id = oci_core_instance_configuration.master.id

  dynamic "placement_configurations" {
    iterator = ad_iterator
    for_each = var.ad_names

    content {
      availability_domain = ad_iterator.value
      primary_subnet_id   = var.subnet_id
    }
  }

  lifecycle {
    ignore_changes = [display_name]
  }

  size = var.master_size
}
