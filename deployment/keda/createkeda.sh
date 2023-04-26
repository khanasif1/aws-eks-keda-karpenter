#!/bin/bash
#*************************
# Deploy KEDA
#*************************
echo "=========================="
echo "Deploy KEDA"
echo "=========================="
source ./deployment/environmentVariables.sh
OIDC_PROVIDER=$(aws eks describe-cluster --name ${CLUSTER_NAME} --region ${AWS_REGION} --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")

echo "This deployment will target AWS SQS trigger for keda"

if [ -z $CLUSTER_NAME ] ||  [ -z $AWS_REGION ] || [ -z $IAM_KEDA_SQS_POLICY ] || [ -z $IAM_KEDA_DYNAMO_POLICY ] || [ -z $ACCOUNT_ID ] || [ -z $TEMPOUT ] || [ -z $OIDC_PROVIDER ] || [ -z $IAM_KEDA_ROLE ] || [ -z $SERVICE_ACCOUNT ] || [ -z $NAMESPACE ] || [ -z $SQS_TARGET_NAMESPACE ] || [ -z $SQS_TARGET_DEPLOYMENT ] || [ -z $SQS_QUEUE_URL ];then
echo "Run environmentVariables.sh file"
exit 1;
else

echo "====Installing keda====="
#Deploy SQS access policy
echo "Deploy SQS access policy"
SQS_POLICY=$(aws iam create-policy --policy-name ${IAM_KEDA_SQS_POLICY} --policy-document file://deployment/keda/sqsPolicy.json --output text --query Policy.Arn)
echo "ARN : ${SQS_POLICY}"
#Deploy Dynamo access policy
# This is needed in context to our sample application, its not a KEDA requirement 
echo "Deploy Dynamo access policy. !!This is needed in context to our sample application, its not a KEDA requirement!!"
DYNAMO_POLICY=$(aws iam create-policy --policy-name ${IAM_KEDA_DYNAMO_POLICY} --policy-document file://deployment/keda/dynamoPolicy.json  --output text --query Policy.Arn)
echo "ARN : ${DYNAMO_POLICY}"



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
aws iam attach-role-policy --role-name ${IAM_KEDA_ROLE} --policy-arn=arn:aws:iam::${ACCOUNT_ID}:policy/${IAM_KEDA_SQS_POLICY}
echo "Attach dynamo polciy to Keda role"
aws iam attach-role-policy --role-name ${IAM_KEDA_ROLE} --policy-arn=arn:aws:iam::${ACCOUNT_ID}:policy/${IAM_KEDA_DYNAMO_POLICY}

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

fi