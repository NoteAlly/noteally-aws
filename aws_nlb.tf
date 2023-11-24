#
# NETWORK LOAD BALANCER
#

resource "aws_lb" "network_load_balancer" {
  name               = "network-load-balancer"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.private_subnet[0].id]
  security_groups    = [aws_security_group.api_sg.id]


  tags = {
    Environment = "production"
  }
}


#
# TARGET GROUP
#

resource "aws_lb_target_group" "target_group" {
  name        = "rest-api-target-group"
  port        = 8000
  protocol    = "TCP"
  vpc_id      = aws_vpc.vpc.id
  target_type = "instance"
}


#
# ATTACH PRIV. EC2 TO TARGET GROUP
#

resource "aws_lb_target_group_attachment" "target_group_api_attachment" {
  target_group_arn = aws_lb_target_group.target_group.arn
  target_id        = aws_instance.ec2_api.id
  port             = 8000
}


# 
# LISTENER
# 

resource "aws_lb_listener" "api_listener" {
  load_balancer_arn = aws_lb.network_load_balancer.arn
  port              = "8000"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_group.arn
  }
}
