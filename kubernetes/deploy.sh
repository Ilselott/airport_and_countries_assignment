#!/bin/bash

## Get mandatory ressources
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/provider/cloud-generic.yaml
## Create the applications pods and services
kubectl apply -f $(dirname $0)/airports.yaml
kubectl apply -f $(dirname $0)/countries.yaml
#destroy any previous load balancer
kubectl delete Ingress exemple-ingress
# Launches the Ingress load balancer and reverse proxy
kubectl create -f $(dirname $0)/ingress.yaml
