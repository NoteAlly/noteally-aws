#
# VPC
#

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "noteally-vpc"
  }
}


#
# PUBLIC SUBNET
#

resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  map_public_ip_on_launch = true

  tags = {
    Name = "noteally_public_subnet_${count.index}"
  }
}


#
# PRIVATE SUBNETS (2 AZs - required for RDS)
#

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = element(var.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "noteally_private_subnet_${count.index}"
  }
}


#
# INTERNET GATEWAY
#

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "noteally_igw"
  }
}


#
# ELASTIC IP
#

resource "aws_eip" "eip" {
  domain = "vpc"

  tags = {
    Name = "noteally_eip"
  }
}


#
# NAT GATEWAY
#

resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public_subnet[0].id

  tags = {
    Name = "noteally_nat_gateway"
  }

  depends_on = [
    aws_internet_gateway.igw
  ]
}


#
# PUBLIC ROUTING TABLE
#

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "noteally_public_rt"
  }
}

resource "aws_route_table_association" "public_subnet_association" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


#
# PRIVATE ROUTING TABLE
#

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }

  tags = {
    Name = "noteally_private_rt"
  }
}

resource "aws_route_table_association" "private_subnet_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
