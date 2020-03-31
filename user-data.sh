#!/bin/bash -xe
mkdir -p ~/.spotinst
cat > ~/.spotinst/credentials << EOF
[default]
account = ${SpotAccountNumber}
token   = ${SpotToken}
EOF

REGION=${AWS::Region}
CLUSTER_NAME=${ClusterName}

cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
yum install -y kubectl

curl -sfL https://spotinst-public.s3.amazonaws.com/integrations/kubernetes/eksctl/eksctl.sh |sh
mv  -f ./bin/eksctl /bin && rm -rf ./bin
PATH=$PATH:/usr/local/bin

eksctl create cluster \
--name $CLUSTER_NAME \
--region $REGION \
--nodes 1 \
--nodes-min 1 \
--nodes-max 10 \
--nodegroup-name $CLUSTER_NAME-spot \
--spot-ocean

aws eks update-kubeconfig --name $CLUSTER_NAME --region $REGION