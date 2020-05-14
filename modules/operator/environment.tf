# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "template_file" "configure_api" {
  template = file("${path.module}/scripts/configure_api.template.sh")
}

resource null_resource "configure_api" {
  connection {
    host        = local.operator_private_ip
    private_key = file(var.olcne_operator.ssh_private_key_path)
    timeout     = "40m"
    type        = "ssh"
    user        = "opc"

    bastion_host        = var.olcne_bastion.bastion_public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.olcne_bastion.ssh_private_key_path)
  }

  depends_on = [null_resource.create_certificate]

  provisioner "file" {
    content     = data.template_file.configure_api.rendered
    destination = "~/configure_api"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/configure_api",
      "$HOME/configure_api",
      # "rm -f $HOME/configure_api"
    ]
  }
}

data "template_file" "configure_agent" {
  template = file("${path.module}/scripts/configure_agent.template.sh")
}

resource null_resource "configure_agent" {
  connection {
    host        = element(local.all_nodes, count.index)
    private_key = file(var.olcne_operator.ssh_private_key_path)
    timeout     = "40m"
    type        = "ssh"
    user        = "opc"

    bastion_host        = var.olcne_bastion.bastion_public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.olcne_bastion.ssh_private_key_path)
  }

  depends_on = [null_resource.configure_api]

  provisioner "file" {
    content     = data.template_file.configure_agent.rendered
    destination = "~/configure_agent"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/configure_agent",
      "$HOME/configure_agent",
      # "rm -f $HOME/configure_agent"
    ]
  }
  count = (var.olcne_masters.master_nodes_size + var.olcne_workers.worker_nodes_size)
}

data "template_file" "create_environment" {
  template = file("${path.module}/scripts/create_environment.template.sh")

  vars = {
    environment = var.olcne_environment.environment_name
  }
}

resource null_resource "create_environment" {
  connection {
    host        = local.operator_private_ip
    private_key = file(var.olcne_operator.ssh_private_key_path)
    timeout     = "40m"
    type        = "ssh"
    user        = "opc"

    bastion_host        = var.olcne_bastion.bastion_public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.olcne_bastion.ssh_private_key_path)
  }

  depends_on = [null_resource.configure_agent]

  provisioner "file" {
    content     = data.template_file.create_environment.rendered
    destination = "~/create_environment"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x $HOME/create_environment",
      "$HOME/create_environment",
      # "rm -f $HOME/create_environment"
    ]
  }
}
