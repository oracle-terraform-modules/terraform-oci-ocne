# Terraform OCI Bastion for Oracle Cloud Infrastructure

[changelog]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/master/CHANGELOG.adoc
[contributing]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/master/CONTRIBUTING.adoc
[contributors]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/master/CONTRIBUTORS.adoc
[docs]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/tree/master/docs

[license]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/master/LICENSE
[canonical_license]: https://oss.oracle.com/licenses/upl/

[oci]: https://cloud.oracle.com/cloud-infrastructure
[oci_documentation]: https://docs.cloud.oracle.com/iaas/Content/home.htm

[oracle]: https://www.oracle.com
[prerequisites]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/master/docs/prerequisites.adoc

[quickstart]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/master/docs/quickstart.adoc
[repo]: https://github.com/oracle/terraform-oci-bastion
[reuse]: https://github.com/oracle/terraform-oci-bastion/examples/db
[subnets]: https://erikberg.com/notes/networks.html
[terraform]: https://www.terraform.io
[terraform_cidr_subnet]: http://blog.itsjustcode.net/blog/2017/11/18/terraform-cidrsubnet-deconstructed/
[terraform_hashircorp_examples]: https://github.com/hashicorp/terraform-guides/tree/master/infrastructure-as-code/terraform-0.12-examples
[terraform_oci]: https://www.terraform.io/docs/providers/oci/index.html
[terraform_options]: https://github.com/oracle-terraform-modules/terraform-oci-bastion/blob/master/docs/terraformoptions.adoc
[terraform_oci_examples]: https://github.com/terraform-providers/terraform-provider-oci/tree/master/examples
[terraform_oci_oke]: https://github.com/oracle-terraform-modules/terraform-oci-oke

The [Terraform OCI Bastion][repo] for [Oracle Cloud Infrastructure][OCI] provides a [Terraform][terraform] module that reuses an existing VCN and adds a bastion host to it.

It creates the following resources:

* A configurable security list to allow ssh access from a defined CIDR block
* A public subnet
* A compute instance
* An optional notification via email

This module is primarily meant to be reusable to provide an entry point into your infrastructure on {uri-oci}[OCI].
You can further use it as part of higher level Terraform modules

## [Documentation][docs]

### [Pre-requisites][prerequisites]

#### Instructions
- [Quickstart][quickstart]
- [Reusing as a Terraform module][reuse]
- [Terraform Options][terraform_options]

## Related Documentation, Blog
- [Oracle Cloud Infrastructure Documentation][oci_documentation]
- [Terraform OCI Provider Documentation][terraform_oci]
- [Erik Berg on Networks, Subnets and CIDR][subnets]
- [Lisa Hagemann on Terraform cidrsubnet Deconstructed][terraform_cidr_subnet]

## Projects using this module

## Changelog

View the [CHANGELOG][changelog].

## Acknowledgement

Code derived and adapted from [Terraform OCI Examples][terraform_oci_examples] and Hashicorp's [Terraform 0.12 examples][terraform_oci_examples]

## Contributors

[Folks who contributed with explanations, code, feedback, ideas, testing etc.][contributors]

Learn how to [contribute][contributing].

## License

Copyright (c) 2023 Oracle and/or its associates. All rights reserved.

Licensed under the [Universal Permissive License 1.0][license] as shown at 
[https://oss.oracle.com/licenses/upl][canonical_license].

