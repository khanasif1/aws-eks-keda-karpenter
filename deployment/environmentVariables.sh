#!/bin/bash
echo "Setting environment variables"
export KARPENTER_VERSION=v0.20.0 #v0.26.1   
export CLUSTER_NAME="eks-oregon-karp"
export AWS_REGION="us-west-2"
export ACCOUNT_ID="$(aws sts get-caller-identity --query Account --output text)"
export TEMPOUT=$(mktemp)
