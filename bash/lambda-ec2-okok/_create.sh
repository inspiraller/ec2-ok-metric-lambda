#!/bin/sh
cd role-lambda

cd ../role-lambda && sh ./_create.sh
cd ../lambda-function && sh _create.sh
cd ../subscription-filter && sh _create.sh
# need both metric and lambda to exist for this to be applied
cd  ../lambda-permission && sh _create.sh