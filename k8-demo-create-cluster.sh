#!/bin/bash
#
# Sample script for creating Kubernetes cluster using the Azure CLI v2
#
k8name=dr-k8-cluster
acrname=drk8acr
location=westus

# create resource group and cluster
az group create --name $k8name --location $location
az acs create --name $k8name --resource-group $k8name --orchestrator-type Kubernetes --dns-prefix $k8name 

# Get the cluster credentials.  Note this reuqires that your ssh key not be password protected.   
az acs kubernetes get-credentials --resource-group $k8name --name $k8name

# Create an Azure Container Registry instance.
az acr create --name $acrname --resource-group $k8name  --location $location

