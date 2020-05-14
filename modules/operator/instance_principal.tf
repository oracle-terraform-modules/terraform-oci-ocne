# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# create a home region provider for identity operations
provider "oci" {
  alias            = "home"
  fingerprint      = var.oci_provider.api_fingerprint
  private_key_path = var.oci_provider.api_private_key_path
  region           = var.oci_provider.home_region
  tenancy_ocid     = var.oci_provider.tenancy_id
  user_ocid        = var.oci_provider.user_id
}

resource "oci_identity_dynamic_group" "operator_instance_principal" {
  provider       = oci.home
  compartment_id = var.oci_provider.tenancy_id
  depends_on     = [oci_core_instance_pool.operator, data.oci_core_instance.operator]
  description    = "dynamic group to allow instances to call services for operator"
  matching_rule  = "ALL {instance.id = '${join(",", data.oci_core_instance.operator.*.id)}'}"
  name           = "${var.olcne_general.label_prefix}-operator-instance-principal"
}

resource "oci_identity_policy" "use_secret" {
  provider       = oci.home
  compartment_id = var.olcne_general.compartment_id
  depends_on     = [oci_identity_dynamic_group.operator_instance_principal]
  description    = "policy to allow dynamic group ${var.olcne_general.label_prefix}-operator-instance-principal to use secrets in vault"
  name           = "${var.olcne_general.label_prefix}-operator-use-secrets"
  statements     = [local.policy_statement_secret]
}
