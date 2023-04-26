#!/bin/bash
#*************************
# Create a Cluster with Karpenter
#************************* 
echo "=========================="
echo "Installing Cluster"
echo "=========================="
source environmentVariables.sh

if [ -z $CLUSTER_NAME ] || [ -z $KARPENTER_VERSION ] || [ -z $AWS_REGION ] || [ -z $ACCOUNT_ID ] || [ -z $TEMPOUT ];then
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

eksctl create cluster --name ${CLUSTER_NAME} --region ${AWS_REGION}
aws eks describe-cluster --region ${AWS_REGION} --name ${CLUSTER_NAME} --query "cluster.status"

fi
# Delete eks cluster
#eksctl delete cluster --name eks-keda-scale --region  us-west-1#
echo "==========================" 
echo "Cluster Completed"
echo "=========================="
fi
