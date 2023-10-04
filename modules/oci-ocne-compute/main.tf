# Copyright (c) 2023 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

resource "oci_core_instance" "instance" {
  count               = var.instance_count
  availability_domain = var.availability_domain_id
  compartment_id      = var.compartment_id
  display_name        = format("${var.prefix}-%03d", count.index + 1)
  freeform_tags       = var.freeform_tags

  shape = lookup(var.instance_shape, "shape", "VM.Standard2.2")

  dynamic "shape_config" {
    for_each = length(regexall("Flex", lookup(var.instance_shape, "shape", "VM.Standard.E3.Flex"))) > 0 ? [1] : []
    content {
      ocpus         = max(1, lookup(var.instance_shape, "ocpus", 1))
      memory_in_gbs = (lookup(var.instance_shape, "memory", 4) / lookup(var.instance_shape, "ocpus", 1)) > 64 ? (lookup(var.instance_shape, "ocpus", 1) * 16) : lookup(var.instance_shape, "memory", 4)
    }
  }

  source_details {
    source_type             = "image"
    source_id               = var.image_ocid
    boot_volume_size_in_gbs = lookup(var.instance_shape, "boot_volume_size", null)
  }

  connection {
    agent               = false
    timeout             = "10m"
    host                = self.private_ip
    user                = "opc"
    private_key         = file(var.ssh_private_key_path)
    bastion_host        = var.bastion_public_ip
    bastion_user        = var.bastion_user
    bastion_private_key = var.enable_bastion || var.bastion_public_ip != "" ? file(var.bastion_private_key_path) : ""
  }

  create_vnic_details {
    assign_public_ip = "false"
    subnet_id        = var.subnet_id
    hostname_label   = format("${var.prefix}-%03d", count.index + 1)
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
  }

  provisioner "file" {
    content     = var.init_script
    destination = "/home/${var.compute_user}/ocne-init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "set -x",
      "sudo bash /home/${var.compute_user}/ocne-init.sh"
    ]
  }
}

resource "oci_core_vnic_attachment" "second_vnic" {
  count       = var.attach_secondary_vnic ? var.instance_count : 0
  instance_id = oci_core_instance.instance[count.index].id
  create_vnic_details {
    assign_public_ip = "false"
    #   subnet_id        = var.secondary_subnet_id
    subnet_id     = var.subnet_id
    freeform_tags = var.freeform_tags
  }
}

data "oci_core_vnic" "second_vnic" {
  count   = var.attach_secondary_vnic ? var.instance_count : 0
  vnic_id = oci_core_vnic_attachment.second_vnic[count.index].vnic_id
}

resource "null_resource" "assign_vnics" {
  count      = var.attach_secondary_vnic ? var.instance_count : 0
  depends_on = [oci_core_vnic_attachment.second_vnic, data.oci_core_vnic.second_vnic]

  provisioner "remote-exec" {
    connection {
      agent               = false
      timeout             = "10m"
      host                = oci_core_instance.instance[count.index].private_ip
      user                = "opc"
      private_key         = file(var.ssh_private_key_path)
      bastion_host        = var.bastion_public_ip
      bastion_user        = var.bastion_user
      bastion_private_key = var.enable_bastion || var.bastion_public_ip != "" ? file(var.bastion_private_key_path) : ""
    }
    inline = [
      "set -x",
      "timeout 10m bash -c \"until (/sbin/ip addr | grep '${data.oci_core_vnic.second_vnic[count.index].private_ip_address}[^0-9]'); do sleep 2; sudo oci-network-config -a; done\"; sudo firewall-cmd --add-interface=ens5; sudo firewall-cmd --zone=public --change-interface=ens5",
    ]
  }
}

resource "oci_core_volume" "volume_resource" {
  # volume size should be between 50 GB and 32768 GB
  count               = (var.extra_disk_size_in_gbs >= 50) ? var.instance_count : 0
  availability_domain = var.availability_domain_id
  compartment_id      = var.compartment_id
  display_name        = format("${var.prefix}-%03d", count.index + 1)
  size_in_gbs         = var.extra_disk_size_in_gbs
}

resource "oci_core_volume_attachment" "volume_attachment" {
  depends_on      = [oci_core_instance.instance, oci_core_volume.volume_resource]
  attachment_type = "iscsi"
  # volume size should be between 50 GB and 32768 GB
  count           = (var.extra_disk_size_in_gbs >= 50) ? var.instance_count : 0
  instance_id     = oci_core_instance.instance[count.index].id
  volume_id       = oci_core_volume.volume_resource[count.index].id
  connection {
      agent       = false
      timeout     = "30m"
      host        = oci_core_instance.instance[count.index].private_ip
      user        = "opc"
      private_key = file(var.ssh_private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo iscsiadm -m node -o new -T ${self.iqn} -p ${self.ipv4}:${self.port}",
      "sudo iscsiadm -m node -o update -T ${self.iqn} -n node.startup -v automatic",
      "sudo iscsiadm -m node -T ${self.iqn} -p ${self.ipv4}:${self.port} -l",
    ]
  }
}
