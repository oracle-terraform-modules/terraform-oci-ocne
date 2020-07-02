# Copyright 2020, Oracle Corporation and/or affiliates.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

resource "oci_load_balancer_load_balancer" "istio_lb" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-istio_lb"
  shape          = var.pub_lb_shape
  subnet_ids     = [var.pub_lb_subnet_id]

  is_private                 = false
  network_security_group_ids = [lookup(var.nsg_ids, "pub_lb")]
}

resource "oci_load_balancer_backend_set" "istio_ingress_controller" {
  load_balancer_id = oci_load_balancer_load_balancer.istio_lb.id
  name             = "${var.label_prefix}-ic-${local.istio_ingress_ports[count.index]}"

  health_checker {
    protocol = "TCP"
  }

  policy = "ROUND_ROBIN"

  count = length(local.istio_ingress_ports)
}

resource "oci_load_balancer_listener" "istio_http_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.istio_lb.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.istio_ingress_controller[0].name
  port                     = 80
  protocol                 = "TCP"
}

resource "oci_load_balancer_listener" "istio_https_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.istio_lb.id
  name                     = "https"
  default_backend_set_name = oci_load_balancer_backend_set.istio_ingress_controller[1].name
  port                     = 443
  protocol                 = "TCP"
}
