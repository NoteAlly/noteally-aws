#
# NETWORK LOAD BALANCER
#

resource "aws_lb" "network_load_balancer" {
  name               = "network-load-balancer"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.private_subnet[0].id]
  security_groups    = [aws_security_group.nlb_sg.id]


  tags = {
    Environment = "production"
  }
}


#
# INFO-SERVICE - TARGET GROUP
#

resource "aws_lb_target_group" "info-service-tg" {
  name        = "info-service-tg"
  port        = 8000
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"
}


# 
# INFO-SERVICE - LISTENER
# 

resource "aws_lb_listener" "info-service-listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "8000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.info-service-tg.arn
  }
}


#
# AUTH-SERVICE - TARGET GROUP
#

resource "aws_lb_target_group" "auth-service-tg" {
  name        = "auth-service-tg"
  port        = 8001
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"
}


# 
# AUTH-SERVICE - LISTENER
# 

resource "aws_lb_listener" "auth-service-listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "8001"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auth-service-tg.arn
  }
}


# 
# MATERIAL-SERVICE - TARGET GROUP
# 

resource "aws_lb_target_group" "material-service-tg" {
  name        = "material-service-tg"
  port        = 8002
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"
}


# 
# MATERIAL-SERVICE - LISTENER
# 

resource "aws_lb_listener" "material-service-listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "8002"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.material-service-tg.arn
  }
}


# 
# TUTOR-SERVICE - TARGET GROUP
# 

resource "aws_lb_target_group" "tutor-service-tg" {
  name        = "tutor-service-tg"
  port        = 8003
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"
}


# 
# TUTOR-SERVICE - LISTENER
# 

resource "aws_lb_listener" "tutor-service-listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "8003"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tutor-service-tg.arn
  }
}


# 
# USER-SERVICE - TARGET GROUP
# 

resource "aws_lb_target_group" "user-service-tg" {
  name        = "user-service-tg"
  port        = 8004
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "ip"
}


# 
# USER-SERVICE - LISTENER
# 

resource "aws_lb_listener" "user-service-listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "8004"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.user-service-tg.arn
  }
}


#
# ECS SECURITY GROUP
#

resource "aws_security_group" "nlb_sg" {
  name        = "nlb_sg"
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
