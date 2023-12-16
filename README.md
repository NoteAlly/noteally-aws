# Build AWS infrastructure

This repository contains the scripts used to create the AWS infrastructure for the NoteAlly project. The scripts are written in Terraform, and some final configurations are made using the Boto3 library for Python.

The infrastructure consists of the following resources:
![Infrastructure Resources](images/aws-network-architecture.png)

## How to run

To be able to build the infrastructure, you need to do the following steps:

### 1. Clone this repository  
```bash
git clone git@github.com:NoteAlly/noteally-aws.git
```

### 2. Install Terraform
https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli


### 3. Install AWS CLI 
https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html


### 4. Setup environment variables
Create a file named .env in the root directory of the project and add the following variables:

```bash
# AWS
AWS_ACCESS_KEY_ID=<your_aws_access_key_id>
AWS_SECRET_ACCESS_KEY=<your_aws_secret_access_key>
AWS_ACCOUNT_ID=<your_aws_account_id>
AWS_DEFAULT_REGION=<your_region_name>
AWS_S3_BUCKET_NAME=<your_s3_bucket_name>

# Github
GITHUB_PAT=<your_github_personal_access_token>
FRONTEND_REPO=NoteAlly/noteally-frontend
FRONTEND_BRANCH=main

# Django
DJANGO_KEY=<your_django_key>

# Postgres
DB_IDENTIFIER=<your_db_identifier>
DB_NAME=<your_db_name>
DB_USERNAME=<your_db_username>
DB_PASSWORD=<your_db_password>
DB_PORT=<your_db_port>
```

### 5. Setup python virtual environment
After setting up the infrastructure using Terraform, there are some configurations that need to be made using the Boto3 library for Python. To do this, you need to create a virtual environment and install the dependencies.

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### 6. Build the infrastructure
On the root directory of the project, run the following command:
    
```bash
./scripts/build.sh
```

### 7. Destroy the infrastructure
On the root directory of the project, run the following command:
    
```bash
./scripts/destroy.sh
```
