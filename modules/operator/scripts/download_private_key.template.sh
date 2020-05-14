#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

oci secrets secret-bundle get --secret-id ${secret_id} | jq '[.data."secret-bundle-content"."content" ]' | tr -d "[ \" ]" | base64 -d > ~/.ssh/id_rsa