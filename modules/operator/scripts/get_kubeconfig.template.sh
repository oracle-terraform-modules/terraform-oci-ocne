#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

echo 'getting kubeconfig'

mkdir .kube

olcnectl --api-server 127.0.0.1:8091 module property get \
  --environment-name ${environment} --name ${cluster_name} \
  --property kubecfg | base64 -d > .kube/config

echo "source <(kubectl completion bash)" >> ~/.bashrc
echo "alias k='kubectl'" >> ~/.bashrc