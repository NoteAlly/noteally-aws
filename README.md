# noteally-aws

This repository contains the scripts used to create the AWS infrastructure for the NoteAlly project. The scripts are written in Terraform. The scripts are divided into folders according to their purpose, for example, the scripts that create the AWS Network are in the network folder.

## How to run

To be able to run the script, or to be able to create a new one based on this template, you need to do the following:

- Clone the project:

```bash
git clone git@github.com:NoteAlly/noteally-aws.git
```

- Install Terraform:

```bash
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
--keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
--fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list


sudo apt update

sudo apt-get install terraform
```

- Inside the project folder, create a file named .env and add the following variables:

```bash
AWS_ACCESS_KEY_ID=<your_aws_access_key_id>
AWS_SECRET_ACCESS_KEY=<your_aws_secret_access_key>
AWS_SESSION_TOKEN=<your_aws_session_token>
AWS_DEFAULT_REGION=<your_region_name>
```

If you are using aws academy sandbox, put us-east-1 as region_name to use the free tier.

If you are not using aws academy, choose a region that is available for you and remove the line AWS_SESSION_TOKEN from the .env file and the token variable from the aws provider in the main.tf file in the root directory.

- Run the following commands:

```bash
terraform init
terraform validate
terraform plan
terraform apply
```
