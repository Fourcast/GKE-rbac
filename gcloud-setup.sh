#!/bin/bash

PROJECT=pega88-sandbox
ZONE=europe-west1-d
#Step 1.
#create the appropriate least-privileged IAM role
gcloud iam roles create GKE_developer_2 --file iam.yaml --project $PROJECT

#Step 2.
#create a brand new GKE cluster
#as of v1.12, Legacy ABAC is disabled by default, which we need for RBAC to function.
gcloud container clusters create gke-rbac --project $PROJECT --zone $ZONE