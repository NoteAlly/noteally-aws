#
# VPC LINK
#

resource "aws_api_gateway_vpc_link" "api_gateway_vpc_link" {
  name        = "api_gateway_vpc_link"
  description = "API Gateway VPC Link"
  target_arns = [aws_lb.network_load_balancer.arn]
}


#
# API GATEWAY
#

resource "aws_api_gateway_rest_api" "api_gateway" {
  name               = "api_gateway"
  description        = "API Gateway"
  binary_media_types = ["*/*"]
}


#
# API ENDPOINTS
#

resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_gateway_method" {
  resource_id   = aws_api_gateway_resource.api_gateway_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api_gateway_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = aws_api_gateway_method.api_gateway_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.network_load_balancer.dns_name}:8000/{proxy}/"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.api_gateway_vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}


#
# API GATEWAY DEPLOYMENT
#

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  depends_on = [
    aws_api_gateway_integration.api_gateway_integration,
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_gateway_resource,
      aws_api_gateway_method.api_gateway_method,
      aws_api_gateway_integration.api_gateway_integration,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "api_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  stage_name    = "dev"
}
