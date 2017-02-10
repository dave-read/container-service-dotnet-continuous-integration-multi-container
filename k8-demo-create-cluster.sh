#!/bin/bash

k8name=dr-k8-cluster
acrname=drk8acr
location=westus

#az group create --name $k8name --location $location
#az acs create --name $k8name --resource-group $k8name --orchestrator-type Kubernetes --dns-prefix $k8name 

#az acs kubernetes get-credentials --resource-group $k8name --name $k8name

az acr create --name $acrname --resource-group $k8name  --location $location

