output "get_arn" {
    value = aws_lambda_function.getHandler.invoke_arn
}

output "put_arn" {
    value = aws_lambda_function.updateHandler.invoke_arn
}

output "test_arn" {
    value = aws_lambda_function.HelloWorld.invoke_arn
}