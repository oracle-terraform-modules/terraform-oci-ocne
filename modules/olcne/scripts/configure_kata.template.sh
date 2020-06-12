#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

echo 'Creating Kata Containers runtime'

kubectl apply -f kata.yaml 2> /dev/null
