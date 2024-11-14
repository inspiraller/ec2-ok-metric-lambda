#!/bin/sh

if [[ -z $PROJECT_NAME ]]; then
   echo "Must provide PROJECT_NAME"
   exit 1
fi

groupId=$(aws ec2 describe-security-groups --filters Name=group-name,Values=$PROJECT_NAME \
 --query="SecurityGroups[].GroupId" \
 --output text)

aws ec2 delete-security-group --group-id $groupId
sh _create.sh
