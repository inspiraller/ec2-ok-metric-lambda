#!/bin/sh

if [[ -z $ECS_INSTANCE_ROLE || -z $PROJECT_NAME || -z $REGION ]]; then
   echo "Must provide ECS_INSTANCE_ROLE, PROJECT_NAME, REGION"
   exit 1
fi

role_name="role-${ECS_INSTANCE_ROLE}"
policy_name="policy-${ECS_INSTANCE_ROLE}"

accountID=$(aws sts get-caller-identity --query "Account" --output text)

createdRoleARN=$(aws iam create-role \
    --role-name $role_name \
    --tags Key=project,Value=$PROJECT_NAME \
    --assume-role-policy-document file://trust-ec2.json \
    --query="Role.Arn" \
     --output text
)

roleProfile=$(aws iam create-instance-profile --instance-profile-name $role_name --tags Key=project,Value=$PROJECT_NAME)
echo "roleProfile=$roleProfile"


aws iam add-role-to-instance-profile \
    --instance-profile-name $role_name \
    --role-name $role_name


sh policy-create.sh

aws iam attach-role-policy \
    --policy-arn "arn:aws:iam::${accountID}:policy/${policy_name}" \
    --role-name $role_name

echo "Create role $role_name, instance profile $role_name, policy  $policy_name, and attached policies to role"
