data "template_file" "kata" {
  template = file("${path.module}/resources/kata.yaml")
  vars = {
    kata_runtime_class_name = var.olcne_environment.kata_runtime_class_name
  }
  count = var.olcne_environment.create_kata_runtime == true ? 1 : 0
}

resource null_resource "create_kata_runtime" {
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
    content     = data.template_file.kata[0].rendered
    destination = "~/kata.yaml"
  }

  provisioner "remote-exec" {
    inline = [
      "kubectl apply -f $HOME/kata.yaml",
    ]
  }

  count = var.olcne_environment.create_kata_runtime == true ? 1 : 0
}
