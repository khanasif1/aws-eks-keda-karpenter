#!/bin/bash
echo "Setting environment variables"
export KARPENTER_VERSION=v0.20.0 #v0.26.1   
export CLUSTER_NAME="eks-demo-scale"
export AWS_REGION="us-west-1"
export ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export TEMPOUT=$(mktemp)
OIDC_PROVIDER=$(aws eks describe-cluster --name ${CLUSTER_NAME} --region us-west-1 --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")
export NAMESPACE=keda
export SERVICE_ACCOUNT=keda-service-account
export IAM_KEDA_ROLE="keda-master-role"
export SQS_QUEUE_URL="https://sqs.us-west-1.amazonaws.com/809980971988/keda-queue.fifo"
export SQS_TARGET_DEPLOYMENT="sqs-app"
export SQS_TARGET_NAMESPACE="keda-test"