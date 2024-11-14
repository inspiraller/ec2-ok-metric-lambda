#!/bin/sh

if [[ -z $project_repo || -z $EC2_INSTANCE_READY ]]; then
   echo "Must provide project_repo, EC2_INSTANCE_READY"
   exit 1
fi

metric_filter="metric-filter-$LAMBDA_FUNCTION_EC2_OKOK"
metric_name="metric-name-$LAMBDA_FUNCTION_EC2_OKOK"
metric_namespace="metric-namespace-$LAMBDA_FUNCTION_EC2_OKOK"
alarm_name="metric-alarm-$LAMBDA_FUNCTION_EC2_OKOK"

lambda_function_arn=$(aws lambda get-function --function-name $LAMBDA_FUNCTION_EC2_OKOK --query 'Configuration.FunctionArn' --output text)

#--filter-pattern "[timestamp, message = /.*$EC2_INSTANCE_READY.*/]" \

aws logs put-metric-filter \
  --log-group-name $project_repo \
  --filter-name $metric_filter \
  --filter-pattern "\"$EC2_INSTANCE_READY\"" \
  --metric-transformations "metricName=${metric_name},metricNamespace=${metric_namespace},metricValue=1" \

aws cloudwatch put-metric-alarm \
  --alarm-name $alarm_name \
  --alarm-description "Alert when \"$EC2_INSTANCE_READY\" appears in logs" \
  --metric-name $metric_name \
  --namespace $metric_namespace \
  --statistic "Sum" \
  --period 60 \
  --threshold 1 \
  --comparison-operator "GreaterThanOrEqualToThreshold" \
  --evaluation-periods 1 \
  --alarm-actions "$lambda_function_arn"

# accountID=$(aws sts get-caller-identity --query "Account" --output text)
# "arn:aws:lambda:eu-west-2:${accountID}:function:${$LAMBDA_FUNCTION_EC2_OKOK}"

# Reset alarm to monitor new log events only
aws cloudwatch set-alarm-state \
  --alarm-name "$alarm_name" \
  --state-value OK \
  --state-reason "Resetting alarm to monitor new log events only"



# Reverse
 # --treat-missing-data missing