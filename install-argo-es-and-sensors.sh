#!/bin/sh

sed "s/PROJECT_ID/${PROJECT_ID}/" argo/gcp-pubsub-tasks.yaml | kubectl apply -f -
sed "s#MEGAHIT_IMAGE#${MEGAHIT_IMAGE}#" argo/megahit-sensor.yaml | kubectl apply -f -
