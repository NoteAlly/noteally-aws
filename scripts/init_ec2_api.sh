#!/bin/bash
cd /home/ubuntu
yes | sudo apt-get update

# Install and configure AWS CLI
yes | sudo apt install curl unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
yes | sudo ./aws/install
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set default.region ${AWS_REGION_NAME}
aws configure set default.output json

# Install Docker
yes | sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

# Clone repository
git clone "https://github.com/pedro535/django-ec2.git"
cd django-ec2

# Build Image
sudo docker build -t project-image .

# Run Docker container
sudo docker run -d -p 8000:8000 --name project-container \
                            -e DJANGO_KEY=${DJANGO_KEY} \
                            -e AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID} \
                            -e AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY} \
                            -e AWS_REGION_NAME=${AWS_REGION_NAME} \
                            -e AWS_S3_BUCKET_NAME=${AWS_S3_BUCKET_NAME} \
                            -e AWS_COGNITO_DOMAIN=${AWS_COGNITO_DOMAIN} \
                            -e DB_NAME=${DB_NAME} \
                            -e DB_USERNAME=${DB_USERNAME} \
                            -e DB_PASSWORD=${DB_PASSWORD} \
                            -e DB_PORT=${DB_PORT} \
                            -e DB_HOST=${DB_HOST} \
                            --log-driver awslogs \
                            --log-opt awslogs-region=${AWS_REGION_NAME} \
                            --log-opt awslogs-group=${AWS_LOG_GROUP_NAME} \
                            project-image
