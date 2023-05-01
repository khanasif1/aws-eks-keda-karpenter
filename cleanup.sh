#******************
# Clean Deployment
#******************
echo "Load variables"
source ./deployment/environmentVariables.sh


# aws cloudformation describe-stacks --no-paginate --region us-west-2 --output text --query 'Stacks[?StackName!=`null`]|[?contains(StackName, `'$CLUSTER_NAME'`) == `true`].StackName'


# stack=$(aws cloudformation describe-stacks --no-paginate --region us-west-2 --output text --query \
#   'Stacks[?StackName!=`null`]|[?contains(StackName, `'${CLUSTER_NAME}'`) == `true`].StackName')
#
echo "Find all CFN stack names which has cluster name"
for stack in $(aws cloudformation describe-stacks  --region ${AWS_REGION} --output text --query 'Stacks[?StackName!=`null`]|[?contains(StackName, `'${CLUSTER_NAME}'`) == `true`].StackName')
do 
echo "Deleting stacks : ${stack}"
aws cloudformation wait stack-delete-complete  --region ${AWS_REGION}  --stack-name $stack
done

# Delete IAM Roles


for policy in $(aws iam list-attached-role-policies --role-name ${IAM_KEDA_ROLE} --output text --query 'AttachedPolicies[*].PolicyName')
do
echo "Detach policy :${policy} from role :${IAM_KEDA_ROLE}"
aws iam detach-role-policy --role-name ${IAM_KEDA_ROLE} --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/${policy}

echo "Deleting policy :${policy}"
aws iam delete-policy --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/${policy}
done

echo "Deleting role : ${IAM_KEDA_ROLE}"
aws iam delete-role --role-name ${IAM_KEDA_ROLE}

# Delete IAM policies

# echo "Deleting policy : ${IAM_KEDA_SQS_POLICY}"
# aws iam delete-policy --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/${IAM_KEDA_SQS_POLICY}
# echo "Deleting policy : ${IAM_KEDA_DYNAMO_POLICY}"
# aws iam delete-policy --policy-arn arn:aws:iam::${ACCOUNT_ID}:policy/${IAM_KEDA_DYNAMO_POLICY}





lkhar@