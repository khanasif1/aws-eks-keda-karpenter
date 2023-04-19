#!/bin/bash
#*************************
# Create a Cluster with Karpenter
#************************* 
source environmentVariables.sh
echo $CLUSTER_NAME $KARPENTER_VERSION $AWS_DEFAULT_REGION $AWS_ACCOUNT_ID $TEMPOUT

if [ -z $CLUSTER_NAME ] || [ -z $KARPENTER_VERSION ] || [ -z $KARPENTER_VERSION ] || [ -z $AWS_ACCOUNT_ID ] || [ -z $TEMPOUT ];then
echo "Run environmentVariables.sh file"
exit 1;
else 
echo "**Start cluster provisioning**"

CHECK_CLUSTER=$(aws eks list-clusters | jq -r ".clusters" | grep $CLUSTER_NAME || true)
if [ ! -z $CHECK_CLUSTER ];then
echo "Cluster Exists"
else
echo "Cluster does not exists"
echo "create a eks cluster"
eksctl create cluster --name $CLUSTER_NAME --region $AWS_DEFAULT_REGION
aws eks describe-cluster --region $AWS_DEFAULT_REGION --name $CLUSTER_NAME --query "cluster.status"

fi
# Delete eks cluster
#eksctl delete cluster --name eks-keda-scale --region  us-west-1#
  
echo "Completed"
fi
