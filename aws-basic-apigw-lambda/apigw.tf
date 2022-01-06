
resource "aws_api_gateway_rest_api" "hello" {
  name = "HelloUniverse"
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "hello" {
  parent_id   = aws_api_gateway_rest_api.hello.root_resource_id
  path_part   = "hello"
  rest_api_id = aws_api_gateway_rest_api.hello.id
}

resource "aws_api_gateway_method" "hello" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.hello.id
  rest_api_id   = aws_api_gateway_rest_api.hello.id
}