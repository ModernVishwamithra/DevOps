#terrform syntax for resources is 
# resource "resource-type" "resource-name" {
#  
# }

# ** It is importatnt that terraform identifies/isolates the resources based on "resource-name"
# if we are creating resources :example '2 vpcs', we should not give "resource-name" same
# if we are creating different resources  :example '1 vpc and 1 instance', we can provide same "resource-name" 


resource "aws_vpc" "testvpc" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name        = var.vpc_name
    Owner       = "Pavan"
    Environment = var.env
  }
}

