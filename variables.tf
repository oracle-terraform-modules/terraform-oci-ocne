# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

# provider parameters
variable "api_fingerprint" {
  description = "fingerprint of oci api private key"
  type        = string
}

variable "api_private_key_path" {
  description = "path to oci api private key"
  type        = string
}

variable "region" {
  # List of regions: https://docs.cloud.oracle.com/iaas/Content/General/Concepts/regions.htm#ServiceAvailabilityAcrossRegions
  description = "region"
  type        = string
}

variable "tenancy_id" {
  description = "tenancy id"
  type        = string
}

variable "user_id" {
  description = "user id"
  type        = string
}

# general oci parameters
variable "compartment_id" {
  description = "compartment id"
  type        = string
}

variable "label_prefix" {
  description = "a string that will be prependend to all resources"
  default     = "dev"
  type        = string
}

# ssh keys
variable "ssh_private_key_path" {
  description = "path to ssh private key"
  type        = string
}

variable "ssh_public_key_path" {
  description = "path to ssh public key"
  type        = string
}

# networking parameters

variable "netnum" {
  description = "zero-based index of the subnet when the network is masked with the newbit."
  default = {
    operator = 33
    bastion  = 32
    int_lb   = 16
    master   = 48
    operator = 18
    pub_lb   = 17
    worker   = 1
  }
  type = map
}

variable "newbits" {
  description = "new mask for the subnet within the virtual network. use as newbits parameter for cidrsubnet function"
  default = {
    operator = 13
    bastion  = 13
    lb       = 11
    master   = 12
    operator = 13
    worker   = 2
  }
  type = map
}

variable "vcn_cidr" {
  description = "cidr block of VCN"
  default     = "10.0.0.0/16"
  type        = string
}

variable "vcn_dns_label" {
  description = "internal vcn dns domain that will be prepended to oraclevcn.com"
  default     = "olcne"
  type        = string
}

variable "vcn_name" {
  description = "name of vcn"
  default     = "olcne"
  type        = string
}

# bastion
variable "bastion_access" {
  description = "cidr from where the bastion can be sshed into. default is ANYWHERE and equivalent to 0.0.0.0/0"
  default     = "ANYWHERE"
  type        = string
}

variable "bastion_image_id" {
  description = "image id to use for bastion."
  default     = "Autonomous"
  type        = string
}

variable "bastion_notification_enabled" {
  description = "whether to enable notification on the bastion host"
  default     = false
  type        = bool
}

variable "bastion_notification_endpoint" {
  description = "the subscription notification endpoint for the bastion. email address to be notified."
  default     = ""
  type        = string
}

variable "bastion_notification_protocol" {
  description = "The notification protocol used."
  default     = "EMAIL"
  type        = string
}

variable "bastion_notification_topic" {
  description = "the name of the notification topic."
  default     = "bastion"
  type        = string
}

variable "bastion_package_upgrade" {
  description = "whether to upgrade the bastion host packages after provisioning. it’s useful to set this to false during development so the bastion is provisioned faster."
  default     = true
  type        = bool
}

variable "bastion_shape" {
  description = "shape of bastion instance"
  default     = "VM.Standard.E2.1"
  type        = string
}

variable "bastion_timezone" {
  description = "the preferred timezone for the bastion host."
  default     = "Australia/Sydney"
  type        = string
}

# operator server

variable "operator_image_id" {
  description = "image id to use for operator server. set either an image id or to Oracle. if value is set to Oracle, the default Oracle Linux platform image will be used."
  default     = "Oracle"
  type        = string
}

variable "operator_instance_principal" {
  description = "enable the operator server host to call OCI API services without requiring api key"
  default     = true
  type        = bool
}

variable "operator_notification_enabled" {
  description = "whether to enable notification on the operator host"
  default     = false
  type        = bool
}

variable "operator_notification_endpoint" {
  description = "the subscription notification endpoint for the operator. email address to be notified."
  default     = ""
  type        = string
}

variable "operator_notification_protocol" {
  description = "the notification protocol used."
  default     = "EMAIL"
  type        = string
}

variable "operator_notification_topic" {
  description = "the name of the notification topic."
  default     = "operator"
  type        = string
}

variable "operator_package_upgrade" {
  description = "whether to upgrade the bastion host packages after provisioning. it’s useful to set this to false during development so the bastion is provisioned faster."
  default     = true
  type        = bool
}

variable "operator_shape" {
  description = "shape of operator server instance"
  default     = "VM.Standard.E2.1"
  type        = string
}

variable "operator_timezone" {
  description = "the preferred timezone for the operator host."
  default     = "Australia/Sydney"
  type        = string
}

# availability domains
variable "availability_domains" {
  description = "Availability Domains where to provision specific resources"
  default = {
    bastion  = 1
    operator = 1
    operator = 1
  }
  type = map
}

# olcne

variable "allow_master_ssh_access" {
  description = "whether to allow ssh access to master nodes"
  default     = false
  type        = bool
}

variable "allow_worker_ssh_access" {
  description = "whether to allow ssh access to worker nodes"
  default     = false
  type        = bool
}

# olcne master
variable "master_image_id" {
  description = "image id to use for master nodes."
  default     = "Oracle Linux"
  type        = string
}

variable "master_package_upgrade" {
  description = "whether to upgrade the master host packages after provisioning. it’s useful to set this to false during development so the master nodes are provisioned faster."
  default     = true
  type        = bool
}

variable "master_shape" {
  description = "shape of master instance"
  default     = "VM.Standard.E2.2"
  type        = string
}

variable "master_size" {
  description = "number of master nodes to provision"
  default     = 1
  type        = number
}

variable "master_timezone" {
  description = "the preferred timezone for the master nodes."
  default     = "Australia/Sydney"
  type        = string
}

variable "secret_id" {
  description = "id of OCI secret where the private ssh key is stored in encrypted format"
  type        = string
}

variable "environment_name" {
  description = "name of the environment"
  default     = "dev"
  type        = string
}

variable "cluster_name" {
  description = "name of the cluster"
  default     = "olcne"
  type        = string
}

variable "helm_version" {
  description = "version of helm client to install on operator"
  default     = "3.1.1"
  type        = string
}

# kata
variable "create_kata_runtime" {
  description = "whether to create kata runtime class"
  default     = false
  type        = bool
}

variable "kata_runtime_class_name" {
  description = "the name of the kata runtime class"
  default     = "kata"
  type        = string
}

# private CA certificate parameters

variable "org_unit" {
  description = ""
  type        = string
}

variable "org" {
  description = ""
  type        = string
}

variable "city" {
  description = ""
  type        = string
}

variable "state" {
  description = ""
  type        = string
}

variable "country" {
  description = "2 letter country code"
  type        = string
}

variable "common_name" {
  description = ""
  type        = string
}

# olcne worker
variable "worker_image_id" {
  description = "image id to use for worker nodes."
  default     = "Oracle Linux"
  type        = string
}

variable "worker_package_upgrade" {
  description = "whether to upgrade the worker host packages after provisioning. it’s useful to set this to false during development so the worker nodes are provisioned faster."
  default     = true
  type        = bool
}

variable "worker_shape" {
  description = "shape of worker instance"
  default     = "VM.Standard.E2.2"
  type        = string
}

variable "worker_size" {
  description = "number of worker nodes to provision"
  default     = 3
  type        = number
}

variable "worker_timezone" {
  description = "the preferred timezone for the worker nodes."
  default     = "Australia/Sydney"
  type        = string
}

# load balancer

variable "int_lb_shape" {
  description = "the preferred shape of the internal load balancer"
  default     = "100Mbps"
  type        = string
}

variable "public_lb_shape" {
  description = "the preferred shape of the public load balancer"
  default     = "100Mbps"
  type        = string
}

# tagging
variable "tags" {
  default = {
    # vcn, bastion and operator tags are required
    # add more tags in each as desired
    vcn = {
      # department = "finance"
      environment = "dev"
    }
    bastion = {
      # department  = "finance"
      environment = "dev"
      role        = "bastion"
    }
    operator = {
      # department = "finance"
      environment = "dev"
      role        = "operator"
    }
  }
  description = "Tags to apply to different resources."
  type        = map(any)
}
