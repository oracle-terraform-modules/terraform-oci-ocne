# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "template_file" "install_helm" {
  template = file("${path.module}/scripts/install_helm.template.sh")

  vars = {
    helm_version = var.helm_version
  }
}

resource null_resource "install_helm" {
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

  depends_on = [null_resource.get_kubeconfig]

  provisioner "file" {
    content     = data.template_file.install_helm.rendered
    destination = "~/install_helm.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/install_helm.sh",
      "$HOME/install_helm.sh",
      # "rm -f $HOME/install_helm.sh"
    ]
  }
}
