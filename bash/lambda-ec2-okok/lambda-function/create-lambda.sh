#!/bin/sh

if [[ -z $LAMBDA_FUNCTION_EC2_OKOK || -z $REGION ]]; then
   echo "Must provide LAMBDA_FUNCTION_EC2_OKOK, REGION"
   exit 1
fi

role_name="role-${LAMBDA_FUNCTION_EC2_OKOK}"

accountID=$(aws sts get-caller-identity --query "Account" --output text)
roleArn="arn:aws:iam::${accountID}:role/${role_name}"

functionArn=$(aws lambda create-function \
 --function-name $LAMBDA_FUNCTION_EC2_OKOK \
 --zip-file fileb://typescript/lambda-function.zip \
 --handler "index.handler" \
 --runtime nodejs18.x \
 --role $roleArn \
 --environment "Variables={project_repo=\"$project_repo\",REGION=\"$REGION\",LAMBDA_FUNCTION_EC2_OKOK=\"$LAMBDA_FUNCTION_EC2_OKOK\"}" \
 --query "FunctionArn")

echo "created lambda=${functionArn}"


