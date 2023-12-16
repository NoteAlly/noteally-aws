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
# API ENDPOINTS - INFO
#

resource "aws_api_gateway_resource" "api_gateway_info_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "info"
}

resource "aws_api_gateway_method" "api_gateway_info_method" {
  resource_id   = aws_api_gateway_resource.api_gateway_info_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api_gateway_info_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_info_resource.id
  http_method = aws_api_gateway_method.api_gateway_info_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.network_load_balancer.dns_name}:8000/"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.api_gateway_vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}


#
# API ENDPOINTS - AUTH
#

resource "aws_api_gateway_resource" "api_gateway_auth_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "auth"
}

resource "aws_api_gateway_resource" "api_gateway_auth_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api_gateway_auth_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_gateway_auth_method" {
  resource_id   = aws_api_gateway_resource.api_gateway_auth_proxy_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api_gateway_auth_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_auth_proxy_resource.id
  http_method = aws_api_gateway_method.api_gateway_auth_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.network_load_balancer.dns_name}:8001/{proxy}/"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.api_gateway_vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}


#
# API ENDPOINTS - MATERIALS
#

resource "aws_api_gateway_resource" "api_gateway_material_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "materials"
}

# root endpoint 
resource "aws_api_gateway_method" "api_gateway_material_root_method" {
  resource_id   = aws_api_gateway_resource.api_gateway_material_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api_gateway_material_root_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_material_resource.id
  http_method = aws_api_gateway_method.api_gateway_material_root_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.network_load_balancer.dns_name}:8002/"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.api_gateway_vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# non-root endpoint 
resource "aws_api_gateway_resource" "api_gateway_material_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api_gateway_material_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_gateway_material_method" {
  resource_id   = aws_api_gateway_resource.api_gateway_material_proxy_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api_gateway_material_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_material_proxy_resource.id
  http_method = aws_api_gateway_method.api_gateway_material_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.network_load_balancer.dns_name}:8002/{proxy}/"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.api_gateway_vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}


#
# API ENDPOINTS - TUTOR
#

resource "aws_api_gateway_resource" "api_gateway_tutor_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "tutors"
}

# root endpoint
resource "aws_api_gateway_method" "api_gateway_tutor_root_method" {
  resource_id   = aws_api_gateway_resource.api_gateway_tutor_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api_gateway_tutor_root_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_tutor_resource.id
  http_method = aws_api_gateway_method.api_gateway_tutor_root_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.network_load_balancer.dns_name}:8003/"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.api_gateway_vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}

# non-root endpoint
resource "aws_api_gateway_resource" "api_gateway_tutor_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api_gateway_tutor_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_gateway_tutor_method" {
  resource_id   = aws_api_gateway_resource.api_gateway_tutor_proxy_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api_gateway_tutor_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_tutor_proxy_resource.id
  http_method = aws_api_gateway_method.api_gateway_tutor_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.network_load_balancer.dns_name}:8003/{proxy}/"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.api_gateway_vpc_link.id

  request_parameters = {
    "integration.request.path.proxy" = "method.request.path.proxy"
  }
}


#
# API ENDPOINTS - USER
#

resource "aws_api_gateway_resource" "api_gateway_user_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_resource" "api_gateway_user_proxy_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_resource.api_gateway_user_resource.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "api_gateway_user_method" {
  resource_id   = aws_api_gateway_resource.api_gateway_user_proxy_resource.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  http_method   = "ANY"
  authorization = "NONE"

  request_parameters = {
    "method.request.path.proxy" = true
  }
}

resource "aws_api_gateway_integration" "api_gateway_user_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_user_proxy_resource.id
  http_method = aws_api_gateway_method.api_gateway_user_method.http_method

  type                    = "HTTP_PROXY"
  integration_http_method = "ANY"
  uri                     = "http://${aws_lb.network_load_balancer.dns_name}:8004/{proxy}/"

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
    aws_api_gateway_integration.api_gateway_info_integration,
    aws_api_gateway_integration.api_gateway_auth_integration,
    aws_api_gateway_integration.api_gateway_material_root_integration,
    aws_api_gateway_integration.api_gateway_material_integration,
    aws_api_gateway_integration.api_gateway_tutor_root_integration, 
    aws_api_gateway_integration.api_gateway_tutor_integration,
    aws_api_gateway_integration.api_gateway_user_integration
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.api_gateway_info_resource,
      aws_api_gateway_method.api_gateway_info_method,
      aws_api_gateway_integration.api_gateway_info_integration,
      aws_api_gateway_resource.api_gateway_auth_resource,
      aws_api_gateway_resource.api_gateway_auth_proxy_resource,
      aws_api_gateway_method.api_gateway_auth_method,
      aws_api_gateway_integration.api_gateway_auth_integration,
      aws_api_gateway_resource.api_gateway_material_resource,
      aws_api_gateway_resource.api_gateway_material_proxy_resource,
      aws_api_gateway_method.api_gateway_material_root_method,
      aws_api_gateway_integration.api_gateway_material_root_integration,
      aws_api_gateway_method.api_gateway_material_method,
      aws_api_gateway_integration.api_gateway_material_integration,
      aws_api_gateway_resource.api_gateway_tutor_resource,
      aws_api_gateway_resource.api_gateway_tutor_proxy_resource,
      aws_api_gateway_method.api_gateway_tutor_root_method,
      aws_api_gateway_integration.api_gateway_tutor_root_integration,
      aws_api_gateway_method.api_gateway_tutor_method,
      aws_api_gateway_integration.api_gateway_tutor_integration,
      aws_api_gateway_resource.api_gateway_user_resource,
      aws_api_gateway_resource.api_gateway_user_proxy_resource,
      aws_api_gateway_method.api_gateway_user_method,
      aws_api_gateway_integration.api_gateway_user_integration
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
