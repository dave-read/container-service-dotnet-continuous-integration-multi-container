
rem sets up demo described here: https://docs.microsoft.com/en-us/azure/container-service/container-service-setup-ci-cd
rem modify as needed
echo on 

set resourceGroupName=acs-dcos-demo
set region=westus
set dnsPrefix=dr-acs-demo
set clusterName=acs-dcos-demo
set sshKeyLocation="%HOMEPATH%\.ssh\azure_vm_rsa.pub"

rem create resource group
call az group create --name %resourceGroupName% --location %region%
rem create cluster
call az acs create ^
 --orchestrator-type DCOS ^
 --resource-group %resourceGroupName% ^
 --name %clusterName% ^
 --dns-prefix %dnsPrefix% ^
 --ssh-key-value %sshKeyLocation%

REM az container release create \
REM --target-name myacs \
REM --target-resource-group myacs-rg \
REM --remote-access-token <GitHubPersonalAccessToken>