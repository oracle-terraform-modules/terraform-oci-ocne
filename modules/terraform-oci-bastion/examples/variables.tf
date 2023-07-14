# Copyright (c) 2023 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# provider identity parameters
variable "fingerprint" {
  description = "fingerprint of oci api private key"
  type        = string
  default     = ""
}

variable "api_private_key_path" {
  description = "path to oci api private key used"
  type        = string
  default     = ""
}

variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "the oci region where resources will be created"
  type        = string
}

variable "tenancy_id" {
  description = "tenancy id where to create the sources"
  type        = string
}

variable "user_id" {
  description = "id of user that terraform will use to create the resources"
  type        = string
}

# general oci parameters

variable "compartment_id" {
  description = "compartment id where to create all resources"
  type        = string
}

variable "prefix" {
  description = "a string that will be prepended to all resources"
  type        = string
  default     = "none"
}

# bastion module parameters

variable "ig_route_id" {
  type = string
}

variable "vcn_id" {
  type = string
}

variable "ssh_public_key" {
  type = string
}
