# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_instance_configuration" "worker" {
  compartment_id = var.compartment_id

  display_name = "${var.label_prefix}-worker"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = var.compartment_id

      create_vnic_details {
        assign_public_ip = false
        display_name     = "${var.label_prefix}-worker"
        hostname_label   = "worker"
        nsg_ids          = [var.nsg_id]
        subnet_id        = var.subnet_id
      }

      display_name = "${var.label_prefix}-worker"

      extended_metadata = {
        subnet_id = var.subnet_id
      }

      metadata = {
        ssh_authorized_keys = file(var.ssh_public_key_path)
        user_data           = data.template_cloudinit_config.worker.rendered
      }

      shape = var.worker_shape
      source_details {
        source_type = "image"
        image_id    = local.worker_image_id
      }
    }
  }
  lifecycle {
    ignore_changes = [instance_details[0].launch_details[0].source_details[0].image_id]
  }
}

resource "oci_core_instance_pool" "worker" {
  compartment_id            = var.compartment_id
  depends_on                = [oci_core_instance_configuration.worker]
  display_name              = "${var.label_prefix}-worker"
  instance_configuration_id = oci_core_instance_configuration.worker.id

  dynamic "placement_configurations" {
    iterator = ad_iterator
    for_each = var.ad_names

    content {
      availability_domain = ad_iterator.value
      primary_subnet_id   = var.subnet_id
    }
  }

  dynamic "load_balancers" {
    for_each = local.ingress

    content {
      backend_set_name = "${var.label_prefix}-ic-${load_balancers.value["port"]}"
      load_balancer_id = load_balancers.value["loadbalancer"]
      port             = load_balancers.value["port"]
      vnic_selection   = "PrimaryVnic"
    }
  }

  lifecycle {
    ignore_changes = [display_name]
  }

  size = var.worker_size
}
