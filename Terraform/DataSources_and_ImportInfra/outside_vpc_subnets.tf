resource "aws_subnet" "ohio_vpc_public-subnet-2" {
  vpc_id     = data.aws_vpc.ohio-vpc.id
  cidr_block = var.cidr_block_ohio_public-subnet-2
  tags = {
    Name = "${var.ohio_vpc_name}-public-subnet-2"
  }
}

resource "aws_route_table_association" "rt_association-ohio-public-subnet-1" {
  subnet_id      = aws_subnet.ohio_vpc_public-subnet-2.id
  route_table_id = data.aws_route_table.ohio-vpc-route_table.id
}