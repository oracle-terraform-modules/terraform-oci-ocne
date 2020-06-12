# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "template_file" "install_nginxcontroller" {
  template = file("${path.module}/scripts/install_nginx.template.sh")

  vars = {
    loadbalancer_ip_address = var.loadbalancer_ip_address
  }
}

data "template_file" "nginx_patch" {
  template = file("${path.module}/resources/nginxpatch.template.yaml")
  vars = {
    loadbalancer_ip_address = var.loadbalancer_ip_address
  }
}

resource null_resource "install_nginxcontroller" {

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

  depends_on = [null_resource.install_helm]

  provisioner "file" {
    content     = data.template_file.install_nginxcontroller.rendered
    destination = "~/install_nginx.sh"
  }

  provisioner "file" {
    content     = data.template_file.nginx_patch.rendered
    destination = "~/nginxpatch.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/install_nginx.sh",
      "$HOME/install_nginx.sh",
      # "rm -f $HOME/install_nginx.sh"
    ]
  }
}
