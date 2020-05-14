# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "subnet_ids" {
  value = map(
    "masters", join(",", oci_core_subnet.masters.*.id),
    "workers", join(",", oci_core_subnet.workers.*.id),
    "int_lb", join(",", oci_core_subnet.int_lb.*.id),
    "pub_lb", join(",", oci_core_subnet.pub_lb.*.id),
    "operator", join(",", oci_core_subnet.operator.*.id)
  )
}

output "nsg_ids" {
  value = map(
    "master", join(",", oci_core_network_security_group.master.*.id),
    "operator", join(",", oci_core_network_security_group.operator.*.id),
    "pub_lb", join(",", oci_core_network_security_group.pub_lb.*.id),
    "worker", join(",", oci_core_network_security_group.worker.*.id),
  )
}

output "master_subnet_dns_label" {
  value = "${oci_core_subnet.masters.dns_label}.${data.oci_core_vcn.olcne_vcn.dns_label}.oraclevcn.com"
}

output "operator_subnet_dns_label" {
  value = "${oci_core_subnet.operator.dns_label}.${data.oci_core_vcn.olcne_vcn.dns_label}.oraclevcn.com"
}

output "worker_subnet_dns_label" {
  value = "${oci_core_subnet.workers.dns_label}.${data.oci_core_vcn.olcne_vcn.dns_label}.oraclevcn.com"
}
