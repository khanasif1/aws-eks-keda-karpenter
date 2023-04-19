#!/bin/bash
echo "Setting environment variables"
export KARPENTER_VERSION=v0.26.1   
export CLUSTER_NAME="eks-scale"
export AWS_DEFAULT_REGION="us-west-1"
export AWS_ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export TEMPOUT=$(mktemp)
