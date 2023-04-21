#!/bin/bash
#*************************
# Deploy KEDA
#*************************
echo "=========================="
echo "Deploy KEDA"
echo "=========================="

echo "This deployment will target AWS SQS trigger for keda"
 
echo "====Installing keda====="
#Deploy SQS access policy
echo "Deploy SQS access policy"
aws iam create-policy --policy-name keda-awssqs-policy --policy-document file://deployment/keda/sqsPolicy.json

#Deploy Dynamo access policy
# This is needed in context to our sample application, its not a KEDA requirement 
echo "Deploy Dynamo access policy. !!This is needed in context to our sample application, its not a KEDA requirement!!"
aws iam create-policy --policy-name keda-awsdynamo-policy --policy-document file://deployment/keda/dynamoPolicy.json




echo "Create a trusted relation in role for STS"
#Create Role Trusted Relation 
cat >./deployment/keda/trust-relationship.json <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${ACCOUNT_ID}:oidc-provider/${OIDC_PROVIDER}"
      },
      "Action": "sts:AssumeRoleWithWebIdentity",
      "Condition": {
        "StringEquals": {
          "${OIDC_PROVIDER}:aud": "sts.amazonaws.com",
          "${OIDC_PROVIDER}:sub": [
            "system:serviceaccount:keda:keda-operator",
            "system:serviceaccount:${SQS_TARGET_NAMESPACE}:${SERVICE_ACCOUNT}"
          ]
        }
      }
    }
  ]
}
EOF

# Create role for KedaOperator to access SQS for poling and generate STS for operator to connect with AWS resources
echo "Create role for KedaOperator to access SQS for poling and generate STS for operator to connect with AWS resources"
aws iam create-role --role-name ${IAM_KEDA_ROLE}  --assume-role-policy-document file://deployment/keda/trust-relationship.json --description "keda role-description"
echo "Attach SQS polciy to Keda role"
aws iam attach-role-policy --role-name ${IAM_KEDA_ROLE} --policy-arn=arn:aws:iam::${ACCOUNT_ID}:policy/keda-awssqs-policy
echo "Attach dynamo polciy to Keda role"
aws iam attach-role-policy --role-name ${IAM_KEDA_ROLE} --policy-arn=arn:aws:iam::${ACCOUNT_ID}:policy/keda-awsdynamo-policy

aws iam list-attached-role-policies --role-name ${IAM_KEDA_ROLE} --output text

# Add a new  Kubernetes service account and attach keda-role
echo "Create a K8s service account and attach role"
kubectl create namespace keda-test 
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: ${SERVICE_ACCOUNT}
  namespace: keda-test
EOF
echo "Map k8s service account to IAM role"
kubectl annotate serviceaccount -n keda-test keda-service-account eks.amazonaws.com/role-arn=arn:aws:iam::${ACCOUNT_ID}:role/${IAM_KEDA_ROLE}



#Deploy KEDA value
echo "=== Deploy KEDA VALUES ==="
./deployment/keda/values.sh
#Install KEDA with helm 
echo "Install Keda using helm" 
helm repo add kedacore https://kedacore.github.io/charts
helm repo update
kubectl create namespace keda
helm install keda kedacore/keda --values ./deployment/keda/value.yaml --namespace keda

echo "=== Deploy KEDA Scaleobject ==="
./deployment/keda/keda-scaleobject.sh
kubectl apply -f ./deployment/keda/kedaScaleObject.yaml

# deploy the application to read queue
echo "Deploy application to read SQS"
kubectl apply -f ./deployment/app/keda-python-app.yaml

echo "=========================="
echo "KEDA Completed"
echo "=========================="

