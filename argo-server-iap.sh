#!/bin/sh

sed "s/ARGO_SERVER_DOMAIN/${ARGO_SERVER_DOMAIN}/" k8s/argo-server-cert.yaml | kubectl apply -f -
kubectl apply -f k8s/argo-server-backendconfig.yaml
kubectl apply -f k8s/argo-server-ingress.yaml
