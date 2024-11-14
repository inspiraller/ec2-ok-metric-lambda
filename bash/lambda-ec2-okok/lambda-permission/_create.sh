#!/bin/sh

if [[ -z $LAMBDA_FUNCTION_EC2_OKOK || -z $REGION ]]; then
   echo "Must provide LAMBDA_FUNCTION_EC2_OKOK, REGION"
   exit 1
fi

accountID=$(aws sts get-caller-identity --query "Account" --output text)

alarm_name="metric-alarm-${LAMBDA_FUNCTION_EC2_OKOK}"

aws lambda add-permission \
    --function-name $LAMBDA_FUNCTION_EC2_OKOK \
    --statement-id CloudWatchAlarmInvoke2 \
    --action lambda:InvokeFunction \
    --principal lambda.alarms.cloudwatch.amazonaws.com \
    --source-account $accountID \
    --source-arn "arn:aws:cloudwatch:${REGION}:${accountID}:alarm:*"
