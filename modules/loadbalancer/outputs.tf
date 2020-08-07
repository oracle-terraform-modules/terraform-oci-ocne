# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "nginx_lb_id" {
  value = oci_load_balancer_load_balancer.pub_lb.id
}

output "nginx_lb_ip" {
  value = oci_load_balancer_load_balancer.pub_lb.ip_address_details[0].ip_address
}

output "istio_lb_id" {
  value = oci_load_balancer_load_balancer.istio_lb.id
}

output "istio_lb_ip" {
  value = oci_load_balancer_load_balancer.istio_lb.ip_address_details[0].ip_address
}