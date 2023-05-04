#!/bin/bash
echo "Setting environment variables"
export KARPENTER_VERSION=v0.20.0 #v0.26.1   
export CLUSTER_NAME="eks-oregon-KK-scale"
export AWS_REGION="us-west-1"
export ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export TEMPOUT=$(mktemp) 
export NAMESPACE=keda
export SERVICE_ACCOUNT=keda-service-account
export IAM_KEDA_ROLE="keda-oregon-role"
export IAM_KEDA_SQS_POLICY="keda-oregon-sqs"
export IAM_KEDA_DYNAMO_POLICY="keda-oregon-dynamo"
export SQS_QUEUE_URL="https://sqs.${AWS_REGION}.amazonaws.com/${ACCOUNT_ID}/keda-queue.fifo"
export SQS_TARGET_DEPLOYMENT="sqs-app"
export SQS_TARGET_NAMESPACE="keda-test"
# echo colour
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
CYAN=$(tput setaf 6)
BLUE=$(tput setaf 4)
NC=$(tput sgr0)
