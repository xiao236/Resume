resource "aws_apigatewayv2_api" "connector" {
    name          = "connector-http-api"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "connroute" {
    api_id    = aws_apigatewayv2_api.connector.id
    route_key = "ANY /visitors/{proxy+}"
    target = "integrations/${aws_apigatewayv2_integration.connint.id}"
}

resource "aws_apigatewayv2_integration" "connint" {
    api_id           = aws_apigatewayv2_api.connector.id
    integration_type = "AWS_PROXY"

    connection_type           = "INTERNET"
    integration_method        = "POST"
    integration_uri           = var.invoke_arn
    passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_stage" "staged" {
    depends_on = [
        aws_apigatewayv2_route.connroute
    ]  
    api_id = aws_apigatewayv2_api.connector.id
    name   = "staging-gateway"
    auto_deploy = true
}

resource "aws_apigatewayv2_deployment" "gotime" {
    depends_on = [
       aws_apigatewayv2_route.connroute, aws_apigatewayv2_stage.staged
    ]
    api_id      = aws_apigatewayv2_api.connector.id

    lifecycle {
        create_before_destroy = true
    }
}