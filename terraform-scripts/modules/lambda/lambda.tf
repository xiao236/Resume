resource "aws_iam_role" "lambdaRole" {
    assume_role_policy = <<EOF
{
	"Version": "2012-10-17",
	"Statement": [{
			"Effect": "Allow",
			"Action": [
				"dynamodb:BatchGetItem",
				"dynamodb:GetItem",
				"dynamodb:Query",
				"dynamodb:Scan",
				"dynamodb:BatchWriteItem",
				"dynamodb:PutItem",
				"dynamodb:UpdateItem"
			],
			"Resource": "${var.db_arn}"
		},
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
	]
}
    EOF
}

resource "aws_lambda_function" "updateHandler" {
    function_name = "crud-handler"
    role = aws_iam_role.lambdaRole.arn

    filename = "./handler.py"
    runtime = "python3.9"
    handler = "handler"
}