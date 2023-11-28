#!/bin/bash
cd /home/ubuntu
yes | sudo apt-get update

# Install Docker
yes | sudo apt-get install docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu

docker pull ghcr.io/noteally/noteally-backend:main

# Run Docker container
docker run -d -p 8000:8000 --name noteally-backend_app \
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
                            ghcr.io/noteally/noteally-backend:main
                            