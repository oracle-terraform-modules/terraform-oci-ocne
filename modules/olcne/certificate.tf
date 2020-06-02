# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

data "template_file" "create_certificate" {
  template = file("${path.module}/scripts/create_certificate.template.sh")

  vars = {
    org_unit          = var.olcne_certificate.org_unit
    org               = var.olcne_certificate.org
    city              = var.olcne_certificate.city
    state             = var.olcne_certificate.state
    country           = var.olcne_certificate.country
    common_name       = var.olcne_certificate.common_name
    operator_node     = local.operator_node
    master_nodes      = join(",", sort(var.olcne_masters.olcne_master_nodes))
    worker_nodes      = join(",", sort(var.olcne_workers.olcne_worker_nodes))
    scan_master_nodes = join(" ", sort(var.olcne_masters.olcne_master_nodes))
    scan_worker_nodes = join(" ", sort(var.olcne_workers.olcne_worker_nodes))
  }
}

resource null_resource "create_certificate" {
  connection {
    host        = local.operator_private_ip
    private_key = file(var.ssh_private_key_path)
    timeout     = "40m"
    type        = "ssh"
    user        = "opc"

    bastion_host        = var.bastion_public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.ssh_private_key_path)
  }

  depends_on = [null_resource.download_private_key, null_resource.wait_for_worker, null_resource.wait_for_master]

  provisioner "file" {
    content     = data.template_file.create_certificate.rendered
    destination = "~/create_certificate.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/create_certificate.sh",
      "$HOME/create_certificate.sh",
      # "rm -f $HOME/create_certificate.sh"
    ]
  }
}
