This repo contains CF template to create a jumphost which will create through User data - EKS cluster + Ocean, through eksctl version by Spot

In order to run the CF:

1. Replace all `<AWS_ACCOUNT>` to your actual AWS account number in `cf_ocean_eksctl.yaml`.
2. Replace all `<spotinst_token>` to your actual Spot token number in `eks_policy.json`.
3. Replace all `<spotinst_account>` to your actual Spot account number in `eks_policy.json`.
4. Run the `cf_run.sh` script
