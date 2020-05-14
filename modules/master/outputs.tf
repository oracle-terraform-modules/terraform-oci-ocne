# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "olcne_master_nodes" {
  value = sort(local.master_nodes_hostname_list)
}

output "master_vip" {
  value = data.oci_core_vnic.master_vnic.private_ip_address
}
