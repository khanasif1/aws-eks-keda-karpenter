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

#Deploy Dynamo access policy
# This is needed in context to our sample application, its not a KEDA requirement 
echo "Deploy Dynamo access policy. !!This is needed in context to our sample application, its not a KEDA requirement!!"
aws iam create-policy --policy-name keda-sqs-policy --policy-document ./dynamoPolicy.yaml


oidc_provider=$(aws eks describe-cluster --name ${CLUSTER_NAME} --region us-west-1 --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

echo "Create a trusted relation in role for STS"
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
          "${oidc_provider}:sub": [
            "system:serviceaccount:keda:keda-operator",
            "system:serviceaccount:${namespace}:${service_account}"
          ]
        }
      }
    }
  ]
}
EOF

# Create role for KedaOperator to access SQS for poling and generate STS for operator to connect with AWS resources
echo "Create role for KedaOperator to access SQS for poling and generate STS for operator to connect with AWS resources"
aws iam create-role --role-name ${IAM_KEDA_ROLE}  --assume-role-policy-document file://trust-relationship1.json --description "keda role-description"
echo "Attach SQS polciy to Keda role"
aws iam attach-role-policy --role-name ${IAM_KEDA_ROLE} --policy-arn=arn:aws:iam::${ACCOUNT_ID}:policy/keda-sqs-policy
echo "Attach dynamo polciy to Keda role"
aws iam attach-role-policy --role-name ${IAM_KEDA_ROLE} --policy-arn=arn:aws:iam::${ACCOUNT_ID}:policy/keda-dynamo-policy

echo "Keda Role details: ${aws iam list-attached-role-policies --role-name keda-role --output text}"

# Add a new  Kubernetes service account and attach keda-role
echo "Create a K8s service account and attach role"

cat > <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${service_account}
  namespace: keda-test
EOF

kubectl annotate serviceaccount -n keda-test keda-service-account eks.amazonaws.com/role-arn=arn:aws:iam::$account_id:role/${IAM_KEDA_ROLE}

echo "=========================="
echo "KEDA Completed"
echo "=========================="
fi