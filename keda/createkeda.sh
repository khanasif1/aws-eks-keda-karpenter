#!/bin/bash
#*************************
# Deploy KEDA
#*************************
echo "=========================="
echo "Deploy KEDA"
echo "=========================="

echo "This deployment will target AWS SQS trigger for keda"

echo $CLUSTER_NAME  $AWS_REGION $ACCOUNT_ID $TEMPOUT

if [ -z $CLUSTER_NAME ] ||  [ -z $AWS_REGION ] || [ -z $ACCOUNT_ID ] || [ -z $TEMPOUT ];then
echo "Run environmentVariables.sh file"
exit 1;
else 
echo "**Installing karpenter**"
#Deploy SQS access policy
echo "Deploy SQS access policy"
aws iam create-policy --policy-name keda-sqs-policy --policy-document ./sqsPolicy.yaml

oidc_provider=$(aws eks describe-cluster --name ${CLUSTER_NAME} --region us-west-1 --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")
export namespace=keda
export service_account=keda-service-account

#Create Role Trusted Relation 
cat >trust-relationship.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${oidc_provider}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${oidc_provider}:aud": "sts.amazonaws.com",
          "${oidc_provider}:sub": "system:serviceaccount:${namespace}:${service_account}"
        }
      }
    }
  ]
}
EOF

echo "=========================="
echo "KEDA Completed"
echo "=========================="
fi