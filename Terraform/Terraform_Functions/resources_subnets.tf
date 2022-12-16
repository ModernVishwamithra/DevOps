# resource "aws_subnet" "ohio-public-subent-1" {
# availability_zone = "us-ease-2a"
# cidr_block = var.cidr_subnet_public1
# vpc_id = aws_vpc.ohio-vpc.id
# tags = {
#   "Name" = "Ohio-public-subent-1"
# }
# }

# resource "aws_subnet" "ohio-public-subent-2" {
#     vpc_id = aws_vpc.ohio-vpc.id
#     availability_zone = "us-east-2b"
#     cidr_block = var.cidr_subnet_public2
#     tags = {
#       "Name" = "Ohio-public-subent2"
#     }

# }

# resource "aws_subnet" "ohio-public-subent-3" {
#     vpc_id = aws_vpc.ohio-vpc.id
#     availability_zone = "us-east-2c"
#     cidr_block = var.cidr_subnet_public3
#     tags = {
#       "Name" = "Ohio-public-subent3"
#     }

# }

# *** Using COUNT & ELEMENT functions****
# in the above code, we observe that code is duplicate, except avaliablily zone, tag, cidr block
# so we can do how to reuse code and use COUNT & ELEMENT functions to simplify code

resource "aws_subnet" "ohio-public-subnets" {
  #count = 3 #0,1,2 this is the static way of giving count
  count             = length(var.cidr_subnets_block_public)                  //dynamic way of giving count value
  availability_zone = element(var.availability_zones_us_east_2, count.index) //if index exceeds the last element value, it starts taking again from first value
  cidr_block        = element(var.cidr_subnets_block_public, count.index)
  vpc_id            = aws_vpc.ohio-vpc.id
  tags = {
    "Name" = "Ohio-public-subent-${count.index + 1}"
  }
}

resource "aws_subnet" "ohio-private-subnets" {
  #count = 3 #0,1,2
  count             = length(var.cidr_subnets_block_private)                 //dynamic way of giving count value
  availability_zone = element(var.availability_zones_us_east_2, count.index) //if index exceeds the last element value, it starts taking again from first value
  cidr_block        = element(var.cidr_subnets_block_private, count.index)
  vpc_id            = aws_vpc.ohio-vpc.id
  tags = {
    "Name" = "Ohio-private-subent-${count.index + 1}"
  }
}