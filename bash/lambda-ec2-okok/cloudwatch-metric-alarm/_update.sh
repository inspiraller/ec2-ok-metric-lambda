#!/bin/sh

if [[ -z $project_repo || -z $LAMBDA_FUNCTION_EC2_OKOK ]]; then
   echo "Must provide project_repo, LAMBDA_FUNCTION_EC2_OKOK"
   exit 1
fi

metric_filter="metric-filter-$LAMBDA_FUNCTION_EC2_OKOK"

# delete then recreate
aws logs delete-metric-filter \
    --log-group-name $project_repo \
    --filter-name $metric_filter

sh _create.sh
