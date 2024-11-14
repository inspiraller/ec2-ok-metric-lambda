# How to Debug ec2 instance
- AWS Console > EC2 > Instances > Click - Running instance - dev-project-example-nextjs > Click > Connect
- copy: *ssh -i "dev-project-example.pem" ec2-user@[UNIQUE IP].eu-west-2.compute.amazonaws.com*

```sh
cd bash/ec2-keypair
ssh -i "dev-project-example.pem" ec2-user@ec2-52-56-179-133.eu-west-2.compute.amazonaws.com
```
- Click Yes to fingerprint

> Troubleshoot - bad connection: 
- Update AWS Console to allow ssh connection from your personal ip address
```sh
cd ec2-security-group
sh _create.sh
```
- or from terminal get MY IP:
`curl ifcfg.me`
123.11.11.111
- From AWS Console > EC2 > Security Groups > dev-project-example-nextjs > Edit inbound rules > Add rule > Custom TCP > 22 > Source: [123.11.11.111/32] > Save

> Troubleshoot - no pem:
- Makesure you are trying to connect with the local.pem file in this same folder
> Troubleshoot: old connection was working
Whenever you stop an ec2 instane it comes up with a new id. So go to the aws console and reselect connect to the instance 
- ssh -i "dev-project-example.pem" ec2-user@[new ip].eu-west-2.compute.amazonaws.com


> WARNING: Don't git commit this pem file

# Debug logs From inside ec2 instance
clear some space
[enter]
[enter]

- Inspect the cloudwatch on boat logs to look for clues
`sudo tail -n 40 /var/log/cloud-init-output.log`

- Inspect the  custom made on-restart log to look for clues
`sudo tail -n 40 /var/log/on-restart.log`

# How to debug cloudwatch metric alarms?


# How to debug cloud watch metric alarm is actually calling lambda
- In AWS Console > CloudWatch > Alarms > Select the alarm > Click - Tab - History

You should see a list like this:
- 2024-11-14 19:23:45 State update Alarm updated from In alarm to OK.
- 2024-11-14 19:23:44 Action Successfully executed action 

> Troubleshoot: function:lambdaEC2okOK. Received error: "CloudWatch Alarms is not authorized to perform: lambda:InvokeFunction

- Note: When using ai to suggest solutions for the correct principle it can give the 
**you the wrong one**:
--principal cloudwatch.amazonaws.com

**This is correct**:
--lambda.alarms.cloudwatch.amazonaws.com

```sh
aws lambda add-permission \
    --function-name $LAMBDA_FUNCTION_EC2_OKOK \
    --statement-id CloudWatchAlarmInvoke2 \
    --action lambda:InvokeFunction \
    --principal lambda.alarms.cloudwatch.amazonaws.com \
    --source-account $accountID \
    --source-arn "arn:aws:cloudwatch:${REGION}:${accountID}:alarm:*" \
```

# Why is the metric stuck in 'in alarm' state for so long?
This is probably because there is an error like above, so nothing resets the alarm

# Why does the metric alarm show 'insufficent data'
- this is deliberate. It actually means the alarm is not triggered yet

# Why is the metric alarm not triggerd as soon as the log appears?
This is because the alarm metric is actually a poll of period of 1 minute.
- The log appears
- When the metric recycle of 60 seconds is up then the alarm will check the metric

# Why can I not change the metric duration, once its triggered to be one moment in time?
It can't happen. This is the limitation of the metric alarm. The duration will be for as long as the period of 60 seconds or more.
How to move it out of alarm state? Once it triggers the lambda, the lambda can reset the alarm, then the lambda can do other stuff.

# How to create a test log to trigger the metric alarm
- cd bash/test/
- sh _create.sh

