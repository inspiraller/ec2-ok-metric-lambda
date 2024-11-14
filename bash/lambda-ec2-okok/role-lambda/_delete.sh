#!/bin/sh

if [[ -z $LAMBDA_FUNCTION_EC2_OKOK || -z $REGION ]]; then
   echo "Must provide LAMBDA_FUNCTION_EC2_OKOK, REGION"
   exit 1
fi

accountID=$(aws sts get-caller-identity --query "Account" --output text)

role_name="role-${LAMBDA_FUNCTION_EC2_OKOK}"
policy_name="policy-${LAMBDA_FUNCTION_EC2_OKOK}"
policy_arn="arn:aws:iam::${accountID}:policy/${policy_name}"

aws iam detach-role-policy \
    --policy-arn $policy_arn \
    --role-name $role_name

aws iam detach-role-policy \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole \
    --role-name $role_name

aws iam delete-policy --policy-arn $policy_arn


aws iam remove-role-from-instance-profile --instance-profile-name $role_name --role-name $role_name
aws iam delete-instance-profile --instance-profile-name $role_name
aws iam delete-role --role-name $role_name

echo "Polices detached, deleted, then instance profile removed and role deleted!"