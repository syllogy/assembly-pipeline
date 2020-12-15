Assembly pipeline based on K8s, [argo](https://argoproj.github.io/argo/), [argo events](https://argoproj.github.io/argo-events/) and pubsub.

Source the envs file after filling in the details. The project should already be created.

Run the infra.sh shell script to set up the GKE cluster etc.

Run the build-and-push-containers.sh script to build the gcsfuse and megahit container images and push them to the container registry in the project.

Install CloudSQL Proxy service on the cluster for Argo workflows archive:
    ./install-cloudproxysq.sh

Allow the default K8s SA admin in the default NS:

    kubectl create rolebinding default-admin --clusterrole=admin --serviceaccount=default:default

[Install helm](https://helm.sh/docs/intro/install/). Add the argo repo and install argo workflow and argo events:

    helm repo add argo https://argoproj.github.io/argo-helm
    helm repo update
    helm install argo argo/argo -f argo/argo-values.yaml --set artifactRepository.gcs.bucket=${ARGO_ARCHIVE_BUCKET_NAME}
    helm install argo-events argo/argo-events
    kubectl apply -f https://raw.githubusercontent.com/argoproj/argo-events/stable/examples/eventbus/native.yaml

Run the install-gcsfuse.sh script to install the gcsfuse daemonset on the cluster.

Run the install-argo-es-and-sensors.sh to install the tasks and errors event sources and the megahit sensor.

Creating a task:

    gcloud pubsub topics publish --project ${PROJECT_ID} --message="{\"bucket\":\"${BUCKET_NAME}\", \"dir\":\"task1\", \"f1\":\"r3_1.fa\", \"f2\":\"r3_2.fa\", \"out\":\"out\", \"mem\":\"10000000000\", \"cpu\":\"3\"}" tasks

Exposing argo-server publicly secured by IAP:

    ./argo-server-iap.sh
The above script will work after the domain name is verified with Google, the user running the script is an [Owner](https://search.google.com/search-console/users). Once the load balancer is up, get the IP and add argo as an A record to the IP.
