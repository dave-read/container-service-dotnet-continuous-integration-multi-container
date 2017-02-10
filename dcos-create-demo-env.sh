#!/bin/bash
# sets up demo described here: https://docs.microsoft.com/en-us/azure/container-service/container-service-exportup-ci-cd
#
# NOTE: You MUST have git version 2.7 or greater for the GitHub integration to be able register based on information 
#       in the local repo.  If you don't have git 2.7 you'll need to provide the repo URL via --remote-url option  
#
if [ ! "$4" ]
then
    echo usage clusterName dnsPrefix region gitHubKey
    exit 1
fi

# modify as needed defaults to using clusterName for resource group and vsts project name
export clusterName=$1
export resourceGroupName=$1
export dnsPrefix=$2
export region=$3
export gitHubKey=$4

export sshKeyLocation="~/.ssh/id_rsa.pub"

# create resource group
az group create --name $resourceGroupName --location $region

# create cluster
az acs create \
  --orchestrator-type DCOS \
  --resource-group $resourceGroupName \
  --name $clusterName \
  --dns-prefix $dnsPrefix \
  --ssh-key-value $sshKeyLocation

# create ci/cd environment
az container release create \
 --target-name $clusterName \
 --target-resource-group $resourceGroupName \
 --vsts-project-name $clusterName \
 --remote-access-token $gitHubKey

 # onece the cluster is running you can use the browse sub-command to create a proxy to the cluster
 # az acs dcos browse -g acs-dcos-demo -n acs-dcos-demo
