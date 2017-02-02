echo off

if "%5"=="" (
    echo usage name url user password email
    goto :end
)
kubectl create secret docker-registry %1 --docker-server=%2 --docker-username=%3 --docker-password=%4 --docker-email=%5

:end