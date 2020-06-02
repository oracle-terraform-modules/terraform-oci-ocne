data "template_file" "get_kubeconfig" {
  template = file("${path.module}/scripts/get_kubeconfig.template.sh")

  vars = {
    cluster_name = var.olcne_environment.cluster_name
    environment  = var.olcne_environment.environment_name
  }
}

resource null_resource "get_kubeconfig" {
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

  depends_on = [null_resource.install_kubernetes_module]

  provisioner "file" {
    content     = data.template_file.get_kubeconfig.rendered
    destination = "~/get_kubeconfig.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/get_kubeconfig.sh",
      "$HOME/get_kubeconfig.sh",
      # "rm -f $HOME/get_kubeconfig.sh"
    ]
  }
}
