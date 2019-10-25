provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}

resource "aws_iam_role" "lambda_jenkins_deploy_role" {
  name = "lambda_jenkins_deploy_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "lambda_jenkins_deploy_role_profile" {
  name = "lambda_jenkins_deploy_role_profile"
  role = "${aws_iam_role.lambda_jenkins_deploy_role.name}"
}

resource "aws_iam_role_policy" "lambda_jenkins_deploy_policy" {
  name        = "lambda_jenkins_deploy_policy"
  role = "${aws_iam_role.lambda_jenkins_deploy_role.id}"
  # path        = "/"
  # description = "Policy to deploy Lambda functions with serverless from jenkins"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:CreateFunction",
                "lambda:UpdateFunctionCode",
                "lambda:PublishLayerVersion",
                "lambda:UpdateFunctionConfiguration",
                "lambda:PublishVersion",
                "lambda:UpdateAlias",
                "lambda:CreateAlias"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "lambda_jenkins_execute_role" {
  name = "lambda_jenkins_execute_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

resource "aws_iam_instance_profile" "lambda_jenkins_execute_role_profile" {
  name = "lambda_jenkins_execute_role_profile"
  role = "${aws_iam_role.lambda_jenkins_execute_role.name}"
}


resource "aws_iam_role_policy" "lambda_execute_policy" {
  name        = "lambda_execute_policy"
  # path        = "/"
  role = "${aws_iam_role.lambda_jenkins_execute_role.id}"
  # description = "Policy to execute Lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "lambda:ListFunctions",
                "lambda:InvokeFunction",
                "lambda:GetLayerVersion",
                "lambda:ListVersionsByFunction",
                "lambda:GetFunction",
                "lambda:ListAliases",
                "lambda:ListLayerVersions",
                "lambda:InvokeAsync",
                "lambda:ListLayers",
                "lambda:GetAlias"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}