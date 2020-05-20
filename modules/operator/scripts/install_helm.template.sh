#!/bin/bash
# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

echo 'Installing helm'

wget https://get.helm.sh/helm-v"${helm_version}"-linux-amd64.tar.gz 2> /dev/null


tar zxvf helm-v"${helm_version}"-linux-amd64.tar.gz 2> /dev/null

sudo mv linux-amd64/helm /usr/local/bin 2> /dev/null

rm -f helm-v"${helm_version}"-linux-amd64.tar.gz 2> /dev/null

rm -rf linux-amd64 2> /dev/null

helm repo add stable https://kubernetes-charts.storage.googleapis.com 2> /dev/null

helm repo update 2> /dev/null

echo "source <(helm completion bash)" >> ~/.bashrc 
echo "alias h='helm'" >> ~/.bashrc