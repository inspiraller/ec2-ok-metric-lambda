#!/bin/sh

if [[ -z $LAMBDA_FUNCTION_EC2_OKOK ]]; then
   echo "Must provide LAMBDA_FUNCTION_EC2_OKOK"
   exit 1
fi

alarm_name="metric-alarm-${LAMBDA_FUNCTION_EC2_OKOK}"

aws lambda remove-permission \
    --function-name  $LAMBDA_FUNCTION_EC2_OKOK \
    --statement-id CloudWatchAlarmInvoke2

aws cloudwatch set-alarm-state \
  --alarm-name "$alarm_name" \
  --state-value OK \
  --state-reason "Resetting if updating lambda add permission"

sh _create.sh