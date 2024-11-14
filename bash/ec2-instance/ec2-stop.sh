#!/bin/sh

if [[ -z $project_repo ]]; then
   echo "Must provide project_repo"
   exit 1
fi

instanceID=$(aws ec2 describe-instances \
 --filters \
   "Name=tag:project,Values=$project_repo" \
   "Name=instance-state-name,Values=pending,running,stopping,stopped" \
 --query "Reservations[*].Instances[*].InstanceId" \
 --output text)

aws ec2 stop-instances --instance-ids $instanceID
