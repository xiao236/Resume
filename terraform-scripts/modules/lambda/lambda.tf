resource "aws_iam_role_policy" "lambdaPolicy" {
	name = "lambdapolicy"
	role = aws_iam_role.lambdaRole.id
	policy = <<EOF
{
  	"Version": "2012-10-17",
  	"Statement": [
    	{
      		"Sid": "Stmt1428341300017",
      		"Action": [
				"dynamodb:DeleteItem",
				"dynamodb:GetItem",
				"dynamodb:PutItem",
				"dynamodb:Query",
				"dynamodb:Scan",
				"dynamodb:UpdateItem"
      		],
      		"Effect": "Allow",
      		"Resource": "*"
    	},
    	{
      		"Sid": "",
      		"Resource": "*",
      		"Action": [
				"logs:CreateLogGroup",
				"logs:CreateLogStream",
				"logs:PutLogEvents"
			],
      		"Effect": "Allow"
    	}
  	]
}
	EOF
}

resource "aws_iam_role" "lambdaRole" {
	name = "lambdarole"
    assume_role_policy = <<EOF
{
  	"Version": "2012-10-17",
  	"Statement": [
    	{
      		"Sid": "",
			"Effect": "Allow",
			"Principal": {
				"Service": [
					"lambda.amazonaws.com"
				]
			},
			"Action": "sts:AssumeRole"
    	}
  	]
}
    EOF
}

resource "aws_lambda_function" "updateHandler" {
    function_name = "update-handler"
    role = aws_iam_role.lambdaRole.arn

    s3_bucket = "state-file-resume"
	s3_key = "handlerFiles/putfunc.zip"

	runtime = "python3.7"
	handler = "index.lambda_handler"
}

resource "aws_lambda_function" "getHandler" {
    function_name = "get-handler"
    role = aws_iam_role.lambdaRole.arn

    s3_bucket = "state-file-resume"
	s3_key = "handlerFiles/getfunc.zip"

	runtime = "python3.7"
	handler = "index.lambda_handler"
}

resource "aws_lambda_function" "HelloWorld" {
    function_name = "hello-world"
    role = aws_iam_role.lambdaRole.arn

    s3_bucket = "state-file-resume"
	s3_key = "handlerFiles/hitest.zip"

	runtime = "python3.7"
	handler = "index.lambda_handler"
}