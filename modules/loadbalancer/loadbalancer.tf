# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

resource "oci_load_balancer_load_balancer" "pub_lb" {
  compartment_id = var.compartment_id
  display_name   = "${var.label_prefix}-pub_lb"
  shape          = var.pub_lb_shape
  subnet_ids     = [var.pub_lb_subnet_id]

  is_private                 = false
  network_security_group_ids = [lookup(var.nsg_ids, "pub_lb")]
}

resource "oci_load_balancer_backend_set" "ingress_controller" {
  load_balancer_id = oci_load_balancer_load_balancer.pub_lb.id
  name             = "${var.label_prefix}-ic-${local.nginx_ingress_ports[count.index]}"

  health_checker {
    interval_ms         = 10000
    port                = 30254
    protocol            = "HTTP"
    response_body_regex = ".*"
    url_path            = "/healthz"
  }

  policy = "ROUND_ROBIN"

  count = length(local.nginx_ingress_ports)
}

resource "oci_load_balancer_listener" "http_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.pub_lb.id
  name                     = "http"
  default_backend_set_name = oci_load_balancer_backend_set.ingress_controller[0].name
  port                     = 80
  protocol                 = "HTTP"
}

resource "oci_load_balancer_listener" "https_listener" {
  load_balancer_id         = oci_load_balancer_load_balancer.pub_lb.id
  name                     = "https"
  default_backend_set_name = oci_load_balancer_backend_set.ingress_controller[1].name
  port                     = 443
  protocol                 = "TCP"
}
