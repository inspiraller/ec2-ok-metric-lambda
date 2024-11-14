#!/bin/sh
set -a; source .env; set +a

if [[ -z $PROJECT_NAME || -z $SERVER_ENV ]]; then
   echo "Must provide PROJECT_NAME, SERVER_ENV"
   exit 1
fi

export project_repo="${PROJECT_NAME}-${SERVER_ENV}"

# Open browser for starturl
start $starturl
aws sts get-caller-identity



