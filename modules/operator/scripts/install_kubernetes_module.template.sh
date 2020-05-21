#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

echo 'Validating Kubernetes module'

while [ true ]; 
do
  sleep 10
  olcnectl --api-server 127.0.0.1:8091 module validate --environment-name "${environment}" \
  --name "${cluster_name}"
  if [ $? == 0 ]
  then
    echo 'Kubernetes module validated. Installing Kubernetes module'
    olcnectl --api-server 127.0.0.1:8091 module install --environment-name "${environment}" \
    --name "${cluster_name}" 2> /dev/null
    echo 'Kubernetes module installed'
    break
  else
    echo 'Kubernetes module failed validation'
  fi
done
