# noteally-aws

This repository contains the scripts used to create the AWS infrastructure for the NoteAlly project. The scripts are written in Python and use the boto3 library to interact with AWS. The classes of each service are divided into folders according to the AWS service they interact with. The scripts are divided according to the AWS service they use, for example to create an database instance, you need to run the script named launch_database.py.

## How to run

To be able to run the script, or to be able to create a new one based on this template, you need to do the following:

- Clone the project:

```bash
git clone git@github.com:NoteAlly/noteally-backend.git
```

- Create a virtual environment and install the requirements:

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

- Inside the project folder, create a file named .env and add the following variables:

```bash
aws_access_key_id=<your_aws_access_key_id>
aws_secret_access_key=<your_aws_secret_access_key>
aws_session_token=<your_aws_session_token>
region_name=<your_region_name>
```

If you are using aws academy sandbox, put us-east-1 as region_name to use the free tier.

- Run the script you want:

```bash
python3 <script-to-run>.py
```
