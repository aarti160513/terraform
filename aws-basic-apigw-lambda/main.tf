terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.70"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

data "archive_file" "lambda_hello_universe" {
  type = "zip"

  source_dir  = "${path.module}/hello-universe"
  output_path = "${path.module}/hello-universe.zip"
}



resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.hello.id
  resource_id             = aws_api_gateway_resource.hello.id
  http_method             = aws_api_gateway_method.hello.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
}

resource "aws_cloudwatch_log_group" "api_gw" {
  name              = "/aws/api_gw/${aws_api_gateway_rest_api.hello.name}"
  retention_in_days = 5
}

resource "aws_lambda_permission" "api_gw" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.hello.execution_arn}/*/*"
}

resource "aws_api_gateway_deployment" "hello" {
  rest_api_id = aws_api_gateway_rest_api.hello.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "hello" {
  deployment_id = aws_api_gateway_deployment.hello.id
  rest_api_id   = aws_api_gateway_rest_api.hello.id
  stage_name    = "dev"
}