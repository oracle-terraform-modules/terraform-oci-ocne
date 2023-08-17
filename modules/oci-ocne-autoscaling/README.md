## oci-ocne-autoscaling

Deploys all resources for autoscaling OCI deployments.  This includes instance pools, load balancers and their associated objects, as well as any configuration required.  Note that it is not possible to synchronize on any per-compute-instance initialization from within this module.  It is incumbent upon the caller to ensure that deployed resources are fully operational.

## Getting Started

The best place to start when using these Terraform modules is in the `terraform-oci-olcne` module.  This module deploys a complete OCNE stack including a Kubernetes cluster.
