#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

echo "Creating Kubernetes module ${cluster_name} in environment ${environment}"

olcnectl --api-server 127.0.0.1:8091 module create --environment-name "${environment}" \
  --module kubernetes --name "${cluster_name}" \
  --container-registry "${container_registry}"/olcne \
  --nginx-image "${container_registry}"/olcne/nginx:1.12.2 \
  --virtual-ip "${master_vip}" \
  --master-nodes "${master_nodes_addresses}" \
  --worker-nodes "${worker_nodes_addresses}" 2> /dev/null

echo "Kubernetes module ${cluster_name} created in environment ${environment}"
