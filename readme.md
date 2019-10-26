Credentials for AWS Iam and jenkins avaialable in encrypted file shared via email


Deployment procedure
=====================
1) Run ```packer build``` in packer dir
2) Run ```terraform deploy``` in terraform dir
3) Log into http://jenkins.devopstest.christogoosen.co.za/ with user goose
4) Run jenkins job: deployLambdaVAT

All of these were already deployed, but this is a note of deploying this workflow


Lambda Credentials
=================
```
[vatGlobal]
aws_access_key_id = xxxxx
aws_secret_access_key = xxxxx
```

Invoke Lambda
================
```bash
aws lambda invoke --function-name "devops-lambda-test-dev-func" --log-type Tail --payload '{"a":"b"}' out.json --profile vatGlobal --region eu-west-1
```

Invoke Lambda http/ApiGateway
============================
http://lambda.devopstest.christogoosen.co.za/
or
URL from jenkins deplot output
