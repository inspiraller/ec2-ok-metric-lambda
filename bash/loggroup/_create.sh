#!/bin/sh


if [[ -z $PROJECT_NAME || -z $project_repo ]]; then
   echo "Must provide PROJECT_NAME, project_repo, sidecar"
   exit 1
fi


aws logs create-log-group --log-group-name $project_repo --tags Key=project,Value=$PROJECT_NAME
aws logs put-retention-policy --log-group-name $project_repo --retention-in-days 3


