#
# PUBLIC EC2 - FOR TESTING
#

resource "aws_instance" "ec2_public" {
  ami                    = "ami-0fe8bec493a81c7da"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.aws_key_api.key_name
  subnet_id              = aws_subnet.public_subnet[0].id
  vpc_security_group_ids = [aws_security_group.public_ec2_sg.id]

  tags = {
    Name = "ec2-public"
  }

  depends_on = [
    aws_internet_gateway.igw,
    aws_nat_gateway.nat_gateway
  ]
}


#
# SECURITY GROUP
#

resource "aws_security_group" "public_ec2_sg" {
  name        = "public_ec2_sg"
  description = "Allow TCP and SSH traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
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
