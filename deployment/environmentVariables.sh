#!/bin/bash
echo "Setting environment variables"
export KARPENTER_VERSION=v0.20.0 #v0.26.1   
export CLUSTER_NAME="eks-oregon-KK-scale"
export AWS_REGION="us-west-2"
export ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export TEMPOUT=$(mktemp) 
export NAMESPACE=keda
export SERVICE_ACCOUNT=keda-service-account
export IAM_KEDA_ROLE="keda-oregon-role"
export IAM_KEDA_SQS_POLICY="keda-oregon-sqs"
export IAM_KEDA_DYNAMO_POLICY="keda-oregon-dynamo"
export SQS_QUEUE_URL="https://sqs.us-west-2.amazonaws.com/809980971988/keda-queue.fifo"
export SQS_TARGET_DEPLOYMENT="sqs-app"
export SQS_TARGET_NAMESPACE="keda-test"