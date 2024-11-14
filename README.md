# Summary
This repo shows how to use Bash scripts to automate creation of the following aws services via aws-cli.
- ec2 role
- ec2 security group
- ec2 key pair
- ec2 instance
- log group for ec2 instance
- cloudwatch metric and alarm to trigger lambda
- zipping typescript nodejs code and deploying as lambda

# Pre-requisites
- Own an AWS account
- Downloaded and installed aws-cli from AWS
- Git Bash
- Nodejs
- Docker

# What does it do?
The script will trigger the creation of an ec2 instance
The ec2 instance will trigger a cloudwatch log into loggroup to say "system status is ok"
The cloudwatch metric alarm 'in alarm' state will detect "system status is ok" and then trigger a lambda
The lambda will stop rest the metric alarm to 'ok' state.

# What is it good for?
- You could use the lambda to trigger other services accordingly.
- You can re-use the logic for the metric for other purposes.
- You can learn how to optimise bash scripts for automating task

# How to use
1. [Ceate an AWS Account to use and login via the terminal](READMES/README-how-to-create-aws-account.md)
2. [How to login](READMES/README-how-to-login.md)

3. Update your starter url in the .env variables.
4. cp .env.example .env
5. From terminal - Create more variable $project-repo
```sh
cd bash
source start.sh
```
5. npm instal packages for typescript lambda
- `cd lambda-ec2-okok/lambda-function/typescript`
- `npm i`

6. Run all scripts
- Cd to the root of this repo
- `sh _create.sh`

6. Login to AWS Console from above starter url
7. Test the cloudwatch logs in the AWS Console
- AWS Console > CloudWatch > Alarms > metric alarm > view history
- AWS Console > CloudWatch > Logs > log group > log stream
- AWS Console > CloudWatch > Logs > log group > lambda function log group

8. Stop the ec2 instance and restart it to test the logs

done!

# How to debug
[README-debug-ec2-instance](README-debug-ec2-instance.md)

# Warning
- Do not commit your .env file to git
- Do not commit your .pem file to git

They have been deliberately excluded in the .gitignore file of this repo.

