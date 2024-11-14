#!/bin/sh

if [[ -z $PROJECT_NAME ]]; then
   echo "Must provide PROJECT_NAME"
   exit 1
fi

export vpcID=$(aws ec2 describe-vpcs  --query='Vpcs[].VpcId' --output text)

# Inbound
export securityGroupID=$(aws ec2 create-security-group --group-name $PROJECT_NAME \
 --description "Security group for docker" \
 --vpc-id $vpcID  \
 --tag-specifications "ResourceType=security-group,Tags=[{Key=project,Value=$PROJECT_NAME}]" \
 --query="GroupId" \
 --output text
)

echo "securityGroupId= $securityGroupID"
myip=$(curl ifcfg.me)
## ssh from local ip
securityGroupRuleId=$(aws ec2 authorize-security-group-ingress \
    --group-id $securityGroupID \
    --protocol tcp \
    --port 22 \
    --cidr "${myip}/32" \
    --query="SecurityGroupRules[].SecurityGroupRuleId" \
    --output text
)

echo "Create Security Group $PROJECT_NAME as id $securityGroupId with Rule $securityGroupRuleId"