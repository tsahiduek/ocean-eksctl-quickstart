
STACK_NAME="eksctl-provision"
REGION="us-west-2"
#
DefaultVpcId=$(aws --profile default --region us-west-2 ec2 describe-vpcs --filters 'Name=isDefault,Values=true'|jq -r .Vpcs[0].VpcId)
AccessToken=$SPOTINST_TOKEN
AccountID=$SPOTINST_ACCOUNT
JumpHostImageId=$(aws ec2 describe-images --owners amazon --filters 'Name=name,Values=amzn2-ami-hvm-2.0.????????.?-x86_64-gp2' 'Name=state,Values=available' --query 'reverse(sort_by(Images, &CreationDate))[:1].ImageId' --output text)
JumpHostKeyPair=<key_pair>
JumpHostSubnetId=$(aws ec2 describe-subnets --filters  "Name=vpc-id,Values=$DefaultVpcId" | jq -r .Subnets[0].SubnetId)

echo "Creating CloudFormation Stack" $STACK_NAME

aws cloudformation create-stack \
--stack-name $STACK_NAME \
--region $REGION \
--template-body  file://cf_ocean_eksctl.yaml \
--capabilities CAPABILITY_NAMED_IAM \
--parameters \
ParameterKey="DefaultVpcId",ParameterValue=$DefaultVpcId \
ParameterKey="AccessToken",ParameterValue=$AccessToken \
ParameterKey="AccountID",ParameterValue=$AccountID \
ParameterKey="JumpHostImageId",ParameterValue=$JumpHostImageId \
ParameterKey="JumpHostKeyPair",ParameterValue=$JumpHostKeyPair \
ParameterKey="JumpHostSubnetId",ParameterValue=$JumpHostSubnetId

aws cloudformation wait stack-create-complete --stack-name $STACK_NAME
