resource "aws_apigatewayv2_api" "connector" {
    name          = "connector-http-api"
    protocol_type = "HTTP"
}

resource "aws_apigatewayv2_route" "connroute" {
    api_id    = aws_apigatewayv2_api.connector.id
    route_key = "PUT /visitors/{id}"
}

resource "aws_apigatewayv2_integration" "connint" {
    api_id           = aws_apigatewayv2_api.connector.id
    integration_type = "AWS_PROXY"

    connection_type           = "INTERNET"
    content_handling_strategy = "CONVERT_TO_TEXT"
    integration_method        = "PUT"
    integration_uri           = var.invoke_arn
    passthrough_behavior      = "WHEN_NO_MATCH"
}

resource "aws_apigatewayv2_deployment" "gotime" {
  api_id      = aws_apigatewayv2_api.connector.id

  lifecycle {
    create_before_destroy = true
  }
}