#!/bin/bash
echo "Setting environment variables"
export KARPENTER_VERSION=v0.20.0 #v0.26.1   
export CLUSTER_NAME="eks-demo-scale"
export AWS_REGION="us-west-1"
export ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export TEMPOUT=$(mktemp)
export namespace=keda
export service_account=keda-service-account
export IAM_KEDA_ROLE="keda-role"