

# IAM
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam-role" {
  name               = "iam_role_lambda_api_gateway"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}



data "aws_iam_policy_document" "assume_role_gateway" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam-role_gateway" {
  name               = "iam_role_api_gateway"
  assume_role_policy = data.aws_iam_policy_document.assume_role_gateway.json
}


# For Lambda Role: Attach CloudWatch Permissions (Inline Policy)
resource "aws_iam_role_policy" "lambda_cloudwatch_policy" {
  name = "cloudwatch-policy"
  role = aws_iam_role.iam-role.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      }
    ]
  })
}

# For API Gateway Role: Attach a Managed Policy or Create Inline Policy
resource "aws_iam_role_policy_attachment" "gateway_role_attachment" {
  role       = aws_iam_role.iam-role_gateway.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonAPIGatewayInvokeFullAccess"
}
