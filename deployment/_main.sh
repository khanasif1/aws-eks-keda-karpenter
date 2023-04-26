#******************
# Chain Deployment
#******************
echo "Cluster!!"
echo "cluster Parameters \n"
echo $CLUSTER_NAME  "|" $KARPENTER_VERSION  "|" $AWS_REGION "|"  $ACCOUNT_ID "|"  $TEMPOUT
./deployment/cluster/createCluster.sh

echo "Karpenter!!"
echo "karpenter Parameters \n"
echo $CLUSTER_NAME "|"  $KARPENTER_VERSION  "|" $AWS_REGION  "|" $ACCOUNT_ID  "|" $TEMPOUT
./deployment/karpenter/createkarpenter.sh


echo "KEDA!!"
echo "keda Parameters"
echo $CLUSTER_NAME "||\n"  $AWS_REGION "||\n"  $ACCOUNT_ID  "||\n" $TEMPOUT  "||\n" $OIDC_PROVIDER  "||\n" $IAM_KEDA_ROLE  "||\n" $SERVICE_ACCOUNT  "||\n" $NAMESPACE  "||\n" $SQS_TARGET_NAMESPACE "||\n"  $SQS_TARGET_DEPLOYMENT "||\n"  $SQS_QUEUE_URL 

./deployment/keda/createkeda.sh

