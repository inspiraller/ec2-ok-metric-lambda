#!/bin/sh

cd role-lambda && sh ./_update.sh
cd  ../lambda-function && sh _update.sh
cd ../subscription-filter && sh _update.sh
# need both metric and lambda to exist for this to be applied
cd  ../lambda-permission && sh _update.sh