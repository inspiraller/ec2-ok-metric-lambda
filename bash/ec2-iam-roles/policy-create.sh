#!/bin/sh

if [[ -z $ECS_INSTANCE_ROLE || -z $REGION ]]; then
   echo "Must provide ECS_INSTANCE_ROLE, REGION"
   exit 1
fi

export accountID=$(aws sts get-caller-identity --query "Account" --output text)
# REGION, accountID
envsubst < ./policy.template.json | sed 's/\r$//' > ./policy.json

role_name="role-${ECS_INSTANCE_ROLE}"
policy_name="policy-${ECS_INSTANCE_ROLE}"


policyId=$(aws iam create-policy \
    --policy-name $policy_name \
    --policy-document file://policy.json \
    --query "Policy.PolicyId")

echo "policy created: $policyId"
