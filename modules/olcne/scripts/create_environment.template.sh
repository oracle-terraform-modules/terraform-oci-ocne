#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

echo "Creating environment ${environment}"

olcnectl --api-server 127.0.0.1:8091 environment create --environment-name "${environment}" \
    --update-config \
    --secret-manager-type file \
    --olcne-node-cert-path /etc/olcne/configs/certificates/production/node.cert \
    --olcne-ca-path /etc/olcne/configs/certificates/production/ca.cert \
    --olcne-node-key-path /etc/olcne/configs/certificates/production/node.key 2> /dev/null

echo "Environment ${environment} configured"
