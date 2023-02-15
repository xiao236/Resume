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
			"Sid": "ExampleStmt",
			"Action": [
				"s3:GetObject"
			],
			"Effect": "Allow",
			"Resource": [
				"arn:aws:s3:::state-file-resume/*"
			]
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

    s3_bucket = "state-file-resume"
}