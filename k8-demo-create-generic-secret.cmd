echo off

if "%3"=="" (
    echo usage SecretName WSID KEY
    goto :end
)
kubectl create secret generic %1 --from-literal=WSID=%2 --from-literal=KEY=%3

:end