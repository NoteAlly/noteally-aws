terraform {
  required_version = ">= 0.12"
}


#
# INSTANCE
#

resource "aws_vpc" "noteally_vpc" {
  cidr_block = "10.0.0.0/24"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "noteally-vpc"
  }
}




#
# Subnets
#

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.0.0/25"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.0.128/25"]
}

variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["us-east-1a"]
}

  #
  # Public Subnet
  #

  resource "aws_subnet" "noteally_public_subnet" {
    count                   = length(var.public_subnet_cidrs)
    vpc_id                  = aws_vpc.noteally_vpc.id
    cidr_block              = element(var.public_subnet_cidrs, count.index)
    availability_zone       = element(var.azs, count.index)
    
    map_public_ip_on_launch = true

    tags = {
      Name = "noteally_public_subnet_${count.index}"
    }
  }

  #
  # Private Subnet
  #

  resource "aws_subnet" "noteally_private_subnet" {
    count                   = length(var.private_subnet_cidrs)
    vpc_id                  = aws_vpc.noteally_vpc.id
    cidr_block              = element(var.private_subnet_cidrs, count.index)
    availability_zone       = element(var.azs, count.index)

    tags = {
      Name = "noteally_private_subnet_${count.index}"
    }
  }




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




#
# Internet Gateway
#

resource "aws_internet_gateway" "noteally_igw" {
  vpc_id = aws_vpc.noteally_vpc.id

  tags = {
    Name = "noteally_igw"
  }
}




#
# Elastic IP
#

# Generate a new Elastic IP
resource "aws_eip" "noteally_eip" {
  domain = "vpc"

  tags = {
    Name = "noteally_eip"
  }
}




#
# NAT Gateway
#

resource "aws_nat_gateway" "noteally_nat_gateway" {
  allocation_id = aws_eip.noteally_eip.id
  subnet_id     = aws_subnet.noteally_public_subnet[0].id

  tags = {
    Name = "noteally_nat_gateway"
  }
}




#
# Routing Tables
#

  #
  # Public Routing Table
  #

  resource "aws_route_table" "noteally_public_rt" {
    vpc_id = aws_vpc.noteally_vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.noteally_igw.id
    }

    tags = {
      Name = "noteally_public_rt"
    }
  }

  resource "aws_route_table_association" "noteally_public_subnet_association" {
    count = length(var.public_subnet_cidrs)
    subnet_id      = aws_subnet.noteally_public_subnet[count.index].id
    route_table_id = aws_route_table.noteally_public_rt.id
  }

  #
  # Private Routing Table
  #

  resource "aws_route_table" "noteally_private_rt" {
    vpc_id = aws_vpc.noteally_vpc.id

    route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_nat_gateway.noteally_nat_gateway.id
    }

    tags = {
      Name = "noteally_private_rt"
    }
  }

  resource "aws_route_table_association" "noteally_private_subnet_association" {
    subnet_id      = aws_subnet.noteally_private_subnet[0].id
    route_table_id = aws_route_table.noteally_private_rt.id
  }
