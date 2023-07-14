# oci-ocne-compute

This module deploys a number of compute resources in the configured OCI tenant, region, compartment, and availability domain.  It also will wait for any cloud-init scripts to finish before the module finishes, ensuring that anything consuming these instances can count on instantiation having completed.

## Getting Started

The best place to start when using these Terraform modules is in the `terraform-oci-olcne` module.  This module deploys a complete OCNE stack including a Kubernetes cluster.
