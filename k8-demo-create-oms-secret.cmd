echo off

if "%2"=="" (
    echo usage WSID KEY
    goto :end
)
kubectl create secret generic oms-agent-secret --from-literal=WSID=%1 --from-literal=KEY=%2

:end