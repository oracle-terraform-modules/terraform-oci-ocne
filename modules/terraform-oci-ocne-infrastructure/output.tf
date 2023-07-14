# Copyright (c) 2023 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "apiserver_ip" {
  description = "IP address of API Server."
  value       = local.apiserver_ip
}

output "control_plane_nodes" {
  description = "List of control plane nodes."
  value       = local.control_plane_nodes
}

output "worker_nodes" {
  description = "List of worker node IP addresses."
  value       = module.worker-compute.private_ip
}

output "load_balancer_ocid" {
  description = "OCID of the load balancer."
  value       = module.kube-apiserver-loadbalancer.load_balancer_ocid
}

output "load_balancer_ip" {
  description = "IP address of the load balancer."
  value       = module.kube-apiserver-loadbalancer.ip_address
}

output "kubernetes_endpoint" {
  description = "Load balancer URI."
  value       = module.kube-apiserver-loadbalancer.endpoint
}

output "node_ocids" {
  description = "List of worker node IP addresses."
  value       = local.node_ocids
}

output "kube_apiserver_virtual_ip" {
  description = "The 2nd IP of first control plane node to be the Kubernetes API server endpoint"
  value       = var.virtual_ip ? module.control-plane-compute.secondary_private_ip[0] : ""
}