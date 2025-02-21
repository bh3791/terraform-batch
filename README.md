# Configuration for AWS Batch - Fargate

This repo contains terraform configuration for AWS Batch Fargate. It sets up all the AWS requirements to run jobs under fargate. It can be complicated to set up the AWS topology. This has proven to be a useful way to set up and tear down different AWS environments. 

## Install the tools
1. install the AWS CLI
    - https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
    - mac: `brew install awscli`
    - win: `choco install awscli`
2. install terraform
    - https://www.terraform.io/downloads.html
    - mac: `brew install terraform`
    - win: `choco install terraform`

## Configuring
1. run the `aws configure` command to set up your security credentials. You will need to generate these in
the AWS console https://console.aws.amazon.com/iamv2/home#/users : user : security credentials : access keys
2. edit the `terraform.tfvars` file, naming the deployment as you please'.
The project is initially configured to work out of the box in the us-west-1 region.
To modify it for another region, networking.tf would need to be edited to apply the correct availability zones and subnets.

        cd aws
        terraform init
        terraform plan
        terraform apply
