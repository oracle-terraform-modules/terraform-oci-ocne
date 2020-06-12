#!/bin/bash

# Copyright 2020, Oracle Corporation and/or affiliates.  
# Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl

echo 'Creating Ingress Controller'

kubectl create ns nginx 

helm install nginx stable/nginx-ingress \
--namespace nginx \
--set controller.name=nginx \
--set controller.containerPort.http=80 \
--set controller.containerPort.https=443 \
--set controller.ingressClass=nginx \
--set controller.autoscaling.enabled=true \
--set controller.autoscaling.minReplicas=3 \
--set controller.service.externalIPs={"${loadbalancer_ip_address}"} \
--set controller.service.externalTrafficPolicy=Local \
--set controller.service.targetPorts.http=80 \
--set controller.service.targetPorts.https=443 \
--set controller.service.type=NodePort \
--set controller.service.nodePorts.http=30080 \
--set controller.service.nodePorts.https=30443 \
--set controller.service.ports.http=30080 \
--set controller.service.ports.https=30443 \
--set rbac.create=true 2> /dev/null

# patch to add nodeports for nginx health check
kubectl --namespace nginx patch svc nginx-nginx-ingress-nginx --patch "$(cat nginxpatch.yaml)" 2> /dev/null