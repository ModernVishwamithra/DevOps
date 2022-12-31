resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.ohio-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "Public-routing-table"
    Env  = "Dev"
  }
}

resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.ohio-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }
  tags = {
    Name = "Private-routing-table"
    Env  = "Dev"
  }
}


resource "aws_route_table_association" "public-rt-assoc" {
  count          = length(var.cidr_subnets_block_public)
  route_table_id = aws_route_table.public-route-table.id
  subnet_id      = element(aws_subnet.public-subnet.*.id, count.index)
}


resource "aws_route_table_association" "private-rt-assoc" {
  count          = length(var.cidr_subnets_block_private)
  route_table_id = aws_route_table.private-route-table.id
  subnet_id      = element(aws_subnet.private-subnet.*.id, count.index)
}