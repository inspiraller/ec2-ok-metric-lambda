#!/bin/sh

EC2_INSTANCE_READY="$EC2_INSTANCE_READY"
LOG_STREAM_NAME="$EC2_LOG_STREAM"
REGION="$REGION"
LOG_GROUP_NAME="$project_repo"

# From use-data.template.sh
# expect:  /var/log/on-restart.log
# expect log_stream_name above to exist and have a log

debug() {
  echo ${D}1 >> /var/log/on-restart.log
}
log() {
  message="${D}1"
  debug "${D}message"
  TIMESTAMP=${D}(date +%s000)
  NEXT_SEQUENCE_TOKEN=${D}(aws logs describe-log-streams --log-group-name ${D}LOG_GROUP_NAME --log-stream-name-prefix ${D}LOG_STREAM_NAME --region ${D}REGION --query "logStreams[0].uploadSequenceToken" --output text)
  aws logs put-log-events --log-group-name ${D}LOG_GROUP_NAME --log-stream-name ${D}LOG_STREAM_NAME --log-events timestamp=${D}TIMESTAMP,message="${D}message" --region ${D}REGION --sequence-token ${D}NEXT_SEQUENCE_TOKEN
}


okok() {
  INSTANCE_ID=${D}(curl -s http://169.254.169.254/latest/meta-data/instance-id)
  log "nextjs - Instance ID: ${D}INSTANCE_ID - try okok"

  # Start a background process to monitor instance readiness
  (
    INSTANCE_READY=false
    MAX_RETRIES=8 # 3 minutes
    RETRY_COUNT=0

    while [ "${D}INSTANCE_READY" = false ] && [ "${D}RETRY_COUNT" -lt "${D}MAX_RETRIES" ]; do
      STATUS=${D}(aws ec2 describe-instance-status --instance-ids "${D}INSTANCE_ID" \
      --query "InstanceStatuses[?SystemStatus.Status == 'ok'].InstanceStatus.Status|[0]" \
      --region ${D}REGION \
      --output text)

      if [ "${D}STATUS" == "ok" ]; then
        log "$EC2_INSTANCE_READY. instanceId=${D}INSTANCE_ID"
        INSTANCE_READY=true
      else

        InstanceStatuses=${D}(aws ec2 describe-instance-status --instance-ids "${D}INSTANCE_ID" \
        --region ${D}REGION \
        --output text)
        debug "nextjs - Try: InstanceStatuses: ${D}InstanceStatuses"
        debug "nextjs - Instance not ready. Retry in 20 seconds..."

        sleep 20
        RETRY_COUNT=${D}((RETRY_COUNT + 1))
      fi
    done

    if [ "${D}INSTANCE_READY" = false ]; then
      debug "nextjs - Instance did not reach 'ready' state within the timeout period."
    fi
  )
}

okok &  # Run in the background