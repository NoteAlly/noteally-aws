#!/bin/bash
cd /home/ubuntu
yes | sudo apt-get update
yes | sudo apt install python3.10-venv
git clone https://github.com/pedro535/django-ec2.git
cd django-ec2
touch .env
echo "DJANGO_KEY=${DJANGO_KEY}" >> .env
echo "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >> .env
echo "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" >> .env
echo "AWS_STORAGE_BUCKET_NAME=${AWS_STORAGE_BUCKET_NAME}" >> .env
echo "AWS_DEFAULT_ACL=${AWS_DEFAULT_ACL}" >> .env
python3 -m venv venv
source venv/bin/activate
yes | pip install -r requirements.txt
chown ubuntu .
python3 manage.py makemigrations
python3 manage.py migrate --run-syncdb
python3 manage.py runserver 0.0.0.0:8000