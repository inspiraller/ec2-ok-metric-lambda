#!/bin/sh

if [[ -z $LAMBDA_FUNCTION_EC2_OKOK || -z $REGION ]]; then
   echo "Must provide LAMBDA_FUNCTION_EC2_OKOK, REGION"
   exit 1
fi

accountID=$(aws sts get-caller-identity --query "Account" --output text)

alarm_name="metric-alarm-${LAMBDA_FUNCTION_EC2_OKOK}"

# Subscription filter
aws lambda add-permission \
 --function-name $LAMBDA_FUNCTION_EC2_OKOK \
 --statement-id AllowCloudWatchLogsInvoke \
 --action "lambda:InvokeFunction" \
 --principal logs.amazonaws.com \
 --source-arn "arn:aws:logs:${REGION}:${accountID}:log-group:${project_repo}:*"

