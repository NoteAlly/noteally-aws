#
# AWS RDS - POSTGRES
#

resource "aws_db_instance" "postgres_db" {
  engine         = "postgres"
  engine_version = "15.3"

  multi_az = false

  identifier = local.envs["DB_IDENTIFIER"]
  db_name    = local.envs["DB_NAME"]
  username   = local.envs["DB_USERNAME"]
  password   = local.envs["DB_PASSWORD"]
  port       = local.envs["DB_PORT"]

  instance_class    = "db.t3.micro"
  allocated_storage = 20
  storage_type      = "gp2"

  publicly_accessible    = false
  vpc_security_group_ids = [aws_security_group.db_security_group.id]
  db_subnet_group_name   = aws_db_subnet_group.postgres_db_subnet_group.name

  storage_encrypted   = true
  deletion_protection = false

  skip_final_snapshot = true
  apply_immediately   = true
}


# 
# AWS RDS - SUBNET GROUP
# 

resource "aws_db_subnet_group" "postgres_db_subnet_group" {
  name       = "db-subnet-group"
  subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]
  tags = {
    Name = "db-subnet-group"
  }
}


# 
# AWS RDS - Security Group
#

resource "aws_security_group" "db_security_group" {
  name        = "database-sg"
  description = "Allow TCP traffic on port 5432"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    description = "Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "database-sg"
  }
}
