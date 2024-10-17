output "api-gateway-url" {
  value = "https://${aws_api_gateway_rest_api.API.id}.execute-api.${var.AWS_REGION}.amazonaws.com/test"
  sensitive = true
}

