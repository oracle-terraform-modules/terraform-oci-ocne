#!/bin/bash
# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

echo 'Installing Helm'

sudo yum install -y helm-${helm_version} 2> /dev/null

helm repo add stable https://kubernetes-charts.storage.googleapis.com 2> /dev/null

helm repo update 2> /dev/null

echo "source <(helm completion bash)" >> ~/.bashrc 
echo "alias h='helm'" >> ~/.bashrc