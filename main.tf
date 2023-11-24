terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  access_key = local.envs["AWS_ACCESS_KEY_ID"]
  secret_key = local.envs["AWS_SECRET_ACCESS_KEY"]
  token      = try(local.envs["AWS_SESSION_TOKEN"], null)
  region     = local.envs["AWS_DEFAULT_REGION"]

}

terraform {
  required_version = ">= 0.12"
}

# --------------------------------------------------------- Network ---------------------------------------------------------

# #
# # VPC
# #

# resource "aws_vpc" "noteally_vpc" {
#   cidr_block = "10.0.0.0/16"

#   enable_dns_support   = true
#   enable_dns_hostnames = true

#   tags = {
#     Name = "noteally-vpc"
#   }
# }


# #
# # PUBLIC SUBNET
# #

# resource "aws_subnet" "noteally_public_subnet" {
#   count             = length(var.public_subnet_cidrs)
#   vpc_id            = aws_vpc.noteally_vpc.id
#   cidr_block        = element(var.public_subnet_cidrs, count.index)
#   availability_zone = element(var.azs, count.index)

#   map_public_ip_on_launch = true

#   tags = {
#     Name = "noteally_public_subnet_${count.index}"
#   }
# }


# #
# # PRIVATE SUBNET
# #

# resource "aws_subnet" "noteally_private_subnet" {
#   count             = length(var.private_subnet_cidrs)
#   vpc_id            = aws_vpc.noteally_vpc.id
#   cidr_block        = element(var.private_subnet_cidrs, count.index)
#   availability_zone = element(var.azs, count.index)

#   tags = {
#     Name = "noteally_private_subnet_${count.index}"
#   }
# }



# #
# # ACLs
# #

#   #
#   # Public ACL
#   #

#   resource "aws_network_acl" "noteally_public_acl" {
#     vpc_id = aws_vpc.noteally_vpc.id

#     ingress {
#       protocol   = "HTTPS"
#       rule_no    = 100
#       action     = "allow"
#       cidr_block = "0.0.0.0/0"
#       from_port  = 0
#       to_port    = 0
#     }

#     egress {
#       protocol   = "HTTPS"
#       rule_no    = 100
#       action     = "allow"
#       cidr_block = "0.0.0.0/0"
#       from_port  = 0
#       to_port    = 0
#     }

#     tags = {
#       Name = "noteally_public_acl"
#     }
#   }

#   resource "aws_network_acl_association" "noteally_public_acl_association" {
#     count = length(var.public_subnet_cidrs)
#     network_acl_id = aws_network_acl.noteally_public_acl.id
#     subnet_id      = aws_subnet.noteally_public_subnet[count.index].id
#   }


#   #
#   # Private ACL
#   #

#   resource "aws_network_acl" "noteally_private_acl" {
#     vpc_id = aws_vpc.noteally_vpc.id

#     ingress {
#       protocol   = "https"
#       rule_no    = 100
#       action     = "allow"
#       cidr_block = "0.0.0.0/0"
#       from_port  = 0
#       to_port    = 0
#     }

#     egress {
#       protocol   = "https"
#       rule_no    = 100
#       action     = "allow"
#       cidr_block = "0.0.0.0/0"
#       from_port  = 0
#       to_port    = 0
#     }

#     tags = {
#       Name = "noteally_private_acl"
#     }
#   }

#   resource "aws_network_acl_association" "noteally_private_acl_association" {
#     network_acl_id = aws_network_acl.noteally_private_acl.id
#     subnet_id      = aws_subnet.noteally_private_subnet[0].id
#   }


# #
# # INTERNET GATEWAY
# #

# resource "aws_internet_gateway" "noteally_igw" {
#   vpc_id = aws_vpc.noteally_vpc.id

#   tags = {
#     Name = "noteally_igw"
#   }
# }


# #
# # ELASTIC IP
# #

# resource "aws_eip" "noteally_eip" {
#   domain = "vpc"

#   tags = {
#     Name = "noteally_eip"
#   }
# }


# #
# # NAT GATEWAY
# #

# resource "aws_nat_gateway" "noteally_nat_gateway" {
#   allocation_id = aws_eip.noteally_eip.id
#   subnet_id     = aws_subnet.noteally_public_subnet[0].id

#   tags = {
#     Name = "noteally_nat_gateway"
#   }
# }


# #
# # PUBLIC ROUTING TABLE
# #

# resource "aws_route_table" "noteally_public_rt" {
#   vpc_id = aws_vpc.noteally_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.noteally_igw.id
#   }

#   tags = {
#     Name = "noteally_public_rt"
#   }
# }

# resource "aws_route_table_association" "noteally_public_subnet_association" {
#   count          = length(var.public_subnet_cidrs)
#   subnet_id      = aws_subnet.noteally_public_subnet[count.index].id
#   route_table_id = aws_route_table.noteally_public_rt.id
# }


# #
# # PRIVATE ROUTING TABLE
# #

# resource "aws_route_table" "noteally_private_rt" {
#   vpc_id = aws_vpc.noteally_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_nat_gateway.noteally_nat_gateway.id
#   }

#   tags = {
#     Name = "noteally_private_rt"
#   }
# }

# resource "aws_route_table_association" "noteally_private_subnet_association" {
#   subnet_id      = aws_subnet.noteally_private_subnet[0].id
#   route_table_id = aws_route_table.noteally_private_rt.id
# }




# --------------------------------------------------------- Backend EC2 ---------------------------------------------------------

# #
# # EC2 INSTANCE
# #

# resource "aws_instance" "ec2_api" {
#   ami                    = "ami-0fe8bec493a81c7da"
#   instance_type          = "t3.micro"
#   key_name               = aws_key_pair.aws_key_api.key_name
#   subnet_id              = aws_subnet.noteally_private_subnet[0].id
#   vpc_security_group_ids = [aws_security_group.api_sg.id]
#   user_data              = local.user_data
#   depends_on = [
#     aws_internet_gateway.noteally_igw,
#     aws_nat_gateway.noteally_nat_gateway
#   ]

#   tags = {
#     Name = "ec2-api"
#   }
# }


# #
# # SECURITY GROUP
# #

# resource "aws_security_group" "api_sg" {
#   name        = "api_sg"
#   description = "Allow TCP and SSH traffic"
#   vpc_id      = aws_vpc.noteally_vpc.id

#   ingress {
#     from_port   = 8000
#     to_port     = 8000
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# #
# # KEY PAIR
# #

# resource "aws_key_pair" "aws_key_api" {
#   key_name   = "aws_key"
#   public_key = file("keys/aws-key-api.pub")
# }


# #
# # INIT SCRIPT
# #

# locals {
#   user_data = templatefile(
#     "./init.sh",
#     {
#       DJANGO_KEY              = local.envs["DJANGO_KEY"]
#       AWS_ACCESS_KEY_ID       = local.envs["AWS_ACCESS_KEY_ID"]
#       AWS_SECRET_ACCESS_KEY   = local.envs["AWS_SECRET_ACCESS_KEY"]
#       AWS_STORAGE_BUCKET_NAME = local.envs["AWS_STORAGE_BUCKET_NAME"]
#       AWS_DEFAULT_ACL         = local.envs["AWS_DEFAULT_ACL"]
#     }
#   )
# }



# --------------------------------------------------------- Network Load Balancer ---------------------------------------------------------

# #
# # NETWORK LOAD BALANCER
# #

# resource "aws_lb" "network_load_balancer" {
#   name               = "network-load-balancer"
#   internal           = false
#   load_balancer_type = "network"
#   subnets            = [aws_subnet.noteally_private_subnet[0].id]
#   security_groups    = [aws_security_group.api_sg.id]


#   tags = {
#     Environment = "production"
#   }
# }


# #
# # TARGET GROUP
# #

# resource "aws_lb_target_group" "target_group" {
#   name        = "rest-api-target-group"
#   port        = 8000
#   protocol    = "TCP"
#   vpc_id      = aws_vpc.noteally_vpc.id
#   target_type = "instance"
# }


# #
# # ATTATCH TO TARGET GROUP
# #

# resource "aws_lb_target_group_attachment" "target_group_api_attachment" {
#   target_group_arn = aws_lb_target_group.target_group.arn
#   target_id        = aws_instance.ec2_api.id
#   port             = 8000
# }


# # 
# # LISTENER
# # 

# resource "aws_lb_listener" "api_listener" {
#   load_balancer_arn = aws_lb.network_load_balancer.arn
#   port              = "8000"
#   protocol          = "TCP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.target_group.arn
#   }
# }



# --------------------------------------------------------- Frontend EC2 ---------------------------------------------------------


# #
# # EC2 INSTANCE
# #

# resource "aws_instance" "ec2_frontend" {
#   ami                    = "ami-0fe8bec493a81c7da"
#   instance_type          = "t3.micro"
#   key_name               = aws_key_pair.aws_key_api.key_name
#   subnet_id              = aws_subnet.noteally_public_subnet[0].id
#   vpc_security_group_ids = [aws_security_group.frontend_sg.id]

#   tags = {
#     Name = "ec2-frontend"
#   }

#   depends_on = [
#     aws_internet_gateway.noteally_igw,
#     aws_nat_gateway.noteally_nat_gateway
#   ]
# }


# #
# # SECURITY GROUP
# #

# resource "aws_security_group" "frontend_sg" {
#   name        = "frontend_sg"
#   description = "Allow TCP and SSH traffic"
#   vpc_id      = aws_vpc.noteally_vpc.id

#   ingress {
#     from_port   = 5173
#     to_port     = 5173
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }



# --------------------------------------------------------- API Gateway ---------------------------------------------------------

# #
# # VPC LINK
# #

# resource "aws_api_gateway_vpc_link" "api_gateway_vpc_link" {
#   name        = "api_gateway_vpc_link"
#   description = "API Gateway VPC Link"
#   target_arns = [aws_lb.network_load_balancer.arn]
# }


# #
# # API GATEWAY
# #

# resource "aws_api_gateway_rest_api" "api_gateway" {
#   name        = "api_gateway"
#   description = "API Gateway"
# }


# #
# # API ENDPOINTS
# #

# resource "aws_api_gateway_resource" "api_gateway_resource" {
#   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#   parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
#   path_part   = "{proxy+}"
# }

# resource "aws_api_gateway_method" "example" {
#   authorization = "NONE"
#   http_method   = "ANY"
#   resource_id   = aws_api_gateway_resource.api_gateway_resource.id
#   rest_api_id   = aws_api_gateway_rest_api.api_gateway.id

#   request_parameters = {
#     "method.request.path.proxy" = true
#   }

# }

# resource "aws_api_gateway_integration" "test" {
#   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#   resource_id = aws_api_gateway_resource.api_gateway_resource.id
#   http_method = aws_api_gateway_method.example.http_method

#   type                    = "HTTP_PROXY"
#   integration_http_method = "ANY"
#   uri                     = "http://${aws_lb.network_load_balancer.dns_name}:8000/api/v1/{proxy}/"

#   connection_type = "VPC_LINK"
#   connection_id   = aws_api_gateway_vpc_link.api_gateway_vpc_link.id

#   request_parameters = {
#     "integration.request.path.proxy" = "method.request.path.proxy"
#   }
# }


# #
# # API GATEWAY DEPLOYMENT
# #

# resource "aws_api_gateway_deployment" "example" {
#   rest_api_id = aws_api_gateway_rest_api.api_gateway.id

#   depends_on = [
#     aws_api_gateway_integration.test,
#   ]

#   triggers = {
#     redeployment = sha1(jsonencode([
#       aws_api_gateway_resource.api_gateway_resource,
#       aws_api_gateway_method.example,
#       aws_api_gateway_integration.test,
#     ]))
#   }

#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_api_gateway_stage" "example" {
#   deployment_id = aws_api_gateway_deployment.example.id
#   rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
#   stage_name    = "dev"
# }


# --------------------------------------------------------- AWS Cognito ---------------------------------------------------------

# #
# # USER POOL
# #

# resource "aws_cognito_user_pool" "user_pool" {
#   name = "user-pool"

#   username_attributes = ["email"]
#   auto_verified_attributes = ["email"]

#   password_policy {
#     minimum_length = 6
#   }

#   verification_message_template {
#     default_email_option = "CONFIRM_WITH_CODE"
#     email_subject = "Account Confirmation"
#     email_message = "Your confirmation code is {####}"
#   }

#   # email
#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = false
#     mutable                  = true
#     name                     = "email"
#     required                 = true

#     string_attribute_constraints {
#       min_length = 1
#       max_length = 100
#     }
#   }

#   # given_name
#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = false
#     mutable                  = true
#     name                     = "given_name"
#     required                 = true

#     string_attribute_constraints {
#       min_length = 1
#       max_length = 100
#     }
#   }

#   # family_name
#   schema {
#     attribute_data_type      = "String"
#     developer_only_attribute = false
#     mutable                  = true
#     name                     = "family_name"
#     required                 = true

#     string_attribute_constraints {
#       min_length = 1
#       max_length = 100
#     }
#   }
# }


# #
# # USER POOL DOMAIN
# #

# resource "aws_cognito_user_pool_domain" "user_pool_domain" {
#   domain        = "noteally"
#   user_pool_id  = aws_cognito_user_pool.user_pool.id
# }


# #
# # USER POOL CLIENT
# #

# resource "aws_cognito_user_pool_client" "userpool_client" {
#   name = "userpool-client"
#   user_pool_id = aws_cognito_user_pool.user_pool.id
#   callback_urls = ["http://${aws_lb.network_load_balancer.dns_name}:5173/materials"]
#   logout_urls = ["http://${aws_lb.network_load_balancer.dns_name}:5173/index"]

#   allowed_oauth_flows_user_pool_client = true
#   allowed_oauth_flows = ["implicit"]
#   explicit_auth_flows = ["ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_SRP_AUTH"]
#   allowed_oauth_scopes = ["email", "openid"]
#   supported_identity_providers = ["COGNITO"]
# }
