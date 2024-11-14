#!/bin/sh

if [[ -z $ECS_INSTANCE_ROLE || -z $REGION ]]; then
   echo "Must provide ECS_INSTANCE_ROLE, REGION"
   exit 1
fi

accountID=$(aws sts get-caller-identity --query "Account" --output text)

role_name="role-${ECS_INSTANCE_ROLE}"
policy_name="policy-${ECS_INSTANCE_ROLE}"

policy_arn="arn:aws:iam::${accountID}:policy/${policy_name}"

aws iam detach-role-policy \
    --policy-arn $policy_arn \
    --role-name $role_name

# aws iam detach-role-policy \
#     --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole \
#     --role-name $role_name

aws iam delete-policy --policy-arn $policy_arn


aws iam remove-role-from-instance-profile --instance-profile-name $role_name --role-name $role_name
aws iam delete-instance-profile --instance-profile-name $role_name
aws iam delete-role --role-name $role_name

echo "Polices detached, deleted, then instance profile removed and role deleted!"