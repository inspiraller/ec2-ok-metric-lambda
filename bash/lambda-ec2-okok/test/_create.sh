#!/bin/sh

if [[ -z $project_repo || -z $REGION || -z $EC2_LOG_STREAM || -z $EC2_INSTANCE_READY || -z $LAMBDA_FUNCTION_EC2_OKOK ]]; then
   echo "Must provide project_repo, EC2_LOG_STREAM, EC2_INSTANCE_READY, LAMBDA_FUNCTION_EC2_OKOK"
   exit 1
fi

TIMESTAMP=$(date +%s000)
message="$EC2_INSTANCE_READY"
NEXT_SEQUENCE_TOKEN=$(aws logs describe-log-streams --log-group-name $project_repo --log-stream-name-prefix $EC2_LOG_STREAM --region $REGION --query "logStreams[0].uploadSequenceToken" --output text)

aws logs put-log-events \
 --log-group-name $project_repo \
 --log-stream-name $EC2_LOG_STREAM \
 --log-events "[{\"timestamp\": $TIMESTAMP, \"message\": \"$message\"}]" \
 --region $REGION \
 --sequence-token $NEXT_SEQUENCE_TOKEN


# Force test alarm
# alarm_name="metric-alarm-$LAMBDA_FUNCTION_EC2_OKOK"

# aws cloudwatch set-alarm-state \
#     --alarm-name $alarm_name \
#     --state-value ALARM \
#     --state-reason "Testing alarm"

