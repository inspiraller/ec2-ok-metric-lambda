#!/bin/sh
cd ec2-iam-roles
cd ../ec2-iam-roles && sh _update.sh
cd ../ec2-keypair && sh _update.sh
cd ../ec2-security-group && sh _update.sh
cd ../loggroup && sh _update.sh
cd ../lambda-ec2-okok && sh _update.sh 
cd ../ec2-instance && sh _update.sh 
