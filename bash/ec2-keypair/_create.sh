#!/bin/sh

if [[ -z $PROJECT_NAME ]]; then
   echo "Must provide  PROJECT_NAME"
   exit 1
fi


aws ec2 create-key-pair --key-name $PROJECT_NAME --query="KeyMaterial" --output text > $PROJECT_NAME.pem
chmod 400 $PROJECT_NAME.pem

# Example connect: ssh -i "${PROJECT_NAME}.pem" ec2-user@ec2-35-176-210-255.eu-west-2.compute.amazonaws.com