# Terraform for Oracle Cloud Native Environment

## Introduction

This repository is the top level for a modularized method for deploying OCNE and its subcomponents into OCI using terraform.  Each submodule focuses on a specific portion of an OCNE deploymnent, allowing users to select specific configurations to deploy.

This module will create the following resources:

![OCNE Infrastructure diagram:](/docs/images/ocne_infrastructure.png)
* **OCNE API Server**: The OCNE API Server to orchestrate OCNE agents running on Control Plane and Worker nodes to perform installation of Kubernetes and other OCNE modules.
* **Control Plane Nodes**: The compute instances for the Control Plane Nodes of Kubernetes cluster.
* **Worker Nodes**: The compute instances for the Worker Nodes of Kubernetes cluster.
* **Kubernetes API Load Balancer**: The Load Balancer to distribute Kubernetes API requrests to the Control Plane Nodes.

### High-Level Deployment Options

This module supports several common deployment scenarios out of the box.  They are listed here to avoid having to duplicated them in each of the relevant module descriptions below

 * OCNE API Server on a dedicated compute instance
 * Passing in a default network to build the deployment in
 * Allowing these modules to create and configure a new network
 * Use openssl to generate and distribute certificates to each node

## Getting Started

### Install Terraform
Start by installing Terraform and configuring your path.

#### Download Terraform

1. Open your browser and navigate to the [Terraform download page](https://www.terraform.io/downloads.html). You need version 1.0.0+.
2. Download the appropriate version for your operating system
3. Extract the contents of compressed file and copy the terraform binary to a location that is in your path (see next section below)

#### Configure path on Linux/macOS
Open a terminal and type the following:

```
$ sudo mv /path/to/terraform /usr/local/bin
```

#### Configure path on Windows
Follow the steps below to configure your path on Windows:

1. Click on 'Start', type 'Control Panel' and open it
2. Select System > Advanced System Settings > Environment Variables
3. Select System variables > PATH and click 'Edit'
4. Click New and paste the location of the directory where you have extracted the terraform.exe
5. Close all open windows by clicking OK
6. Open a new terminal and verify terraform has been properly installed

#### Testing Terraform installation
Open a terminal and test:

```
terraform -v
```

#### Install jq and yq
The OCNE provision module uses jq and yq to process yaml files
1. Install yq (>= 4.16): https://github.com/mikefarah/yq#install
2. Install jq (>= 1.5): https://stedolan.github.io/jq/download/

### Generate API keys

Follow the documentation for generating keys on [OCI Documentation](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#two).

### Upload your API keys

Follow the documentation for uploading your keys on [OCI Documentation](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#two).

Note the fingerprint.

### Create an OCI compartment

Follow the documentation for [creating a compartment](https://docs.cloud.oracle.com/iaas/Content/Identity/Tasks/managingcompartments.htm#two).

### Obtain the necessary OCIDs

The following OCIDs are required:

1. Compartment OCID
2. Tenancy OCID
3. User OCID

Follow the documentation for obtaining the tenancy and user ids on [OCI Documentation](https://docs.cloud.oracle.com/iaas/Content/API/Concepts/apisigningkey.htm#five).

To obtain the compartment OCID:

1. Navigate to Identity > Compartments
2. Click on your Compartment
3. Locate OCID on the page and click on 'Copy'

### Deploy OCNE using terraform

The best place to start when using these Terraform modules is in the `terraform-oci-olcne` module (i.e. here).  This module deploys a complete OCNE stack including a Kubernetes cluster.

The terraform.tfvars.example file can be renamed as terraform.tfvars to set the [input variables](https://www.terraform.io/docs/language/values/variables.html#assigning-values-to-root-module-variables) for the `terraform-oci-olcne` module.  Please refer to the variable
descriptions in variables.tf for information about how each is used.

#### Overview of terraform.tfvars.example file variables

| Name  |Description |
|:---------- |:-----------|
|tenancy_id|The OCID of your tenancy. To get the value, see [Where to Get the Tenancy's OCID and User's OCID](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five).|
|compartment_id|The OCID of the compartment.|
|user_id|The OCID of the user that will be used by terraform to create OCI resources. To get the value, see Where to Get the Tenancy's OCID and User's OCID.|
|fingerprint|Fingerprint for the key pair being used. To get the value, see [How to Get the Key's Fingerprint](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#four)|
|api_private_key_path|The path to the private key used by the OCI user to authenticate with OCI API's. For details on how to create and configure keys see [How to Generate an API Signing Key ](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#two) and [How to Upload the Public Key](https://docs.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#three).|
|region|The OCI region where resources will be created. To get the value, See [Regions and Availability Domains](https://docs.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm#top).|
|availability_domain_id|The ID of the availability domain inside the `region` to create the deployment|
|prefix|A unique prefix to attach to the name of all OCNE resources that are created as a part of the deployment.|
|ssh_private_key_path|The SSH private key path that goes with the SSH public key that is used when accessing compute resources that are created as part of this deployment. To generate the keys see - [Generating an SSH Key Pair for Oracle Compute Cloud Service Instances](https://www.oracle.com/webfolder/technetwork/tutorials/obe/cloud/compute-iaas/generating_ssh_key/generate_ssh_key.html).|
|ssh_public_key_path|The SSH public key path to use when configuring access to any compute resources created as part of this deployment. To generate the keys see - [Generating an SSH Key Pair for Oracle Compute Cloud Service Instances](https://www.oracle.com/webfolder/technetwork/tutorials/obe/cloud/compute-iaas/generating_ssh_key/generate_ssh_key.html).|
|control_plane_node_count|The number of Kubernetes control plane nodes to deploy. To view the recommended worker node count, please see [Kubernetes High Availability Requirements](https://docs.oracle.com/en/operating-systems/olcne/start/hosts.html#kube-nodes).|
|worker_node_count|The number of Kubernetes worker nodes to deploy. To view the recommended worker node count, please see [Kubernetes High Availability Requirements](https://docs.oracle.com/en/operating-systems/olcne/start/hosts.html#kube-nodes).|
|os_version|The version of Oracle Linux to use as the base image for all compute resources that are part of this deployemnt.|
|environment_name|The name of the OCNE Environment that is created by this module to deploy module instances into. For more details, please see [Creating an Environment](https://docs.oracle.com/en/operating-systems/olcne/start/install.html#env-create).|
|kubernetes_name|The name of the instance of the OCNE Kubernetes module that is installed as part of this deployment. For more details, please see [Creating a Kubernetes Module](https://docs.oracle.com/en/operating-systems/olcne/start/install.html#mod-kube).|
|ocne_version|The version and release of OCNE to deploy. For more details on the versions, please see the [OCNE Release Notes](https://docs.oracle.com/en/operating-systems/olcne/1.7/relnotes/components.html#components). To install the latest patch version of <major.minor>, please set the value to `<major.minor>` or set the value to `<major.minor.patch>` to install a specific patch version.|
|config_file_path|The path to the OCNE configuration file. For more details on the configuration file, please see the [OCNE configuration file](https://docs.oracle.com/en/operating-systems/olcne/1.7/olcnectl/config.html)|

#### Using Object Storage for State Files

Using Object Storage statefile requires that you create an AWS S3 Compatible API Key on OCI. This can be done from both the OCI UI and CLI.  For more details visit [Using Object Storage for State Files](https://docs.oracle.com/en-us/iaas/Content/API/SDKDocs/terraformUsingObjectStore.htm#s3).

To get started, rename `state_backend.tf.example` to `state_backend.tf` and fill out the appropriate variables. Variable definitions for the S3 Backend can be found in the [Hashicorp Terraform S3 Backend Documentation](https://www.terraform.io/docs/language/settings/backends/s3.html#credentials-and-shared-configuration).

#### Deploying Environment

Once all required variabes are set, source them and then initialise, validate and apply terraform. These commands must be run from within this module.


- `terraform init`

  > The `terraform init` command is used to initialize a working directory containing Terraform configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control. It is safe to run this command multiple times.

- `terraform validate`

  > The `terraform validate` command validates the configuration files in a directory, referring only to the configuration.

- `terraform apply`

  > The `terraform apply` command is used to apply the changes required to reach the desired state of the configuration.

## License

Copyright (c) 2019-2023 Oracle Corporation and/or affiliates.  All rights reserved.
Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl
