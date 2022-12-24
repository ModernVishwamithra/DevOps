resource "aws_route_table" "ohio-route-table-public" {
  vpc_id = aws_vpc.ohio-vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ohio-igw.id
  }
  tags = {
    "Name" = "ohio-route-table-public"
  }

}

resource "aws_route_table" "ohio-route-table-private" {
  vpc_id = aws_vpc.ohio-vpc.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ohio-nat-gw.id
  }
  tags = {
    "Name" = "ohio-route-table-private"
  }
}
# resource "aws_route_table_association" "ohio-rt-asso-1" {
#   subnet_id      = aws_subnet.ohio-public-subent-1.id
#   route_table_id = aws_route_table.ohio-route-table-public.id
# }


# resource "aws_route_table_association" "ohio-rt-asso-2" {
#   subnet_id      = aws_subnet.ohio-public-subent-2.id
#   route_table_id = aws_route_table.ohio-route-table-public.id
# }


# resource "aws_route_table_association" "ohio-rt-asso-3" {
#   subnet_id      = aws_subnet.ohio-public-subent-3.id
#   route_table_id = aws_route_table.ohio-route-table-public.id
# }

# here as shown above, to associate 3 subnets we need to create 3 blocks of code, again repeated code
# we can simplify this, by using splank operator '*', it replaces * with count.index

resource "aws_route_table_association" "ohio-rt-asso-1" {
  #count = 3 //static way of giving count value
  count          = length(var.cidr_subnets_block_public) //dynamic way of giving count value
  subnet_id      = element(aws_subnet.ohio-public-subnets.*.id, count.index)
  route_table_id = aws_route_table.ohio-route-table-public.id
}
resource "aws_route_table_association" "ohio-rt-asso-2" {
  #count = 3
  count          = length(var.cidr_subnets_block_private) //dynamic way of giving count value
  subnet_id      = element(aws_subnet.ohio-private-subnets.*.id, count.index)
  route_table_id = aws_route_table.ohio-route-table-private.id
}