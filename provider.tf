# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

provider "oci" {
  disable_auto_retries   = false
  fingerprint            = var.api_fingerprint
  private_key_path       = var.api_private_key_path
  region                 = var.region
  retry_duration_seconds = 60
  tenancy_ocid           = var.tenancy_id
  user_ocid              = var.user_id
}
