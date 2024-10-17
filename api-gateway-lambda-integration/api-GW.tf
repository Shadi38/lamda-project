resource "aws_api_gateway_rest_api" "API" {
  name        = "lambda-api"
  description = "lambda-api"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}



# Create method for the root path 
resource "aws_api_gateway_method" "RootMethod" {
  rest_api_id   = aws_api_gateway_rest_api.API.id
  resource_id   = aws_api_gateway_rest_api.API.root_resource_id
  http_method   = "GET"
  authorization = "NONE"
}

# Define the /time resource
resource "aws_api_gateway_resource" "Resource" {
  rest_api_id = aws_api_gateway_rest_api.API.id
  parent_id   = aws_api_gateway_rest_api.API.root_resource_id
  path_part   = "time"
}

# Create method for the /time path (GET)
resource "aws_api_gateway_method" "Method" {
  rest_api_id   = aws_api_gateway_rest_api.API.id
  resource_id   = aws_api_gateway_resource.Resource.id
  http_method   = "GET"
  authorization = "NONE"
}

# integration for the root "/" (AWS_PROXY)
resource "aws_api_gateway_integration" "RootIntegration" {
  rest_api_id = aws_api_gateway_rest_api.API.id
  resource_id = aws_api_gateway_rest_api.API.root_resource_id
  http_method = aws_api_gateway_method.RootMethod.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.lambda-function.invoke_arn
}

# Integration for the /time path (AWS_PROXY)
resource "aws_api_gateway_integration" "Integration" {
  rest_api_id = aws_api_gateway_rest_api.API.id
  resource_id = aws_api_gateway_resource.Resource.id
  http_method = aws_api_gateway_method.Method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.lambda-function.invoke_arn
  credentials = aws_iam_role.iam-role_gateway.arn
}


#grants API Gateway permission to invoke the Lambda function 
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda-function.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:${aws_api_gateway_rest_api.API.id}/*/${aws_api_gateway_method.Method.http_method}${aws_api_gateway_resource.Resource.path}"
}

output "api_gateway_arn" {
  value = "arn:aws:execute-api:${var.AWS_REGION}:${var.AWS_ACCOUNT_ID}:${aws_api_gateway_rest_api.API.id}/*/${aws_api_gateway_method.Method.http_method}${aws_api_gateway_resource.Resource.path}"
  sensitive = true
}


#deploys the API to the test stage, making it publicly accessible
resource "aws_api_gateway_deployment" "example" {
  depends_on = [
    aws_api_gateway_integration.Integration,
    aws_api_gateway_integration.RootIntegration,
    aws_api_gateway_method.Method,
    aws_api_gateway_method.RootMethod
  ]
  lifecycle {
    create_before_destroy = true
  }
  rest_api_id = aws_api_gateway_rest_api.API.id
  stage_name  = "test"
}


# resource "aws_s3_bucket" "firstbucketshadi" {
#   bucket = "firstbucketshadi"
  
# }



