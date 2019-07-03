#!/bin/bash

PROJECT=training-190916
ZONE=europe-west1-d
CLUSTER_NAME=gke-rbac
DEV_GROUP=gke-rbac-users@fourcast.io
ROLE_NAME=GKE_authenticate_users

#Creating the appropriate least-privileged IAM role"
echo "### Step 1 - Creating IAM role"
gcloud iam roles create $ROLE_NAME --file iam.yaml --project $PROJECT

# Grant the above IAM role to our developer group
# It is a security best practice to create a Group and grant the IAM permissions to this Group.
# Then add members to this group to inherit these permissions.
echo "### Step 2 - Granting IAM role"
gcloud projects add-iam-policy-binding $PROJECT --member group:$DEV_GROUP --role projects/$PROJECT/roles/$ROLE_NAME

# Create a brand new GKE cluster
# As of v1.12, Legacy ABAC is disabled by default, which we need for RBAC to function.
echo "### Step 3 - Creating GKE cluster"
gcloud container clusters create $CLUSTER_NAME --project $PROJECT --zone $ZONE

# Use gcloud to populate your ~/.kube/config. This will add the cluster and your gcloud user and combine them in a kubectl context.
echo "### Step 4 - Get admin credentials to cluster"
gcloud container clusters get-credentials $CLUSTER_NAME --project $PROJECT --zone $ZONE

# Create the role, and bind the new user to the role.
# Be sure to change the email address for the group to your liking before applying.
echo "### Step 5 - Creating namespace and role for namespace"
kubectl apply -f rbac.yaml

# Now all users from the Group will be able to use the dev namespace!
 #and be limited to the DEV namespace. Just make sure they do not have more permissive IAM roles on GCP, and Legacy ABAC is disabled if you are trying this on an existing cluster!
echo "### Step 6"
echo "have any of the members of the group run the following command to gain (limited) access"
echo "gcloud container clusters get-credentials ${CLUSTER_NAME} --project ${PROJECT} --zone ${ZONE}"

echo "### Step 7"
echo "There is no step 7. Time for a good Belgian beer\!"