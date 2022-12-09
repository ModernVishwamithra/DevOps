#terrform syntax for resources is 
# resource "resource-type" "resource-name" {
#  
# }

# ** It is importatnt that terraform identifies/isolates the resources based on "resource-name"
# if we are creating resources :example '2 vpcs', we should not give "resource-name" same
# if we are creating different resources  :example '1 vpc and 1 instance', we can provide same "resource-name" 


resource "aws_vpc" "testvpc1" {
  cidr_block           = var.cidr_block_vpc1 //old way of giving variables
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "testvpc1"
    Owner       = "Pavan"
    Environment = var.env
  }
}

resource "aws_vpc" "testvpc2" {
  cidr_block           = var.cidr_block_vpc2
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "testvpc2"
    Owner       = "Pavan"
    Environment = var.env
  }
}

resource "aws_vpc" "testvpc3" {
  cidr_block           = var.cidr_block_vpc3
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = "testvpc3"
    Owner       = "Pavan"
    Environment = var.env
  }
}

# resource "aws_vpc" "testvpc4" {
#   cidr_block           = "10.4.0.0/24"
#   enable_dns_hostnames = true
#   enable_dns_support   = true
#   tags = {
#     Name        = "main4"
#     Owner       = "Pavan"
#     Environment = "Dev"
#   }
# }

