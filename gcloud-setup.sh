#!/bin/bash

PROJECT=pega88-sandbox
ZONE=europe-west1-d
CLUSTER_NAME=gke-rbac
DEV_GROUP=gke-rbac-users@fourcast.io
ROLE_NAME=GKE_authentication_users
# Step 1.
# Create the appropriate least-privileged IAM role
gcloud iam roles create $ROLE_NAME --file iam.yaml --project $PROJECT

# Step 2.
# Grant the above IAM role to our developer group
# It is a security best practice to create a Group and grant the IAM permissions to this Group.
# Then add members to this group to inherit these permissions.
gcloud projects add-iam-policy-binding $PROJECT --member group:$DEV_GROUP --role projects/$PROJECT/roles/$ROLE_NAME

# Step 3.
# Create a brand new GKE cluster
# As of v1.12, Legacy ABAC is disabled by default, which we need for RBAC to function.
gcloud container clusters create $CLUSTER_NAME --project $PROJECT --zone $ZONE

# Step 4.
# Use gcloud to populate your ~/.kube/config. This will add the cluster and your gcloud user and combine them in a kubectl context.
gcloud container clusters get-credentials $CLUSTER_NAME --project $PROJECT --zone $ZONE

# Step 5.
# Create the role, and bind the new user to the role.
# Be sure to change the email address for the group to your liking before applying.
kubectl apply -f https://github.com/Fourcast/GKE-rbac/blob/master/rbac.yaml