#!/bin/sh

sed "s/PROJECT_ID:REGION:DB_INSTANCE_NAME/${PROJECT_ID}:${REGION}:${DB_INSTANCE_NAME}/" k8s/cloudsqlproxy.yaml | sed "s/ROOT_PASSWORD/${ROOT_PASSWORD}/" - | kubectl apply -f -
