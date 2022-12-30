resource "aws_vpc" "ohio-vpc" {
  cidr_block = var.cidr_block_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags =   {    
    Name = var.vpc_name
  }
}