#******************
# Chain Deployment
#******************
 source ./deployment/environmentVariables.sh

# echo "Cluster!!"
# echo "print cluster Parameters \n"
# echo $CLUSTER_NAME  "|" $KARPENTER_VERSION  "|" $AWS_REGION "|"  $ACCOUNT_ID "|"  $TEMPOUT
# ./deployment/cluster/createCluster.sh

# echo "Karpenter!!"
# echo "print karpenter Parameters \n"
# echo $CLUSTER_NAME "|"  $KARPENTER_VERSION  "|" $AWS_REGION  "|" $ACCOUNT_ID  "|" $TEMPOUT
# ./deployment/karpenter/createkarpenter.sh


echo "KEDA!!"
echo "print keda Parameters"
echo $CLUSTER_NAME "||\n"  $AWS_REGION "||\n"  $ACCOUNT_ID  "||\n" $TEMPOUT  "||\n"  $IAM_KEDA_ROLE  "||\n" $IAM_KEDA_SQS_POLICY  "||\n" $SERVICE_ACCOUNT  "||\n" $NAMESPACE  "||\n" $SQS_TARGET_NAMESPACE "||\n"  $SQS_TARGET_DEPLOYMENT "||\n"  $SQS_QUEUE_URL 

./deployment/keda/createkeda.sh

