# 
# ECS CLUSTER
# 

resource "aws_ecs_cluster" "cluster" {
  name = "noteally_cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}


# 
# TEMPLATE FILE
# 

locals {
  ecs_task_definition = templatefile(
    "templates/ecs_task_definition.json",
    {
      info_image     = "${local.envs["AWS_ECR_PREFIX"]}/noteally:info-service"
      info_container_port = "8000"
      info_host_port     = "8000"
      
      auth_image     = "${local.envs["AWS_ECR_PREFIX"]}/noteally:auth-service"
      auth_container_port = "8001"
      auth_host_port     = "8001"

      material_image     = "${local.envs["AWS_ECR_PREFIX"]}/noteally:material-service"
      material_container_port = "8002"
      material_host_port     = "8002"

      tutor_image     = "${local.envs["AWS_ECR_PREFIX"]}/noteally:tutor-service"
      tutor_container_port = "8003"
      tutor_host_port     = "8003"

      user_image     = "${local.envs["AWS_ECR_PREFIX"]}/noteally:user-service"
      user_container_port = "8004"
      user_host_port     = "8004"

      fargate_cpu    = 256
      fargate_memory = 512
      log_group_name = aws_cloudwatch_log_group.log_group.name

      django_key        = "${local.envs["DJANGO_KEY"]}"
      aws_access_key_id = "${local.envs["AWS_ACCESS_KEY_ID"]}"
      aws_secret_access_key = "${local.envs["AWS_SECRET_ACCESS_KEY"]}"
      aws_account_id = "${local.envs["AWS_ACCOUNT_ID"]}"
      aws_region     = "${local.envs["AWS_REGION_NAME"]}"
      aws_cognito_domain = "${local.envs["AWS_COGNITO_DOMAIN"]}"
      aws_s3_private_bucket_name = "${local.envs["AWS_S3_PRIVATE_BUCKET_NAME"]}"
      aws_s3_public_bucket_name = "${local.envs["AWS_S3_PUBLIC_BUCKET_NAME"]}"
      db_name = "${local.envs["DB_NAME"]}"
      db_username = "${local.envs["DB_USERNAME"]}"
      db_password = "${local.envs["DB_PASSWORD"]}"
      db_host = aws_db_instance.postgres_db.address
      # db_host = "${local.envs["DB_HOST"]}"
      db_port = "${local.envs["DB_PORT"]}"
    }
  )
}


#
# TASK DEFINITION
#

resource "aws_ecs_task_definition" "task_definition" {
  family                   = "noteally_task_definition"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 2048
  memory                   = 4096
  container_definitions    = local.ecs_task_definition
}


#
# ECS SERVICE
#

resource "aws_ecs_service" "service" {
  name            = "noteally_service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_sg.id]
    subnets          = [aws_subnet.private_subnet[0].id]
    assign_public_ip = false
  }

  # info-service
  load_balancer {
    target_group_arn = aws_lb_target_group.info-service-tg.arn
    container_name   = "info-service"
    container_port   = 8000
  }

  # auth-service
  load_balancer {
    target_group_arn = aws_lb_target_group.auth-service-tg.arn
    container_name   = "auth-service"
    container_port   = 8001
  }

  # material-service
  load_balancer {
    target_group_arn = aws_lb_target_group.material-service-tg.arn
    container_name   = "material-service"
    container_port   = 8002
  }

  # tutor-service
  load_balancer {
    target_group_arn = aws_lb_target_group.tutor-service-tg.arn
    container_name   = "tutor-service"
    container_port   = 8003
  }

  # user-service
  load_balancer {
    target_group_arn = aws_lb_target_group.user-service-tg.arn
    container_name   = "user-service"
    container_port   = 8004
  }

  depends_on = [
    aws_lb_listener.info-service-listener,
    aws_lb_listener.auth-service-listener,
    aws_lb_listener.material-service-listener,
    aws_lb_listener.tutor-service-listener,
    aws_iam_role_policy_attachment.ecs_task_execution_role]
}


#
# ECS SECURITY GROUP
#

resource "aws_security_group" "ecs_sg" {
  name        = "ecs_sg"
  description = "Allow TCP traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8001
    to_port     = 8001
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8002
    to_port     = 8002
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8003
    to_port     = 8003
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8004
    to_port     = 8004
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
