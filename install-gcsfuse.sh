#!/bin/sh

sed "s/BUCKET_NAME/${BUCKET_NAME}/" k8s/gcsfuse.yaml | sed "s#GCSFUSE_IMAGE#${GCSFUSE_IMAGE}#" - | kubectl apply -f -
