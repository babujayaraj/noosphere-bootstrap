resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${var.project}-${var.environment}-vpc"
  }
}

# resource "aws_subnet" "public" 2 subnets for extendability
locals {
  public_subnets = {
    public_a = {
      cidr_block = "10.0.1.0/24"
      az         = "${var.region}a"
    }
    public_b = {
      cidr_block = "10.0.2.0/24"
      az         = "${var.region}b"
    }
  }
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = each.value.az
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.project}-${var.environment}-${each.key}"
    Tier = "public"
  }
}


