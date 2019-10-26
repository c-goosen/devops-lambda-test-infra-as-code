provider "aws" {
  version = "~> 2.0"
  region  = "eu-west-1"
}
resource "aws_iam_user" "vatGlobal" {
  name = "vatGlobal"
  path = "/system/"

  tags = {
    Name = "vatGlobal"
    Role = "ExecuteLambda"
  }
}

resource "aws_iam_access_key" "vatGlobal_access_key" {
  user = "${aws_iam_user.vatGlobal.name}"
}

resource "aws_iam_user_policy" "vatGlobal_role" {
  name = "vatGlobalRole"
  user = "${aws_iam_user.vatGlobal.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
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
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
