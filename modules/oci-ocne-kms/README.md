# oci-ocne-kms

Optionally creates an OCI KMS Vault and OCI KMS Vault Key.  If an existing vault or key is provided, they will be re-used.  Note that an OCI KMS Vault is not the same thing as a Hashicorp Vault.  In fact, the resources created by this module are typically consumed by the Hashicorp Vault module.

Note that allowing this module to generate keys and vault will create resources in OCI that are subject to OCI retention policies.  In particular, both of these objects will not be deleted until 30 days after they are destroyed.
When testing this module or one that consumed it, it is usually a good idea to manually create these resources and pass them in.  Otherwise it is very easy to hit the service limit for each type.

## Getting Started

The best place to start when using these Terraform modules is in the `terraform-oci-olcne` module.  This module deploys a complete OCNE stack including a Kubernetes cluster.
