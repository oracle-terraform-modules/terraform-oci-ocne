# terraform-oci-ocne-infrastructure

This module deploys all OCI resources required for the OCNE Platform as well as any OCNE Modules.  It accepts a cloud-init script from any callers that can be used to configure the nodes that will host
OCNE Agents as well as nodes that will host OCNE API Servers. Aside from these options, this module performs no OCNE-specific configuration or setup.

## Getting Started

The best place to start when using these Terraform modules is in the `terraform-oci-olcne` module.  This module deploys a complete OCNE stack including a Kubernetes cluster.
