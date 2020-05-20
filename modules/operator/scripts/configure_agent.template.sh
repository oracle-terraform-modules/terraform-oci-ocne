#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

echo 'Configuring agent'

sudo /etc/olcne/bootstrap-olcne.sh \
    --secret-manager-type file \
    --olcne-node-cert-path /etc/olcne/configs/certificates/production/node.cert \
    --olcne-ca-path /etc/olcne/configs/certificates/production/ca.cert \
    --olcne-node-key-path /etc/olcne/configs/certificates/production/node.key \
    --olcne-component agent 2> /dev/null

echo 'Platform agent configured'
