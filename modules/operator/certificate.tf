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

resource null_resource "wait_for_operator" {
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

  depends_on = [oci_identity_policy.use_secret]

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /home/opc/operator.finish ]; do echo 'Waiting for operator node to be ready';sleep 10; done",
    ]
  }
}

resource null_resource "wait_for_master" {
  connection {
    host        = var.olcne_masters.olcne_master_nodes[count.index]
    private_key = file(var.olcne_operator.ssh_private_key_path)
    timeout     = "40m"
    type        = "ssh"
    user        = "opc"

    bastion_host        = var.olcne_bastion.bastion_public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.olcne_bastion.ssh_private_key_path)
  }

  depends_on = [oci_identity_policy.use_secret]

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /home/opc/master.finish ]; do echo 'Waiting for master node to be ready';sleep 10; done",
    ]
  }
  count = var.olcne_masters.master_nodes_size
}

resource null_resource "wait_for_worker" {
  connection {
    host        = var.olcne_workers.olcne_worker_nodes[count.index]
    private_key = file(var.olcne_operator.ssh_private_key_path)
    timeout     = "40m"
    type        = "ssh"
    user        = "opc"

    bastion_host        = var.olcne_bastion.bastion_public_ip
    bastion_user        = "opc"
    bastion_private_key = file(var.olcne_bastion.ssh_private_key_path)
  }

  depends_on = [oci_identity_policy.use_secret]

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /home/opc/worker.finish ]; do echo 'Waiting for worker node to be ready';sleep 10; done",
    ]
  }
  count = var.olcne_workers.worker_nodes_size
}

data "template_file" "download_private_key" {
  template = file("${path.module}/scripts/download_private_key.template.sh")

  vars = {
    secret_id = var.secret_id
  }
}

resource null_resource "download_private_key" {
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

  depends_on = [null_resource.wait_for_operator]

  provisioner "file" {
    content     = data.template_file.download_private_key.rendered
    destination = "~/get_key.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "chmod +x $HOME/get_key.sh",
      "$HOME/get_key.sh",
      "chmod go-rw ~/.ssh/id_rsa",
    ]
  }
}

resource null_resource "create_certificate" {
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
