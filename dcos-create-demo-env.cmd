
rem sets up demo described here: https://docs.microsoft.com/en-us/azure/container-service/container-service-setup-ci-cd
echo off
if "%4"=="" (
    echo usage clusterName dnsPrefix region gitHubKey
    goto :end
)
rem modify as needed defaults to using clusterName for resource group and vsts project name
set clusterName=%1
set resourceGroupName=%1
set dnsPrefix=%2
set region=%3
set gitHubKey=%4

set sshKeyLocation="%HOMEPATH%\.ssh\azure_vm_rsa.pub"

rem create resource group
rem call az group create --name %resourceGroupName% --location %region%
rem create cluster
rem call az acs create ^
 --orchestrator-type DCOS ^
 --resource-group %resourceGroupName% ^
 --name %clusterName% ^
 --dns-prefix %dnsPrefix% ^
 --ssh-key-value %sshKeyLocation%
rem create ci/cd environment
az container release create ^
 --target-name %clusterName% ^
 --target-resource-group %resourceGroupName% ^
 --vsts-project-name %clusterName
 --remote-access-token %gitHubKey%

:end
