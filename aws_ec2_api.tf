#
# EC2 INSTANCE
#

resource "aws_instance" "ec2_api" {
  ami                    = "ami-0fe8bec493a81c7da"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.aws_key_api.key_name
  subnet_id              = aws_subnet.private_subnet[0].id
  vpc_security_group_ids = [aws_security_group.api_sg.id]
  user_data              = local.user_data
  depends_on = [
    aws_internet_gateway.igw,
    aws_nat_gateway.nat_gateway
  ]

  tags = {
    Name = "ec2-api"
  }
}


#
# SECURITY GROUP
#

resource "aws_security_group" "api_sg" {
  name        = "api_sg"
  description = "Allow TCP and SSH traffic"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

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


#
# KEY PAIR
#

resource "aws_key_pair" "aws_key_api" {
  key_name   = "aws_key"
  public_key = file("keys/aws-key-api.pub")
}


#
# INIT SCRIPT
#

locals {
  user_data = templatefile(
    "scripts/init_ec2_api.sh",
    {
      GITHUB_PAT            = local.envs["GITHUB_PAT"]
      DJANGO_KEY            = local.envs["DJANGO_KEY"]
      AWS_ACCESS_KEY_ID     = local.envs["AWS_ACCESS_KEY_ID"]
      AWS_SECRET_ACCESS_KEY = local.envs["AWS_SECRET_ACCESS_KEY"]
      AWS_REGION_NAME       = local.envs["AWS_DEFAULT_REGION"]
      AWS_S3_BUCKET_NAME    = local.envs["AWS_S3_BUCKET_NAME"]
      DB_NAME               = local.envs["DB_NAME"]
      DB_USERNAME           = local.envs["DB_USERNAME"]
      DB_PASSWORD           = local.envs["DB_PASSWORD"]
      DB_PORT               = local.envs["DB_PORT"]
      DB_HOST               = aws_db_instance.postgres_db.address
    }
  )
}
