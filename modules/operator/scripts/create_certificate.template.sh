#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

cd /etc/olcne

echo 'Generating certificates'

sudo ./gen-certs-helper.sh \
  --cert-request-organization-unit "${org_unit}" \
  --cert-request-organization "${org}" \
  --cert-request-locality "${city}" \
  --cert-request-state "${state}" \
  --cert-request-country "${country}" \
  --cert-request-common-name "${common_name}" \
  --nodes ${operator_node},${master_nodes},${worker_nodes} 2> /dev/null

echo 'Getting nodes public keys'

ssh-keyscan -H ${operator_node} ${scan_master_nodes} ${scan_worker_nodes} >> ~/.ssh/known_hosts 2> /dev/null

echo 'Copying certificates to all nodes'

bash -ex configs/certificates/olcne-tranfer-certs.sh 2> /dev/null

echo 'Certificates copied to all nodes'
