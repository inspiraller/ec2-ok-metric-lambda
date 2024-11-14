#!/bin/sh

if [[ -z $PROJECT_NAME || -z $REGION || -z $ECS_INSTANCE_ROLE || -z $project_repo || -z $DOCKER_VOLUME_PATH || -z $EC2_INSTANCE_READY || -z $EC2_LOG_STREAM ]]; then
   echo "Must provide PROJECT_NAME, REGION,  ECS_INSTANCE_ROLE, KEYPAIR, project_repo, DOCKER_VOLUME_PATH, EC2_INSTANCE_READY, EC2_LOG_STREAM"
   exit 1
fi

amiID=$(aws ssm get-parameter --name ' /aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id' --query="Parameter.Value" --output text)
vpcID=$(aws ec2 describe-vpcs --query="Vpcs[].VpcId" --output text)

zone="${REGION}a"
subnetID=$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$vpcID" --query="Subnets[?AvailabilityZone=='${zone}']|[0].SubnetId" --output text)

securityGroupID=$(aws ec2 describe-security-groups --query="SecurityGroups[?GroupName=='$PROJECT_NAME']|[0].GroupId" --output text)
# echo "ECS_INSTANCE_ROLE=$ECS_INSTANCE_ROLE,  project_name=${PROJECT_NAME}, vpcID=${vpcID}, subnetID=${subnetID}, securityGroupID=${securityGroupID}, project_repo=$project_repo"

envsubst < ./scripts/on-restart.template.sh | sed 's/\r$//' > ./scripts/on-restart.sh

export BASE64_ENCODED_SCRIPT=$(base64 -w 0 scripts/on-restart.sh)
envsubst < ./user-data.template.sh | sed 's/\r$//' > ./user-data.txt


role_name="role-${ECS_INSTANCE_ROLE}"

instanceID=$(aws ec2 run-instances \
  --image-id $amiID \
  --count 1 \
  --instance-type t2.micro \
  --iam-instance-profile Name=$role_name \
  --key-name $PROJECT_NAME \
  --security-group-ids $securityGroupID \
  --subnet-id $subnetID \
  --user-data file://user-data.txt \
  --tag-specifications "ResourceType=instance,Tags=[{Key=project,Value='${project_repo}'},{Key=Name,Value='${project_repo}'}]" \
  --query="Instances[].InstanceId" \
  --output text)

echo "Instance created=$instanceID"

