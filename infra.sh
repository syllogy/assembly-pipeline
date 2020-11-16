#!/bin/sh

gcloud services enable \
	--project ${PROJECT_ID} \
        container.googleapis.com \
	pubsub.googleapis.com \
	pubsub.googleapis.com

gcloud iam service-accounts create \
	--project ${PROJECT_ID} \
	${CLUSTER_NAME}

gsutil mb \
	-p ${PROJECT_ID} \
	-l ${REGION} \
	gs://${BUCKET_NAME}

gsutil iam ch \
        serviceAccount:${CLUSTER_SA}:roles/storage.admin \
        gs://${BUCKET_NAME}	

gcloud projects add-iam-policy-binding \
	--member serviceAccount:${CLUSTER_SA} \
	--role roles/logging.logWriter \
	${PROJECT_ID}

gcloud projects add-iam-policy-binding \
	--member serviceAccount:${CLUSTER_SA} \
	--role roles/monitoring.metricWriter \
	${PROJECT_ID}


gcloud projects add-iam-policy-binding \
	--member serviceAccount:${CLUSTER_SA} \
	--role roles/pubsub.editor \
	${PROJECT_ID}

gcloud projects add-iam-policy-binding \
	--member serviceAccount:${CLUSTER_SA} \
	--role roles/stackdriver.resourceMetadata.writer \
	${PROJECT_ID}

gcloud projects add-iam-policy-binding \
	--member serviceAccount:${CLUSTER_SA} \
	--role roles/storage.objectViewer \
	${PROJECT_ID}

gcloud pubsub topics create \
	--project ${PROJECT_ID} \
	tasks

gcloud pubsub subscriptions create \
	--project ${PROJECT_ID} \
	--topic tasks \
	argo-tasks

gcloud pubsub topics create \
	--project ${PROJECT_ID} \
	errors

gcloud pubsub subscriptions create \
	--project ${PROJECT_ID} \
	--topic errors \
	argo-errors

gcloud compute routers create \
	--project ${PROJECT_ID} \
	--network default \
	--region ${REGION} \
        nat-router

gcloud compute routers nats create \
	--project ${PROJECT_ID} \
	--router-region ${REGION} \
        --router=nat-router \
        --auto-allocate-nat-external-ips \
        --nat-all-subnet-ip-ranges \
	nat

gcloud beta container clusters create \
	--project ${PROJECT_ID} \
	--region ${REGION} \
	--no-enable-basic-auth \
	--release-channel "regular" \
	--machine-type ${DEFAULT_POOL_MACHINE_TYPE} \
	--image-type "COS" \
	--disk-type "pd-standard" \
	--disk-size "100" \
	--metadata disable-legacy-endpoints=true \
	--service-account ${CLUSTER_SA} \
	--num-nodes "1" \
        --enable-autoscaling --min-nodes "2" --max-nodes "3" \
	--enable-stackdriver-kubernetes \
	--enable-private-nodes \
	--master-ipv4-cidr "172.16.0.0/28" \
	--enable-ip-alias \
	--enable-master-authorized-networks --master-authorized-networks ${MASTER_AUTH_NETWORKS} \
       	--addons HorizontalPodAutoscaling,HttpLoadBalancing \
	--enable-autoupgrade \
	--enable-autorepair \
	--max-surge-upgrade 1 \
	--max-unavailable-upgrade 0 \
	${CLUSTER_NAME} \
	&& \
	gcloud beta container node-pools create \
	--project ${PROJECT_ID} \
	--cluster ${CLUSTER_NAME} \
	--region ${REGION} \
	--machine-type ${POOL_1_MACHINE_TYPE} \
       	--image-type "COS" \
	--disk-type "pd-standard" \
	--disk-size "100" \
	--metadata disable-legacy-endpoints=true \
	--service-account ${CLUSTER_SA} \
	--preemptible \
	--num-nodes "1" \
	--enable-autoscaling --min-nodes "0" --max-nodes "10" \
	--enable-autoupgrade \
	--enable-autorepair \
	--max-surge-upgrade 1 \
	--max-unavailable-upgrade 0 \
	--node-taints cloud.google.com/gke-preemptible="true":NoSchedule \
	"pool-1"

gcloud container clusters get-credentials \
	--project ${PROJECT_ID} \
	--region ${REGION} \
	${CLUSTER_NAME}
