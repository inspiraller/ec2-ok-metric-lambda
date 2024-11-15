#!/bin/sh

if [[ -z $PROJECT_NAME || -z $project_repo || -z $REGION || -z $EC2_INSTANCE_READY || -z $LAMBDA_FUNCTION_EC2_OKOK  ]]; then
   echo "Must provide PROJECT_NAME, project_repo, REGION, EC2_INSTANCE_READY, LAMBDA_FUNCTION_EC2_OKOK "
   exit 1
fi

FunctionArn=$(aws lambda get-function --function-name $LAMBDA_FUNCTION_EC2_OKOK --query 'Configuration.FunctionArn' --output text)

aws logs put-subscription-filter \
 --log-group-name $project_repo \
  --filter-name "Ec2Okok" \
  --filter-pattern "\"$EC2_INSTANCE_READY\"" \
  --destination-arn $FunctionArn \
  --distribution 'Random'

