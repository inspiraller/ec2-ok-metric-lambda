#!/bin/sh

if [[ -z $LAMBDA_FUNCTION_EC2_OKOK || -z $REGION ]]; then
   echo "Must provide LAMBDA_FUNCTION_EC2_OKOK, REGION"
   exit 1
fi

export accountID=$(aws sts get-caller-identity --query "Account" --output text)
# REGION, accountID
envsubst < ./policy.template.json | sed 's/\r$//' > ./policy.json

policy_name="policy-${LAMBDA_FUNCTION_EC2_OKOK}"

policyId=$(aws iam create-policy \
    --policy-name $policy_name \
    --policy-document file://policy.json \
    --query "Policy.PolicyId")

echo "policy created: $policyId"
