# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

data "template_file" "operator_template" {
  template = file("${path.module}/scripts/operator.template.sh")
}

data "oci_core_instances" "operator" {
    compartment_id = var.compartment_id
    display_name = "${var.label_prefix}-operator"
}