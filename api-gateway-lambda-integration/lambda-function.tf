resource "aws_lambda_function" "lambda-function" {
  filename      = "./lambda-function.zip"
  function_name = "api-gw-lambda"
  role          = aws_iam_role.iam-role.arn
  handler       = "server.handler"
  runtime       = "nodejs18.x"
}

