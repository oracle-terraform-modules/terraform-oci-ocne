# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "olcne_worker_nodes" {
  value = local.worker_nodes_hostname_list
}

output "worker_ip_list" {
  value = local.worker_nodes_private_ip_list
}
