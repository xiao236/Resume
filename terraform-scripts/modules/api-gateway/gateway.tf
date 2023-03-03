resource "aws_iam_role_policy" "apiPolicy" {
	name = "apipolicy"
	role = aws_iam_role.apiRole.id
	policy = <<EOF
{
  	"Version": "2012-10-17",
  	"Statement": [
    	{
      		"Sid": "Stmt1428341300018",
      		"Action": [
				"lambda:InvokeFunction"
      		],
      		"Effect": "Allow",
      		"Resource": "*"
    	}
  	]
}
	EOF
}

resource "aws_iam_role" "apiRole" {
	name = "apirole"
    assume_role_policy = <<EOF
{
  	"Version": "2012-10-17",
  	"Statement": [
    	{
      		"Sid": "",
			"Effect": "Allow",
			"Principal": {
				"Service": [
					"apigateway.amazonaws.com"
				]
			},
			"Action": "sts:AssumeRole"
    	}
  	]
}
    EOF
}

resource "aws_apigatewayv2_api" "connector" {
    name          = "connector-http-api"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "getroute" {
    api_id    = aws_apigatewayv2_api.connector.id
    route_key = "GET /visitors"
    target = "integrations/${aws_apigatewayv2_integration.getint.id}"
}

resource "aws_apigatewayv2_integration" "getint" {
    api_id           = aws_apigatewayv2_api.connector.id
    integration_type = "AWS_PROXY"

    connection_type           = "INTERNET"
    integration_method        = "POST"
    integration_uri           = var.get_arn
    credentials_arn           = aws_iam_role.apiRole.arn
    passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "putroute" {
    api_id    = aws_apigatewayv2_api.connector.id
    route_key = "PUT /visitors"
    target = "integrations/${aws_apigatewayv2_integration.putint.id}"
}

resource "aws_apigatewayv2_integration" "putint" {
    api_id           = aws_apigatewayv2_api.connector.id
    integration_type = "AWS_PROXY"

    connection_type           = "INTERNET"
    integration_method        = "POST"
    integration_uri           = var.put_arn
    credentials_arn           = aws_iam_role.apiRole.arn
    passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_route" "testroute" {
    api_id    = aws_apigatewayv2_api.connector.id
    route_key = "GET /"
    target = "integrations/${aws_apigatewayv2_integration.testint.id}"
}

resource "aws_apigatewayv2_integration" "testint" {
    api_id           = aws_apigatewayv2_api.connector.id
    integration_type = "AWS_PROXY"

    connection_type           = "INTERNET"
    integration_method        = "POST"
    integration_uri           = var.test_arn
    credentials_arn           = aws_iam_role.apiRole.arn
    passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_stage" "staged" {
    depends_on = [
        aws_apigatewayv2_route.putroute, aws_apigatewayv2_route.getroute, aws_apigatewayv2_route.testroute
    ]  
    api_id = aws_apigatewayv2_api.connector.id
    name   = "$default"
    auto_deploy = true
}

resource "aws_apigatewayv2_deployment" "gotime" {
    depends_on = [
       aws_apigatewayv2_stage.staged
    ]
    api_id      = aws_apigatewayv2_api.connector.id

    lifecycle {
        create_before_destroy = true
    }
}