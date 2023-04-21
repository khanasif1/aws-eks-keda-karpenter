#******************
# Chain Deployment
#******************
#./deployment/cluster/createCluster.sh
#./deployment/karpenter/createkarpenter.sh

echo $CLUSTER_NAME "\n"  $AWS_REGION "\n"  $ACCOUNT_ID  "\n" $TEMPOUT  "\n" $OIDC_PROVIDER  "\n" $IAM_KEDA_ROLE  "\n" $SERVICE_ACCOUNT  "\n" $NAMESPACE  "\n" $SQS_TARGET_NAMESPACE "\n"  $SQS_TARGET_DEPLOYMENT "\n"  $SQS_QUEUE_URL 

echo "===Deploy KEDA==="

if [ -z $CLUSTER_NAME ] ||  [ -z $AWS_REGION ] || [ -z $ACCOUNT_ID ] || [ -z $TEMPOUT ] || [ -z $OIDC_PROVIDER ] || [ -z $IAM_KEDA_ROLE ] || [ -z $SERVICE_ACCOUNT ] || [ -z $NAMESPACE ] || [ -z $SQS_TARGET_NAMESPACE ] || [ -z $SQS_TARGET_DEPLOYMENT ] || [ -z $SQS_QUEUE_URL ];then
echo "Run environmentVariables.sh file"
exit 1;
else
echo "Good to go"
#./deployment/keda/createkeda.sh

fi