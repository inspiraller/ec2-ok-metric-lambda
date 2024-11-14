#!/bin/sh
cd ec2-iam-roles
cd ../ec2-iam-roles && sh _create.sh
cd ../ec2-keypair && sh _create.sh
cd ../ec2-security-group && sh _create.sh
cd ../loggroup && sh _create.sh
cd ../lambda-ec2-okok && sh _create.sh 
cd ../ec2-instance && sh _create.sh 


