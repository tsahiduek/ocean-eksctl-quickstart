This repo contains CF template to create a jumphost which will create through User data - EKS cluster + Ocean, through eksctl version by Spot

In order to run the CF:

1. Inside `cf_run.sh`, replace `JumpHostKeyPair` and `EksMasterUserArn` with your own KeyPair and user ARN to be added as a user that can be authenticated with the created EKS cluster
2. Run the `cf_run.sh` script
