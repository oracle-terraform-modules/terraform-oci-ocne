# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

output "ssh_to_bastion" {
  description = "ssh to bastion"
  value       = "ssh -i ${var.ssh_private_key_path} opc@${module.base.bastion_public_ip}"
}

output "ssh_to_operator" {
  description = "ssh to operator"
  value       = "ssh -i ${var.ssh_private_key_path} -J opc@${module.base.bastion_public_ip} opc@${module.base.operator_private_ip}"
}

output "ssh_to_master" {
  description = "ssh to primary master node"
  value       = "ssh -i ${var.ssh_private_key_path} -J opc@${module.base.bastion_public_ip} opc@${module.master.master_vip}"
}
