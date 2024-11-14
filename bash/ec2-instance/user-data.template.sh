#!/bin/bash

REGION="$REGION"
LOG_GROUP_NAME="$project_repo"
LOG_STREAM_NAME="$EC2_LOG_STREAM"

FIRST_BOOT_PATH="/var/lib"
FIRST_BOOT_FILE="${D}{FIRST_BOOT_PATH}/first-boot"

restart_script="/home/ec2-user/on-restart.sh"

handle_restart() {
# Note: this runs on start and restart
cat <<EOF > /etc/systemd/system/on-restart.service
[Unit]
Description=Run script on every boot
After=network.target

[Service]
Type=oneshot
ExecStart=${D}restart_script
RemainAfterExit=true

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable on-restart.service
sudo systemctl start on-restart.service
}


create_stream() {
  STREAM_EXISTS=$(aws logs describe-log-streams --log-group-name ${D}LOG_GROUP_NAME --log-stream-name-prefix ${D}LOG_STREAM_NAME --region ${D}REGION --query "logStreams[0].logStreamName" --output text)
  if [ "${D}STREAM_EXISTS" == "None" ]; then
    echo "Log stream does not exist. Creating new log stream."
    aws logs create-log-stream --log-group-name ${D}LOG_GROUP_NAME --log-stream-name ${D}LOG_STREAM_NAME --region ${D}REGION
    TIMESTAMP=${D}(date +%s000)
    aws logs put-log-events --log-group-name ${D}LOG_GROUP_NAME --log-stream-name ${D}LOG_STREAM_NAME --log-events timestamp=${D}TIMESTAMP,message="start log" --region ${D}REGION
  fi
}

firstboot() {

  yum update -y
  yum install -y jq aws-cli curl
  echo ECS_CLUSTER="${project_repo}" >> /etc/ecs/ecs.config

  mkdir -p /${DOCKER_VOLUME_PATH}
  chmod 755 /${DOCKER_VOLUME_PATH}

  # BASE64_ENCODED_SCRIPT: this gets replaced on creation of user-data.txt
  BASE64_ENCODED_SCRIPT="$BASE64_ENCODED_SCRIPT"
  echo ${D}BASE64_ENCODED_SCRIPT | base64 --decode > ${D}restart_script
  chmod +x ${D}restart_script

  mkdir -p ${D}FIRST_BOOT_PATH
  touch ${D}FIRST_BOOT_FILE
  echo "nextjs - first boot"

  touch /var/log/on-restart.log
  chmod 755 /var/log/on-restart.log
  create_stream

  handle_restart

}

if [ ! -f "${D}FIRST_BOOT_FILE" ]; then
  firstboot
fi 

echo "nextjs - User data script has completed."