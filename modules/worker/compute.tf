# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

resource "oci_core_instance_configuration" "worker" {
  compartment_id = var.olcne_general.compartment_id

  display_name = "${var.olcne_general.label_prefix}-worker"

  instance_details {
    instance_type = "compute"

    launch_details {
      compartment_id = var.olcne_general.compartment_id

      create_vnic_details {
        assign_public_ip = false
        display_name     = "${var.olcne_general.label_prefix}-worker"
        hostname_label   = "worker"
        nsg_ids          = [lookup(var.olcne_worker_network.nsg_ids, "worker")]
        subnet_id        = var.olcne_worker_network.subnet_id
      }

      display_name = "${var.olcne_general.label_prefix}-worker"

      extended_metadata = {
        subnet_id = var.olcne_worker_network.subnet_id
      }

      metadata = {
        ssh_authorized_keys = file(var.olcne_worker.ssh_public_key_path)
        user_data           = data.template_cloudinit_config.worker.rendered
      }

      shape = var.olcne_worker.worker_shape
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
  compartment_id            = var.olcne_general.compartment_id
  depends_on                = [oci_core_instance_configuration.worker]
  display_name              = "${var.olcne_general.label_prefix}-worker"
  instance_configuration_id = oci_core_instance_configuration.worker.id

  dynamic "placement_configurations" {
    iterator = ad_iterator
    for_each = var.olcne_general.ad_names

    content {
      availability_domain = ad_iterator.value
      primary_subnet_id   = var.olcne_worker_network.subnet_id
    }
  }

  dynamic "load_balancers" {

    iterator = port_iterator
    for_each = local.ingress_ports

    content {
      backend_set_name = "${var.olcne_general.label_prefix}-ic-${port_iterator.value}"
      load_balancer_id = var.oci_loadbalancer_id
      port             = port_iterator.value
      vnic_selection   = "PrimaryVnic"
    }
  }

  size = var.olcne_worker.size
}
