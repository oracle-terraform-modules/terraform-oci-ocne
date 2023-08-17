# Copyright (c) 2023 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/

module "bastion" {
  source = "../"

  # general oci parameters

  compartment_id = ""

  prefix = "dev"

  # network parameters
  ig_route_id = ""

  vcn_id = ""

  ssh_public_key = ""
}
