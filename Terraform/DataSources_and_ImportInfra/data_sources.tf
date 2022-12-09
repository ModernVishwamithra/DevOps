
#vpc
data "aws_vpc" "ohio-vpc" {
  id = var.vpc_id
}

#route-table
data "aws_route_table" "ohio-vpc-route_table" {
  route_table_id = var.ohio_public_route_table_id
  vpc_id     = data.aws_vpc.ohio-vpc.id
}