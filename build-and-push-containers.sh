#!/bin/sh

gcloud auth configure-docker

docker build ./megahit -t gcr.io/${PROJECT_ID}/megahit:v1.2.9 && \
	docker push gcr.io/${PROJECT_ID}/megahit:v1.2.9

docker build ./gcsfuse -t gcr.io/${PROJECT_ID}/gcsfuse:latest && \
	docker push gcr.io/${PROJECT_ID}/gcsfuse:latest
