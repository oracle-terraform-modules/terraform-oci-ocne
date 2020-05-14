# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_instance_configuration" "operator" {
  compartment_id = var.olcne_general.compartment_id

  display_name = "${var.olcne_general.label_prefix}-operator"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = var.olcne_general.compartment_id

      create_vnic_details {
        assign_public_ip = false
        display_name     = "${var.olcne_general.label_prefix}-operator"
        hostname_label   = "operator"
        nsg_ids          = [lookup(var.olcne_operator_network.nsg_ids, "operator")]
        subnet_id        = var.olcne_operator_network.subnet_id
      }

      display_name = "${var.olcne_general.label_prefix}-operator"

      extended_metadata = {
        subnet_id = var.olcne_operator_network.subnet_id
      }

      metadata = {
        ssh_authorized_keys = file(var.olcne_operator.ssh_public_key_path)
        user_data           = data.template_cloudinit_config.operator.rendered
      }

      shape = var.olcne_operator.operator_shape
      source_details {
        source_type = "image"
        image_id    = local.operator_image_id
      }
    }
  }
  lifecycle {
    ignore_changes = [instance_details[0].launch_details[0].source_details[0].image_id]
  }
}

resource "oci_core_instance_pool" "operator" {
  compartment_id            = var.olcne_general.compartment_id
  depends_on                = [oci_core_instance_configuration.operator]
  display_name              = "${var.olcne_general.label_prefix}-operator"
  instance_configuration_id = oci_core_instance_configuration.operator.id

  dynamic "placement_configurations" {
    iterator = ad_iterator
    for_each = var.olcne_general.ad_names

    content {
      availability_domain = ad_iterator.value
      primary_subnet_id   = var.olcne_operator_network.subnet_id
    }
  }

  size = 1
}
