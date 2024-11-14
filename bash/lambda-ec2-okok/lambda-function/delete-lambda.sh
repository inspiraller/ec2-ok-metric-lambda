#!/bin/sh

# After updating python-log-example.template

if [[ -z $$LAMBDA_FUNCTION_EC2_OKOK ]]; then
   echo "Must provide LAMBDA_FUNCTION_EC2_OKOK"
   exit 1
fi

aws lambda delete-function --function-name  $LAMBDA_FUNCTION_EC2_OKOK

