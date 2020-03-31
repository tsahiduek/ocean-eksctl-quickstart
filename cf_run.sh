# Inputs
JumpHostKeyPair="KEY_PAIR_NAME_FOR_INSTANCE"
EksMasterUserArn="USER_ARN_FOR_AUTH_TO_EKS" # arn of the user to add as a system::master in the aws-auth ConfigMap

#
STACK_NAME="eksctl-provision"
REGION="us-west-2"
CLUSTER_NAME="eksctl-ocean-poc"
#
SpotAccountNumber=$SPOT_ACCOUNT
SpotToken=$SPOT_TOKEN
#
DefaultVpcId=$(aws --profile default --region $REGION ec2 describe-vpcs --filters 'Name=isDefault,Values=true'|jq -r .Vpcs[0].VpcId)
JumpHostImageId=$(aws ec2 describe-images --owners amazon --filters 'Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text)
JumpHostSubnetId=$(aws ec2 describe-subnets --filters  "Name=vpc-id,Values=$DefaultVpcId" | jq -r .Subnets[0].SubnetId)
#
echo "Creating CloudFormation Stack $STACK_NAME in region $REGION with cluster_name $CLUSTER_NAME"

aws cloudformation create-stack \
--stack-name $STACK_NAME \
--region $REGION \
--template-body  file://cf_ocean_eksctl.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters \
ParameterKey="DefaultVpcId",ParameterValue=$DefaultVpcId \
ParameterKey="SpotAccountNumber",ParameterValue=$SpotAccountNumber \
ParameterKey="SpotToken",ParameterValue=$SpotToken \
ParameterKey="JumpHostImageId",ParameterValue=$JumpHostImageId \
ParameterKey="JumpHostKeyPair",ParameterValue=$JumpHostKeyPair \
ParameterKey="JumpHostSubnetId",ParameterValue=$JumpHostSubnetId \
ParameterKey="ClusterName",ParameterValue=$CLUSTER_NAME \
ParameterKey="EksMasterUserArn",ParameterValue=$EksMasterUserArn

aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
