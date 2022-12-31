resource "aws_subnet" "public-subnet" {
  count             = length(var.cidr_subnets_block_public)
  vpc_id            = aws_vpc.ohio-vpc.id
  cidr_block        = element(var.cidr_subnets_block_public, count.index)
  availability_zone = element(var.availability_zones_us_east_2, count.index)
  tags = {
    Name = "${var.vpc_name}-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private-subnet" {
  count             = length(var.cidr_subnets_block_private)
  vpc_id            = aws_vpc.ohio-vpc.id
  cidr_block        = element(var.cidr_subnets_block_private, count.index)
  availability_zone = element(var.availability_zones_us_east_2, count.index)
  tags = {
    Name = "${var.vpc_name}-private-subnet-${count.index + 1}"
  }
}
