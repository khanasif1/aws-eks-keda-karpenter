#!/bin/bash
#*************************
# Deploy Karpenter
#************************* 
source environmentVariables.sh
echo $CLUSTER_NAME $KARPENTER_VERSION $AWS_DEFAULT_REGION $AWS_ACCOUNT_ID $TEMPOUT

if [ -z $CLUSTER_NAME ] || [ -z $KARPENTER_VERSION ] || [ -z $KARPENTER_VERSION ] || [ -z $AWS_ACCOUNT_ID ] || [ -z $TEMPOUT ];then
echo "Run environmentVariables.sh file"
exit 1;
else 
echo "**Installing karpenter**"

#Create the KarpenterNode IAM Role
echo "Create the KarpenterNode IAM Role"

  curl -fsSL https://karpenter.sh/"${KARPENTER_VERSION}"/getting-started/getting-started-with-eksctl/cloudformation.yaml  > $TEMPOUT \
  && aws cloudformation deploy \
    --stack-name "Karpenter-${CLUSTER_NAME}" \
    --template-file "${TEMPOUT}" \
    --capabilities CAPABILITY_NAMED_IAM \
    --parameter-overrides "ClusterName=${CLUSTER_NAME}"

#grant access to instances using the profile to connect to the cluster. This command adds the Karpenter node role to your aws-auth configmap, allowing nodes with this role to connect to the cluster.

eksctl create iamidentitymapping \
  --username system:node:{{EC2PrivateDNSName}} \
  --cluster  ${CLUSTER_NAME} \
  --arn "arn:aws:iam::${AWS_ACCOUNT_ID}:role/KarpenterNodeRole-${CLUSTER_NAME}" \
  --group system:bootstrappers \
  --group system:nodes

echo "Verify auth Map"
kubectl describe configmap -n kube-system aws-auth

# Create KarpenterController IAM Role
echo "Create KarpenterController IAM Role"

eksctl utils associate-iam-oidc-provider --cluster ${CLUSTER_NAME} --approve

#Karpenter requires permissions like launching instances. This will create an AWS IAM Role, Kubernetes service account, 
#and associate them using IAM Roles for Service Accounts (IRSA)
echo "Map AWS IAM Role  Kubernetes service account"

eksctl create iamserviceaccount \
  --cluster "${CLUSTER_NAME}" --name karpenter --namespace karpenter \
  --role-name "Karpenter-${CLUSTER_NAME}" \
  --attach-policy-arn "arn:aws:iam::${AWS_ACCOUNT_ID}:policy/KarpenterControllerPolicy-${CLUSTER_NAME}" \
  --role-only \
  --approve

export KARPENTER_IAM_ROLE_ARN="arn:aws:iam::${AWS_ACCOUNT_ID}:role/karpenter-${CLUSTER_NAME}"

#Create the EC2 Spot Linked Role
echo "Create the EC2 Spot Linked Role"
aws iam create-service-linked-role --aws-service-name spot.amazonaws.com 2> /dev/null || echo 'Already exist'

#Install Karpenter
echo "Install Karpenter"
export CLUSTER_ENDPOINT="$(aws eks describe-cluster --name ${CLUSTER_NAME} --query "cluster.endpoint" --output text)"
helm upgrade --install --namespace karpenter --create-namespace \
  karpenter oci://public.ecr.aws/karpenter/karpenter \
  --version ${KARPENTER_VERSION} \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${KARPENTER_IAM_ROLE_ARN} \
  --set settings.aws.clusterName=${CLUSTER_NAME} \
  --set settings.aws.clusterEndpoint=${CLUSTER_ENDPOINT} \
  --set defaultProvisioner.create=false \
  --set settings.aws.defaultInstanceProfile=KarpenterNodeInstanceProfile-${CLUSTER_NAME} \
  --set settings.aws.interruptionQueueName=${CLUSTER_NAME} \
  --wait

echo "Completed"
fi
